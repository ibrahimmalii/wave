<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AvaliableTimeController;
use App\Http\Controllers\api\EmployeesProfileController;
use App\Http\Controllers\Api\notifiedUserController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\api\UserProfileController;
use App\Http\Controllers\Api\UserServiceController;
use App\Http\Controllers\PhoneVerificationController;
use App\Http\Controllers\TranslateController;
use App\Models\User;
use App\Models\UserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
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
Route::get('/avaliableTime', [AvaliableTimeController::class, 'index']);

// About notified user 
Route::get('/pickup/{id}', [notifiedUserController::class, 'pickup'])->middleware('auth:sanctum');

//Employee profile
Route::get('/employeesServicesProfile', [EmployeesProfileController::class, 'index'])->middleware('auth:sanctum');

//Normal user profile 
Route::get('/userServicesProfile/{lang}', [UserProfileController::class, 'index'])->middleware('auth:sanctum');


Route::get('/testGetServices/{lang}', function($lang){
    $id = Auth::id();
    $user = User::where('id', $id)->first();

    if(!$user){
        $msg = 'Authentication field';
        return response(['msg' => $msg], 403)
        ->header('Content-Type', 'text/plain');
    }

    if ($user->role_id == 2 && $lang === 'ar') {
        //* To show data in user profile
        $services = DB::select("SELECT us.service_id,  us.service_day, us.service_hour, us.service_amount, us.location, s.title_subtitle from user_services us INNER JOIN services s ON user_id = 3");

        return response(['data' => $services], 200)
            ->header('Content-Type', 'text/plain');
    }else if ($user->role_id == 2 && $lang === 'en'){
        $services = DB::select("SELECT us.service_id,  us.service_day, us.service_hour, us.service_amount, us.location, s.title from user_services us INNER JOIN services s ON user_id = 3");

        return response(['data' => $services], 200)
            ->header('Content-Type', 'text/plain');
    }

    $msg = 'these data avaliable for only employees';
    return response(['msg' => $msg], 403)
        ->header('Content-Type', 'text/plain');
})->middleware('auth:sanctum');