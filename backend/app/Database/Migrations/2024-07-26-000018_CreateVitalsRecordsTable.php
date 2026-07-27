<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateVitalsRecordsTable extends Migration
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
            'visit_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'admission_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'recorded_by_user_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'temperature' => [
                'type' => 'DECIMAL',
                'constraint' => '5,2',
                'null' => true,
            ],
            'blood_pressure_systolic' => [
                'type' => 'INT',
                'constraint' => 11,
                'null' => true,
            ],
            'blood_pressure_diastolic' => [
                'type' => 'INT',
                'constraint' => 11,
                'null' => true,
            ],
            'heart_rate' => [
                'type' => 'INT',
                'constraint' => 11,
                'null' => true,
            ],
            'respiratory_rate' => [
                'type' => 'INT',
                'constraint' => 11,
                'null' => true,
            ],
            'oxygen_saturation' => [
                'type' => 'DECIMAL',
                'constraint' => '5,2',
                'null' => true,
            ],
            'weight' => [
                'type' => 'DECIMAL',
                'constraint' => '10,2',
                'null' => true,
            ],
            'height' => [
                'type' => 'DECIMAL',
                'constraint' => '10,2',
                'null' => true,
            ],
            'notes' => [
                'type' => 'TEXT',
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
        $this->forge->addKey('visit_id');
        $this->forge->addKey('admission_id');
        $this->forge->addKey('created_at');
        $this->forge->addForeignKey('visit_id', 'visits', 'id', 'SET NULL', 'CASCADE');
        $this->forge->addForeignKey('admission_id', 'admissions', 'id', 'SET NULL', 'CASCADE');
        $this->forge->createTable('vitals_records');
    }

    public function down()
    {
        $this->forge->dropTable('vitals_records');
    }
}
