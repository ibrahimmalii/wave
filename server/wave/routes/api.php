<?php

use App\Events\Notify;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AvaliableTimeController;
use App\Http\Controllers\api\EmployeesProfileController;
use App\Http\Controllers\Api\notifiedUserController;
use App\Http\Controllers\api\ProfileController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\api\UserProfileController;
use App\Http\Controllers\Api\UserServiceController;
use App\Http\Controllers\OfferController;
use App\Http\Controllers\PhoneVerificationController;
use App\Http\Controllers\TranslateController;
use App\Models\MyEvent;
use App\Models\Notification;
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
Route::get('/essintial_services/{lang}', [ServiceController::class, 'index_ess']);
// ->middleware('auth:sanctum');
Route::get('/additional_services/{lang}', [ServiceController::class, 'index_add'])->middleware('auth:sanctum');
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
// Route::get('/employeesServicesProfile', [EmployeesProfileController::class, 'index'])->middleware('auth:sanctum');
Route::get('/employeesServicesProfile', [AvaliableTimeController::class, 'index_emp'])->middleware('auth:sanctum');
Route::post('/arrivedAt', [AvaliableTimeController::class, 'updateArrivedAt'])->middleware('auth:sanctum');
Route::post('/completedAt', [AvaliableTimeController::class, 'updateCompletedAt'])->middleware('auth:sanctum');

//Normal user profile 
// Route::get('/userServicesProfile/{lang}', [UserProfileController::class, 'index'])->middleware('auth:sanctum');
Route::get('/userServicesProfile/{lang}', [AvaliableTimeController::class, 'index_user'])->middleware('auth:sanctum');


//* About notifications 
Route::get('/push', function () {
    return event(new Notify('hello world'));
    // return 'done';
});





//* About offers 
Route::get('/offers/{lang}', [OfferController::class, 'index']);
// ->middleware('auth:sanctum');


//* About notifications with firebase
Route::post('send', [Notification::class, 'bulksend'])->name('bulksend');
Route::get('all-notifications', [Notification::class, 'index']);
Route::get('get-notification-form', [Notification::class, 'create']);
