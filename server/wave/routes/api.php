<?php

use App\Http\Controllers\Api\AuthController;
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


Route::get('greeting', [TranslateController::class, 'index'])->middleware('localization');



