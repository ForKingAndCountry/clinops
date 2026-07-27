<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateBedsTable extends Migration
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
            'ward_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
            ],
            'bed_number' => [
                'type'       => 'VARCHAR',
                'constraint' => 20,
            ],
            'status' => [
                'type'       => 'ENUM',
                'constraint' => ['free', 'occupied', 'maintenance'],
                'default'    => 'free',
            ],
            'current_admission_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
                'comment'    => 'Foreign key to admissions when bed is occupied. Enforce in Service layer with transaction + row lock to prevent double-booking.',
            ],
            'is_active' => [
                'type'       => 'BOOLEAN',
                'default'    => true,
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
        $this->forge->addKey('ward_id');
        $this->forge->addKey('status');
        $this->forge->addKey('current_admission_id');
        $this->forge->addForeignKey('ward_id', 'wards', 'id', 'RESTRICT', 'CASCADE');
        $this->forge->createTable('beds');
    }

    public function down()
    {
        $this->forge->dropTable('beds');
    }
}
