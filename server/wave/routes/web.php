<?php

use App\Http\Controllers\testController;
use Carbon\Carbon;
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
//     Voyager::routes();
// });

Route::get('/home', [testController::class, 'index'])->name('home')->middleware('verifiedphone'); 

Route::get('/test', function () {
    // Get latest day to
    $date = Carbon::now();
    $date->toDateString();
    $date->addDay(5);
    dd($date);
});

Route::group(['prefix' => '/'], function () {
    Voyager::routes();
});

Route::group(['prefix' => 'admin'], function () {
    Voyager::routes();
});
