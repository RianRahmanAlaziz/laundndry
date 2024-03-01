<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('shops', function (Blueprint $table) {
            $table->id();
            $table->string('image')->nullable();
            $table->string('name');
            $table->string('location');
            $table->string('city');
            $table->boolean('delivery')->nullable();
            $table->boolean('pickup')->nullable();
            $table->string('whatsapp');
            $table->text('category');
            $table->text('description');
            $table->double('price_cuci_komplit')->nullable();
            $table->double('price_dry_clean')->nullable();
            $table->double('price_cuci_satuan')->nullable();
            $table->double('rate')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('shops');
    }
};
