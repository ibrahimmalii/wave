<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AvaliableTimeController;
use App\Http\Controllers\Api\notifiedUserController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\Api\UserServiceController;
use App\Http\Controllers\PhoneVerificationController;
use App\Http\Controllers\TranslateController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
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
Route::post('/updatePasswordFromSetting', [AuthController::class, 'updatePasswordFromSetting'])->middleware('auth:sanctum');

// Multi languages for getting services
Route::get('/services/{lang}', [ServiceController::class, 'index'])->middleware('auth:sanctum');
Route::get('/services/{id}/{lang}', [ServiceController::class, 'show'])->middleware('auth:sanctum');

Route::get('content', [TranslateController::class, 'index'])->middleware('localization');

// Crud for user services 
Route::get('/userServices', [UserServiceController::class, 'index'])->middleware('auth:sanctum');
Route::post('/userServices', [UserServiceController::class, 'create'])->middleware('auth:sanctum');
Route::post('/userServices/update', [UserServiceController::class, 'update'])->middleware('auth:sanctum');
Route::delete('/userServices/{id}', [UserServiceController::class, 'delete'])->middleware('auth:sanctum');

// Avaliable times
Route::get('/avaliableTime', [AvaliableTimeController::class, 'index'])->middleware('auth:sanctum');

// About notified user 
Route::get('/pickup/{id}', [notifiedUserController::class, 'pickup'])->middleware('auth:sanctum');
