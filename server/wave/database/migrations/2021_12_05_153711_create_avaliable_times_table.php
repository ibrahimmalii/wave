<?php

use Carbon\Carbon;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class CreateAvaliableTimesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('avaliable_times', function (Blueprint $table) {
            $table->id();
            // Need to create 30 row with seeder
            $table->string('first')->default('9.5-10.5');
            $table->integer('first_counter')->default(0);
            $table->string('second')->default('10.5-11.5');
            $table->integer('second_counter')->default(0);
            $table->string('third')->default('11.5-12.5');
            $table->integer('third_counter')->default(0);
            $table->string('fourth')->default('12.5-1.5');
            $table->integer('fourth_counter')->default(0);
            $table->string('fifth')->default('1.5-2.5');
            $table->integer('fifth_counter')->default(0);
            $table->string('sixth')->default('2.5-3.5');
            $table->integer('sixth_counter')->default(0);
            $table->string('seventh')->default('3.5-4.5');
            $table->integer('seventh_counter')->default(0);
            $table->string('eighth')->default('4.5-5.5');
            $table->integer('eighth_counter')->default(0);

            $date = Carbon::now();
            $date->toDateString();
            $date->addMonth(1);

            $table->string('daily_date');
            $table->timestamps();
        });
        // To add migration seed
        // $date->toDateString();
        
        $day_date = Carbon::now();
        for ($i=0; $i < 31; $i++) { 
            
            DB::table('avaliable_times')->insertOrIgnore([
                ['daily_date' => $day_date->addDays(1)]
            ]);

        };

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('avaliable_times');
    }
}
