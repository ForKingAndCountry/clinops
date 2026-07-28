<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;
use CodeIgniter\Shield\Entities\User;
use CodeIgniter\Shield\Models\UserModel;

class Auth extends ResourceController
{
    public function login()
    {
        $rules = [
            'email' => 'required|valid_email',
            'password' => 'required|min_length[8]',
        ];

        if (!$this->validate($rules)) {
            return $this->fail([
                'status' => 'error',
                'message' => 'Validation failed',
                'errors' => $this->validator->getErrors(),
            ], 422);
        }

        $email = $this->request->getPost('email');
        $password = $this->request->getPost('password');

        $userModel = new UserModel();
        $user = $userModel->findByCredentials($email);

        if (!$user || !$user->verifyPassword($password)) {
            return $this->fail([
                'status' => 'error',
                'message' => 'Invalid credentials',
            ], 401);
        }

        if (!$user->active) {
            return $this->fail([
                'status' => 'error',
                'message' => 'Account is inactive',
            ], 403);
        }

        // Log the user in
        auth()->login($user);

        // Get user roles
        $roles = $user->getRoles();
        $roleNames = array_map(function($role) {
            return $role->name;
        }, $roles);

        return $this->respond([
            'status' => 'success',
            'message' => 'Login successful',
            'data' => [
                'user' => [
                    'id' => $user->id,
                    'username' => $user->username,
                    'email' => $user->email,
                    'first_name' => $user->first_name ?? null,
                    'last_name' => $user->last_name ?? null,
                ],
                'roles' => $roleNames,
            ],
        ]);
    }

    public function logout()
    {
        auth()->logout();

        return $this->respond([
            'status' => 'success',
            'message' => 'Logout successful',
        ]);
    }

    public function me()
    {
        $user = auth()->user();

        if (!$user) {
            return $this->fail([
                'status' => 'error',
                'message' => 'Not authenticated',
            ], 401);
        }

        $roles = $user->getRoles();
        $roleNames = array_map(function($role) {
            return $role->name;
        }, $roles);

        return $this->respond([
            'status' => 'success',
            'data' => [
                'user' => [
                    'id' => $user->id,
                    'username' => $user->username,
                    'email' => $user->email,
                    'first_name' => $user->first_name ?? null,
                    'last_name' => $user->last_name ?? null,
                ],
                'roles' => $roleNames,
            ],
        ]);
    }
}
