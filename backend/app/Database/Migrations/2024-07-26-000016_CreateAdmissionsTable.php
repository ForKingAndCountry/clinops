<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateAdmissionsTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id' => [
                'type'           => 'INT',
                'constraint'     => 11,
                'unsigned'       => true,
                'auto_increment' => true,
            ],
            'patient_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
            ],
            'visit_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'bed_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
            ],
            'admission_type' => [
                'type'       => 'ENUM',
                'constraint' => ['emergency', 'elective', 'transfer'],
                'default'    => 'elective',
            ],
            'admitting_diagnosis' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'admitted_by_user_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'status' => [
                'type'       => 'ENUM',
                'constraint' => ['active', 'discharged', 'transferred', 'deceased'],
                'default'    => 'active',
            ],
            'admission_date' => [
                'type' => 'DATETIME',
                'null' => false,
            ],
            'discharge_date' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
            'discharge_summary' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'final_diagnosis' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'deleted_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
            'created_at' => [
                'type' => 'DATETIME',
                'null' => false,
            ],
            'updated_at' => [
                'type' => 'DATETIME',
                'null' => false,
            ],
        ]);

        $this->forge->addKey('id', true);
        $this->forge->addKey('patient_id');
        $this->forge->addKey('visit_id');
        $this->forge->addKey('bed_id');
        $this->forge->addKey('status');
        $this->forge->addKey('admission_date');
        $this->forge->addForeignKey('patient_id', 'patients', 'id', 'RESTRICT', 'CASCADE');
        $this->forge->addForeignKey('visit_id', 'visits', 'id', 'SET NULL', 'CASCADE');
        $this->forge->addForeignKey('bed_id', 'beds', 'id', 'RESTRICT', 'CASCADE');
        $this->forge->createTable('admissions');
    }

    public function down()
    {
        $this->forge->dropTable('admissions');
    }
}
