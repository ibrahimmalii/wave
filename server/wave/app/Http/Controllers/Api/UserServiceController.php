<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class UserServiceController extends Controller
{
    public function index()
    {
        $userServices = UserService::all();

        return response(['data' => $userServices], 200)
                ->header('Content-Type', 'text/plain');

    }

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'service_day' => ['required', 'string', 'max:255'],
            'service_hour' => ['required',  'max:255'],
            'location' => ['required', 'string', 'max:255'],
            'user_id' => 'required|exists:users,id',
            'service_id' => 'required|exists:services,id',
        ]);

        if($validator->fails() || ($request->service_day === 'unavaliable date')){
            return response(['msg' => 'Bad request, missing data or date invalid!'], 400)
                ->header('Content-Type', 'text/plain');
        }

        UserService::create([
            'service_day' => $request->service_day,
            'service_hour'=> $request->service_hour[1],
            'location'=> $request->location,
            'user_id'=> $request->user_id,
            'service_id'=> $request->service_id,
        ]);

                
        // Get current counter in avaliable times table
        $currentCounterName = $request->service_hour[0].'_counter';

        // Get current avaliable employees ==> Counter limit
        $measureEmployeesNumber = User::where('role_id', 3)->count();

        //1==> Increace counter value
        DB::table('avaliable_times')
              ->where('daily_date', $request->service_day)
              ->increment($currentCounterName);
        
        // Get current day
        $currentDay = DB::select("select * from avaliable_times where daily_date='$request->service_day'");
        $currentCounterValue = $currentDay[0]->$currentCounterName;

        //2==> Check if counter less than emp counter or not 
        if($currentCounterValue >= $measureEmployeesNumber){
            DB::table('avaliable_times')
              ->where('daily_date', $request->service_day)
              ->update([$request->service_hour[0] => 'unavaliable date']);
            //********* Update colum in avaliable time to unavaliable */
            return response(['msg' => 'Now this date became unavaliable in this day'], 200)
                ->header('Content-Type', 'text/plain');
        }



        return response(['msg' => 'Service stored successfully'], 200)
            ->header('Content-Type', 'text/plain');


    }

}