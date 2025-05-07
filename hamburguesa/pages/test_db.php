<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

try {
    require_once '../db_config.php';
    
    echo "Conexión a la base de datos exitosa.<br>";
    
    // Verificar tablas
    $tables = ['productos', 'ordenes', 'orden_detalles'];
    foreach ($tables as $table) {
        $stmt = $pdo->query("SHOW TABLES LIKE '$table'");
        if ($stmt->rowCount() > 0) {
            echo "Tabla '$table' existe.<br>";
            
            // Si es la tabla productos, verificar si tiene datos
            if ($table === 'productos') {
                $stmt = $pdo->query("SELECT COUNT(*) as count FROM productos");
                $count = $stmt->fetch()['count'];
                echo "La tabla productos tiene $count registros.<br>";
            }
        } else {
            echo "¡ADVERTENCIA! La tabla '$table' no existe.<br>";
        }
    }
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?> 