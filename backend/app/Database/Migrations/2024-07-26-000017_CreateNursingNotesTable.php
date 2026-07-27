<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateNursingNotesTable extends Migration
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
            'admission_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
            ],
            'nurse_user_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'note_type' => [
                'type'       => 'ENUM',
                'constraint' => ['admission', 'shift_change', 'medication', 'procedure', 'general', 'discharge'],
                'default'    => 'general',
            ],
            'notes' => [
                'type' => 'TEXT',
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
        $this->forge->addKey('admission_id');
        $this->forge->addKey('created_at');
        $this->forge->addForeignKey('admission_id', 'admissions', 'id', 'CASCADE', 'CASCADE');
        $this->forge->createTable('nursing_notes');
    }

    public function down()
    {
        $this->forge->dropTable('nursing_notes');
    }
}
