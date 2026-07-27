<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateReferralsTable extends Migration
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
            'encounter_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'referred_to_facility' => [
                'type'       => 'VARCHAR',
                'constraint' => 255,
            ],
            'referral_reason' => [
                'type' => 'TEXT',
            ],
            'referred_by_user_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
                'null'       => true,
            ],
            'priority' => [
                'type'       => 'ENUM',
                'constraint' => ['routine', 'urgent', 'emergency'],
                'default'    => 'routine',
            ],
            'status' => [
                'type'       => 'ENUM',
                'constraint' => ['pending', 'transferred', 'cancelled'],
                'default'    => 'pending',
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
        $this->forge->addKey('encounter_id');
        $this->forge->addKey('status');
        $this->forge->addKey('created_at');
        $this->forge->addForeignKey('patient_id', 'patients', 'id', 'RESTRICT', 'CASCADE');
        $this->forge->addForeignKey('visit_id', 'visits', 'id', 'SET NULL', 'CASCADE');
        $this->forge->addForeignKey('encounter_id', 'encounters', 'id', 'SET NULL', 'CASCADE');
        $this->forge->createTable('referrals');
    }

    public function down()
    {
        $this->forge->dropTable('referrals');
    }
}
