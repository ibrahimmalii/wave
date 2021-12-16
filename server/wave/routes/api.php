<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\Api\UserServiceController;
use App\Http\Controllers\PhoneVerificationController;
use App\Http\Controllers\TranslateController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::post('/register', [AuthController::class, 'register'])->name('register');
Route::post('/verify', [AuthController::class, 'verify'])->name('verify');
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forget', [AuthController::class, 'forget'])->name('forget');
Route::post('/updatePasswordFromLogin', [AuthController::class, 'updatePasswordFromLogin']);
Route::post('/updatePasswordFromSetting', [AuthController::class, 'updatePasswordFromSetting']);

// Multi languages for getting services
// Route::get('/services/{lang}', [ServiceController::class, 'index'])->middleware('auth:sanctum');
Route::get('/services/{lang}', [ServiceController::class, 'index']);

Route::get('content', [TranslateController::class, 'index'])->middleware('localization');

// Crud for user services 
Route::get('/userServices', [UserServiceController::class, 'index']);
Route::post('/userServices', [UserServiceController::class, 'create']);
Route::post('/userServices/{id}', [UserServiceController::class, 'update']);
Route::delete('/userServices/{id}', [UserServiceController::class, 'delete']);




