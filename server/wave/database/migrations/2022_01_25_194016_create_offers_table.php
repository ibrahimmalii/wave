<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOffersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('offers', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('title_subtitle');
            $table->text('description');
            $table->text('description_subtitle');
            $table->foreignId('paid_service_id')->constrained('services');
            $table->integer('paid_count')->default(0);
            $table->foreignId('free_service_id')->constrained('services');
            $table->integer('free_count')->default(0);
            $table->integer('type');
            $table->boolean('active');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('offers');
    }
}
