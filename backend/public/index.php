<?php

// Simple health check endpoint
header('Content-Type: application/json');

$path = $_SERVER['REQUEST_URI'] ?? '/';

if ($path === '/api/health' || strpos($path, '/api/health') === 0) {
    echo json_encode([
        'status' => 'ok',
        'message' => 'Clinic API is running',
        'timestamp' => date('Y-m-d H:i:s')
    ]);
} else {
    http_response_code(404);
    echo json_encode([
        'status' => 'error',
        'message' => 'Not found'
    ]);
}
