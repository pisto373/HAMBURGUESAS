<?php
// Habilitar todos los errores y logging
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', 'debug.log');

// Configurar cabeceras CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Max-Age: 86400'); // 24 horas

// Manejar solicitud OPTIONS (preflight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Configurar tipo de contenido para respuestas JSON
header('Content-Type: application/json; charset=utf-8');

// Función para logging
function debug_log($message, $data = null) {
    $log = date('Y-m-d H:i:s') . " - " . $message;
    if ($data !== null) {
        $log .= "\n" . print_r($data, true);
    }
    error_log($log . "\n");
}

try {
    debug_log("Iniciando proceso de orden");

    if (!file_exists('../db_config.php')) {
        throw new Exception('El archivo de configuración de la base de datos no existe');
    }

    require_once '../db_config.php';
    debug_log("Base de datos conectada");

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = file_get_contents('php://input');
        debug_log("Datos recibidos (raw):", $input);

        if (empty($input)) {
            throw new Exception('No se recibieron datos');
        }

        $data = json_decode($input, true);
        debug_log("Datos decodificados:", $data);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Error al decodificar JSON: ' . json_last_error_msg());
        }

        if (!isset($data['productos']) || !isset($data['total'])) {
            throw new Exception('Datos incompletos. Se requiere productos y total.');
        }

        if (empty($data['productos'])) {
            throw new Exception('No hay productos en la orden');
        }

        // Iniciar transacción
        $pdo->beginTransaction();
        debug_log("Transacción iniciada");
        
        // Insertar la orden principal
        $stmt = $pdo->prepare("INSERT INTO ordenes (fecha, total, estado) VALUES (NOW(), :total, 'pendiente')");
        $stmt->execute([
            ':total' => $data['total']
        ]);
        
        $orden_id = $pdo->lastInsertId();
        debug_log("Orden principal creada con ID: " . $orden_id);
        
        // Insertar los detalles de la orden
        $stmt = $pdo->prepare("INSERT INTO orden_detalles (orden_id, producto_id, cantidad, precio_unitario) 
                              VALUES (:orden_id, :producto_id, :cantidad, :precio)");
        
        foreach ($data['productos'] as $index => $producto) {
            debug_log("Procesando producto " . ($index + 1) . ":", $producto);

            if (!isset($producto['id']) || !isset($producto['cantidad']) || !isset($producto['precio'])) {
                throw new Exception('Datos de producto incompletos en índice ' . $index);
            }

            // Verificar que el producto existe
            $checkStmt = $pdo->prepare("SELECT id FROM productos WHERE id = ?");
            $checkStmt->execute([$producto['id']]);
            if ($checkStmt->rowCount() === 0) {
                throw new Exception('El producto con ID ' . $producto['id'] . ' no existe');
            }

            $stmt->execute([
                ':orden_id' => $orden_id,
                ':producto_id' => $producto['id'],
                ':cantidad' => $producto['cantidad'],
                ':precio' => $producto['precio']
            ]);
            debug_log("Detalle de orden guardado para producto ID: " . $producto['id']);
        }
        
        // Confirmar transacción
        $pdo->commit();
        debug_log("Transacción completada exitosamente");
        
        echo json_encode([
            'success' => true,
            'message' => 'Orden guardada exitosamente',
            'orden_id' => $orden_id
        ]);
        
    } else {
        throw new Exception('Método no permitido: ' . $_SERVER['REQUEST_METHOD']);
    }
} catch (Exception $e) {
    debug_log("ERROR: " . $e->getMessage());
    debug_log("Trace: " . $e->getTraceAsString());

    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
        debug_log("Transacción revertida");
    }
    
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Error al guardar la orden: ' . $e->getMessage(),
        'debug_info' => [
            'error_type' => get_class($e),
            'file' => $e->getFile(),
            'line' => $e->getLine()
        ]
    ]);
}
?> 