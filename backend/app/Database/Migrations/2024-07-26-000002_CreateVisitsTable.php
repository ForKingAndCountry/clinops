<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateVisitsTable extends Migration
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
            'visit_type' => [
                'type'       => 'ENUM',
                'constraint' => ['OPD', 'IPD', 'Maternity', 'Emergency'],
            ],
            'status' => [
                'type'       => 'ENUM',
                'constraint' => ['RECEPTION', 'VITALS', 'DOCTOR', 'LAB', 'PHARMACY', 'BILLING', 'DISCHARGED'],
                'default'    => 'RECEPTION',
            ],
            'chief_complaint' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'priority' => [
                'type'       => 'ENUM',
                'constraint' => ['routine', 'urgent', 'emergency'],
                'default'    => 'routine',
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
        $this->forge->addKey('status');
        $this->forge->addKey('visit_type');
        $this->forge->addKey('created_at');
        $this->forge->addForeignKey('patient_id', 'patients', 'id', 'CASCADE', 'CASCADE');
        $this->forge->createTable('visits');
    }

    public function down()
    {
        $this->forge->dropTable('visits');
    }
}
