<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateStaffInOutTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('staff_in_out', function (Blueprint $table) {
            $table->id();
            $table->integer("staff_id")->unique();
            $table->timestamp("in")->nullable();
            $table->timestamp("out")->nullable();
            $table->text("image_path")->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('staff_in_out');
    }
}
