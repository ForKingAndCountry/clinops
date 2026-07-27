<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateEncountersTable extends Migration
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
            ],
            'doctor_user_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'chief_complaint' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'history_of_present_illness' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'physical_examination' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'clinical_notes' => [
                'type' => 'TEXT',
                'null' => true,
                'comment' => 'Free-text notes for doctor reference only - not for pharmacy/lab',
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
        $this->forge->addKey('visit_id');
        $this->forge->addKey('doctor_user_id');
        $this->forge->addKey('created_at');
        $this->forge->addForeignKey('visit_id', 'visits', 'id', 'CASCADE', 'CASCADE');
        $this->forge->createTable('encounters');
    }

    public function down()
    {
        $this->forge->dropTable('encounters');
    }
}
