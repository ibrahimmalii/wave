<?php

use App\Http\Controllers\testController;
use App\Http\Resources\ServiceArabicResource;
use App\Http\Resources\ServiceEnglishResource;
use App\Http\Resources\ServiceResource;
use App\Models\Service;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Route::get('/', function () {
//     return view('welcome');
// });

Route::get('/home', [testController::class, 'index'])->name('home')->middleware('verifiedphone'); 


Route::group(['prefix' => '/'], function () {
    Voyager::routes();
});

Route::group(['prefix' => 'admin'], function () {
    Voyager::routes();
});

// Test multi languages with parameters
Route::get('/test/{lang}', function($lang){
    if($lang === 'ar'){
        return ServiceArabicResource::Collection(Service::all());
    }
    return ServiceEnglishResource::collection(Service::all());
});

