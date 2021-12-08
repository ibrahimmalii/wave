<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUserServiceTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('user_service', function (Blueprint $table) {
            $table->id();
            $table->string('service_day'); // like columns in avaliable_times && create same date - one day in notifications table
            $table->string('service_hour');
            $table->foreignId('user_id')->constrained();
            $table->foreignId('service_id')->constrained();

            // $table->foreign('user_id')->references('id')->on('users');
            // $table->foreign('service_id')->references('id')->on('services');
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
        Schema::dropIfExists('user_service');
    }
}
