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

        if($validator->fails()){
            return response(['msg' => 'Bad request, missing data!'], 400)
                ->header('Content-Type', 'text/plain');
        }


        // dd($request->service_hour[1]);
        UserService::create([
            'service_day' => $request->service_day,
            'service_hour'=> $request->service_hour[1],
            'location'=> $request->location,
            'user_id'=> $request->user_id,
            'service_id'=> $request->service_id,
        ]);

        
        // DB::update("UPDATE avaliable_times SET first_counter = first_counter + 1 WHERE first="9.5-10.5" AND $request->="2021-12-14 22:38:37"");
        
        //1==> Increace counter value
        // Get current counter in avaliable times table
        $currentCounterValue = $request->service_hour[0].'_counter';
        // dd($currentCounterValue);

        // Get current avaliable employees
        $employeesCounter = User::where('role_id', 3)->count();

        DB::table('avaliable_times')
              ->where('daily_date', $request->service_day)
              ->update([$request->service_hour[0].'_counter' => $request->service_hour[0].'_counter' + 1]);

        // $currentCounter = DB::select("SELECT * from avaliable_times WHERE first="9.5-10.5" AND daily_date="2021-12-14 22:38:37"")

        return response(['msg' => 'Service stored successfully'], 200)
            ->header('Content-Type', 'text/plain');

        //1- Check if time is avaliable from avaliable table
        //2- remove time from avaliable table if counter == employees number

    }

}
