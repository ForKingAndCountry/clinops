<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateVisitTransitionsTable extends Migration
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
            'from_state' => [
                'type'       => 'ENUM',
                'constraint' => ['RECEPTION', 'VITALS', 'DOCTOR', 'LAB', 'PHARMACY', 'BILLING', 'DISCHARGED'],
                'null'       => true,
            ],
            'to_state' => [
                'type'       => 'ENUM',
                'constraint' => ['RECEPTION', 'VITALS', 'DOCTOR', 'LAB', 'PHARMACY', 'BILLING', 'DISCHARGED'],
            ],
            'actor_user_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'notes' => [
                'type' => 'TEXT',
                'null' => true,
            ],
            'created_at' => [
                'type' => 'DATETIME',
                'null' => false,
            ],
        ]);

        $this->forge->addKey('id', true);
        $this->forge->addKey('visit_id');
        $this->forge->addKey('created_at');
        $this->forge->addForeignKey('visit_id', 'visits', 'id', 'CASCADE', 'CASCADE');
        $this->forge->createTable('visit_transitions');
    }

    public function down()
    {
        $this->forge->dropTable('visit_transitions');
    }
}
