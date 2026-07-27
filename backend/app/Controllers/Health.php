<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class Health extends ResourceController
{
    public function index()
    {
        return $this->respond([
            'status' => 'ok',
            'message' => 'Clinic API is running',
            'timestamp' => date('Y-m-d H:i:s')
        ]);
    }
}
