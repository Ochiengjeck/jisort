<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\TaskController;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
});

Route::middleware(['auth:sanctum', 'track.user.activity'])->group(function () {
    
    Route::prefix('auth')->group(function () {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::post('/logout-all', [AuthController::class, 'logoutAll']);
    });
    
    Route::prefix('users')->group(function () {
        Route::get('/', [UserController::class, 'index']);
        Route::get('/{id}', [UserController::class, 'show']);
        Route::put('/profile', [UserController::class, 'update']);
        Route::put('/{id}/status', [UserController::class, 'updateStatus']);
        Route::delete('/{id}', [UserController::class, 'destroy']);
    });
    

    Route::prefix('tasks')->group(function () {
        Route::get('/', [TaskController::class, 'getTasks'])->name('tasks.get');
        Route::post('/create', [TaskController::class, 'create'])->name('tasks.create');
        Route::put('/{task}', [TaskController::class, 'updateTask'])->name('tasks.update');
        Route::delete('/{task}', [TaskController::class, 'delete'])->name('tasks.delete');
        Route::post('/{task}/assign', [TaskController::class, 'assign'])->name('tasks.assign');
    });
});

Route::get('/health', function () {
    return response()->json([
        'status' => 'ok',
        'timestamp' => now()->toISOString(),
        'version' => config('app.version', '1.0.0'),
    ]);
});
