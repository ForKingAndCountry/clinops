<?php

namespace App\Database\Seeds;

use CodeIgniter\Database\Seeder;

class RoleSeeder extends Seeder
{
    public function run()
    {
        $roleModel = model('CodeIgniter\Shield\Models\RoleModel');

        $roles = [
            'ClinicAdmin',
            'Doctor',
            'Nurse',
            'LabTech',
            'Pharmacist',
            'WardNurse',
            'AdmissionManager',
            'InpatientDoctor',
            'RecordsOfficer',
            'BillingOfficer',
        ];

        foreach ($roles as $role) {
            $roleModel->create([
                'name' => $role,
                'description' => "Role for {$role}",
            ]);
        }

        echo "Roles seeded successfully.\n";
    }
}
