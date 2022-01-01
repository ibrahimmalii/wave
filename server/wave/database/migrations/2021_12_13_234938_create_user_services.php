<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUserServices extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('user_services', function (Blueprint $table) {
            $table->id();
            $table->string('service_day'); // like columns in avaliable_times && create same date - one day in notifications table
            $table->string('service_hour');
            $table->integer('service_amount');
            $table->text('location');
            $table->string('arrived_at')->default('waiting');
            $table->string('completed_at')->default('waiting');
            $table->string('service_performer')->nullable();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('service_id')->constrained();
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
        Schema::dropIfExists('user_services');
    }
}
