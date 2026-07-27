<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreatePrescriptionItemsTable extends Migration
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
            'prescription_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
            ],
            'drug_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
            ],
            'dose' => [
                'type'       => 'DECIMAL',
                'constraint' => '10,2',
            ],
            'dose_unit' => [
                'type'       => 'ENUM',
                'constraint' => ['mg', 'g', 'ml', 'units', 'drops', 'mcg', 'other'],
            ],
            'route' => [
                'type'       => 'ENUM',
                'constraint' => ['oral', 'intravenous', 'intramuscular', 'subcutaneous', 'topical', 'rectal', 'inhaled', 'other'],
            ],
            'frequency' => [
                'type'       => 'ENUM',
                'constraint' => ['once_daily', 'twice_daily', 'three_times_daily', 'four_times_daily', 'every_8_hours', 'every_12_hours', 'every_24_hours', 'as_needed', 'before_meals', 'after_meals', 'other'],
            ],
            'duration' => [
                'type'       => 'INT',
                'constraint' => 11,
                'comment'    => 'Duration in days',
            ],
            'quantity_dispensed' => [
                'type'       => 'INT',
                'constraint' => 11,
                'default'    => 0,
            ],
            'status' => [
                'type'       => 'ENUM',
                'constraint' => ['pending', 'dispensed', 'cancelled'],
                'default'    => 'pending',
            ],
            'notes' => [
                'type' => 'TEXT',
                'null' => true,
                'comment' => 'Optional free-text notes - NOT for pharmacy to act on',
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
        $this->forge->addKey('prescription_id');
        $this->forge->addKey('drug_id');
        $this->forge->addKey('status');
        $this->forge->addForeignKey('prescription_id', 'prescriptions', 'id', 'CASCADE', 'CASCADE');
        $this->forge->addForeignKey('drug_id', 'drug_formulary', 'id', 'RESTRICT', 'CASCADE');
        $this->forge->createTable('prescription_items');
    }

    public function down()
    {
        $this->forge->dropTable('prescription_items');
    }
}
