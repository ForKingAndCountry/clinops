<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateWardsTable extends Migration
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
            'name' => [
                'type'       => 'VARCHAR',
                'constraint' => 100,
            ],
            'ward_type' => [
                'type'       => 'ENUM',
                'constraint' => ['Male', 'Female', 'Pediatric', 'Maternity', 'ICU', 'General'],
            ],
            'capacity' => [
                'type'       => 'INT',
                'constraint' => 11,
                'default'    => 0,
            ],
            'floor' => [
                'type'       => 'INT',
                'constraint' => 11,
                'null'       => true,
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
        $this->forge->addKey('ward_type');
        $this->forge->createTable('wards');
    }

    public function down()
    {
        $this->forge->dropTable('wards');
    }
}
