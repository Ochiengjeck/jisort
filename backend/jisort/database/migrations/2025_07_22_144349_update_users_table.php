<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            // Drop existing columns if they exist
            $table->dropColumn(['name']);
            
            // Add new columns
            $table->string('first_name');
            $table->string('last_name');
            $table->string('username')->unique()->nullable();
            $table->string('phone')->nullable()->unique();
            $table->string('avatar')->nullable();
            $table->text('bio')->nullable();
            $table->date('date_of_birth')->nullable();
            $table->enum('gender', ['male', 'female', 'other'])->nullable();
            $table->text('address')->nullable();
            $table->string('city')->nullable();
            $table->string('state')->nullable();
            $table->string('country')->nullable();
            $table->string('postal_code')->nullable();
            $table->string('timezone')->default('UTC');
            $table->string('language')->default('en');
            $table->enum('status', ['active', 'inactive', 'suspended'])->default('active');
            $table->timestamp('phone_verified_at')->nullable();
            $table->boolean('two_factor_enabled')->default(false);
            $table->text('two_factor_secret')->nullable();
            $table->text('two_factor_recovery_codes')->nullable();
            $table->timestamp('last_login_at')->nullable();
            $table->timestamp('last_activity_at')->nullable();
            $table->json('metadata')->nullable();
            $table->softDeletes();
            
            // Add indexes
            $table->index(['status']);
            $table->index(['last_activity_at']);
            $table->index(['created_at']);
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropSoftDeletes();
            $table->dropColumn([
                'first_name', 'last_name', 'username', 'phone', 'avatar', 
                'bio', 'date_of_birth', 'gender', 'address', 'city', 
                'state', 'country', 'postal_code', 'timezone', 'language',
                'status', 'phone_verified_at', 'two_factor_enabled',
                'two_factor_secret', 'two_factor_recovery_codes',
                'last_login_at', 'last_activity_at', 'metadata'
            ]);
            $table->string('name');
        });
    }
};
