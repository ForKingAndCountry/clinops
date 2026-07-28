<?php

namespace App\Database\Seeds;

use CodeIgniter\Database\Seeder;

class AdminUserSeeder extends Seeder
{
    public function run()
    {
        $userModel = model('CodeIgniter\Shield\Models\UserModel');
        $roleModel = model('CodeIgniter\Shield\Models\RoleModel');

        // Create admin user
        $user = $userModel->create([
            'username' => 'admin',
            'email' => 'admin@clinic.local',
            'password' => 'admin123',
        ]);

        // Assign ClinicAdmin role
        $adminRole = $roleModel->where('name', 'ClinicAdmin')->first();
        $user->addRole($adminRole);

        echo "Admin user seeded successfully.\n";
    }
}
