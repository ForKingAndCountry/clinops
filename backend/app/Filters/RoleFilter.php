<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

class RoleFilter implements FilterInterface
{
    protected $allowedRoles = [];

    public function __construct()
    {
        // Get allowed roles from the filter arguments
        $this->allowedRoles = func_get_args();
    }

    public function before(RequestInterface $request, $arguments = null)
    {
        $user = auth()->user();

        if (!$user) {
            return $this->unauthorized('Not authenticated');
        }

        if (empty($arguments)) {
            return $this->unauthorized('No roles specified');
        }

        $userRoles = $user->getRoles();
        $userRoleNames = array_map(function($role) {
            return $role->name;
        }, $userRoles);

        // Check if user has any of the required roles
        $hasAccess = false;
        foreach ($arguments as $requiredRole) {
            if (in_array($requiredRole, $userRoleNames)) {
                $hasAccess = true;
                break;
            }
        }

        if (!$hasAccess) {
            return $this->forbidden('Insufficient permissions');
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // Do nothing
    }

    private function unauthorized($message)
    {
        return service('response')
            ->setStatusCode(401)
            ->setJSON([
                'status' => 'error',
                'message' => $message,
            ]);
    }

    private function forbidden($message)
    {
        return service('response')
            ->setStatusCode(403)
            ->setJSON([
                'status' => 'error',
                'message' => $message,
            ]);
    }
}
