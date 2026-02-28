<?php
/**
 * API del catálogo de rodamientos (conexión a BD).
 * GET/POST: mode=codigo|dimensiones
 * - codigo: requiere al menos 2 caracteres. Búsqueda por coincidencia en código.
 * - dimensiones: dInterior, dExterior, espesor (mm).
 * Respuesta: JSON con array de { codigo, dInterior, dExterior, espesor, descripcion }
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');

if (!file_exists(__DIR__ . '/config.php')) {
    http_response_code(500);
    echo json_encode(['error' => 'Configuración no encontrada. Copie config.example.php a config.php y configure la base de datos.']);
    exit;
}

require __DIR__ . '/config.php';

$mode = isset($_REQUEST['mode']) ? trim($_REQUEST['mode']) : '';
$codigo = isset($_REQUEST['codigo']) ? trim($_REQUEST['codigo']) : '';
$dInterior = isset($_REQUEST['dInterior']) ? trim($_REQUEST['dInterior']) : '';
$dExterior = isset($_REQUEST['dExterior']) ? trim($_REQUEST['dExterior']) : '';
$espesor = isset($_REQUEST['espesor']) ? trim($_REQUEST['espesor']) : '';

$dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
$opts = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];

try {
    $pdo = new PDO($dsn, DB_USER, DB_PASS, $opts);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error de conexión a la base de datos.']);
    exit;
}

$results = [];

if ($mode === 'codigo') {
    $codigoLen = mb_strlen($codigo);
    if ($codigoLen < 2) {
        echo json_encode([]);
        exit;
    }
    $stmt = $pdo->prepare(
        "SELECT codigo, diametro_interior_mm AS dInterior, diametro_exterior_mm AS dExterior, espesor_mm AS espesor, descripcion
         FROM catalogo_rodamientos
         WHERE activo = 1 AND codigo LIKE :codigo
         ORDER BY codigo
         LIMIT 200"
    );
    $stmt->execute(['codigo' => '%' . $codigo . '%']);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
} elseif ($mode === 'dimensiones') {
    $vInt = $dInterior !== '' ? (int) $dInterior : null;
    $vExt = $dExterior !== '' ? (int) $dExterior : null;
    $vEsp = $espesor !== '' ? (int) $espesor : null;
    if ($vInt === null && $vExt === null && $vEsp === null) {
        echo json_encode([]);
        exit;
    }
    $sql = "SELECT codigo, diametro_interior_mm AS dInterior, diametro_exterior_mm AS dExterior, espesor_mm AS espesor, descripcion
            FROM catalogo_rodamientos
            WHERE activo = 1";
    $params = [];
    if ($vInt !== null) {
        $sql .= " AND diametro_interior_mm = :dInt";
        $params['dInt'] = $vInt;
    }
    if ($vExt !== null) {
        $sql .= " AND diametro_exterior_mm = :dExt";
        $params['dExt'] = $vExt;
    }
    if ($vEsp !== null) {
        $sql .= " AND espesor_mm = :esp";
        $params['esp'] = $vEsp;
    }
    $sql .= " ORDER BY codigo LIMIT 200";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
} else {
    echo json_encode([]);
    exit;
}

echo json_encode($results);
