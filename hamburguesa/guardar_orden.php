<?php
require_once 'db_config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Error al decodificar JSON: ' . json_last_error_msg());
        }

        if (!isset($data['productos']) || !isset($data['total'])) {
            throw new Exception('Datos incompletos');
        }

        // Iniciar transacción
        $pdo->beginTransaction();
        
        // Insertar la orden principal
        $stmt = $pdo->prepare("INSERT INTO ordenes (fecha, total, estado) VALUES (NOW(), :total, 'pendiente')");
        $stmt->execute([
            ':total' => $data['total']
        ]);
        
        $orden_id = $pdo->lastInsertId();
        
        // Insertar los detalles de la orden
        $stmt = $pdo->prepare("INSERT INTO orden_detalles (orden_id, producto_id, cantidad, precio_unitario) 
                              VALUES (:orden_id, :producto_id, :cantidad, :precio)");
        
        foreach ($data['productos'] as $producto) {
            if (!isset($producto['id']) || !isset($producto['cantidad']) || !isset($producto['precio'])) {
                throw new Exception('Datos de producto incompletos');
            }

            $stmt->execute([
                ':orden_id' => $orden_id,
                ':producto_id' => $producto['id'],
                ':cantidad' => $producto['cantidad'],
                ':precio' => $producto['precio']
            ]);
        }
        
        // Confirmar transacción
        $pdo->commit();
        
        echo json_encode([
            'success' => true,
            'message' => 'Orden guardada exitosamente',
            'orden_id' => $orden_id
        ]);
        
    } catch (Exception $e) {
        // Revertir transacción en caso de error
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        
        echo json_encode([
            'success' => false,
            'message' => 'Error al guardar la orden: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Método no permitido'
    ]);
}
?> 