<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserService;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;
use Twilio\Rest\Client;

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
        $user_id = Auth::user()->id;

        $validator = Validator::make($request->all(), [
            'service_day' => ['required', 'string', 'max:255'],
            'service_hour_name' => ['required',  'max:255'],
            'service_hour_value' => ['required',  'max:255'],
            'service_amount' => ['required',  'max:255'],
            'location' => ['required', 'string', 'max:255'],
            'service_id' => 'required|exists:services,id',
        ]);

        if ($validator->fails() || ($request->service_day === 'unavaliable date')) {
            return response(['msg' => 'Bad request, missing data or date invalid!'], 400)
                ->header('Content-Type', 'text/plain');
        }

        //* Create a new record in userServices table
        UserService::create([
            'service_day' => $request->service_day,
            'service_hour' => $request->service_hour_value,
            'service_amount' => $request->service_amount,
            'location' => $request->location,
            'user_id' => $user_id,
            'service_id' => $request->service_id,
            'additional_services' => $request->additional_services
        ]);


        //* process to update in avaliable times
        // Get current counter in avaliable times table
        $currentCounterName = $request->service_hour_name . '_counter';

        // Get current avaliable employees ==> Counter limit
        $measureEmployeesNumber = User::where('role_id', 3)->count();

        if (!$measureEmployeesNumber) {
            return response(['msg' => 'No services avaliable now'], 400)
                ->header('Content-Type', 'text/plain');
        }

        //1==> Increace counter value
        DB::table('avaliable_times')
            ->where('daily_date', $request->service_day)
            ->increment($currentCounterName);

        // Get current day
        $currentDay = DB::select("select * from avaliable_times where daily_date='$request->service_day'");
        $currentCounterValue = $currentDay[0]->$currentCounterName;

        //2==> Check if counter less than emp counter or not 
        if ($currentCounterValue >= $measureEmployeesNumber) {
            DB::table('avaliable_times')
                ->where('daily_date', $request->service_day)
                ->update([$request->service_hour_name => 'unavaliable date']);

            $this->pickup($user_id);

            //********* Update colum in avaliable time to unavaliable */
            return response(['msg' => 'Now this date became unavaliable in this day'], 200)
                ->header('Content-Type', 'text/plain');
        }

        $this->pickup($user_id);

        return response(['msg' => 'Service stored successfully'], 200)
            ->header('Content-Type', 'text/plain');
    }

    public function pickup($id)
    {
        $client = new Client(getenv("TWILIO_SID"), getenv("TWILIO_AUTH_TOKEN"));
        $user = User::find($id);

        $callbackUrl = str_replace('/pickup', '', 'http://www.facebook.com');


        $this->sendMessage(
            $client,
            $user->phone_number,
            'You have successfully subscribed to the service :)',
            $callbackUrl
        );
    }


    private function sendMessage($client, $to, $messageBody, $callbackUrl)
    {
        $twilioNumber = getenv("TWILIO_PHONE");
        try {
            $client->messages->create(
                $to, // Text any number
                [
                    'from' => $twilioNumber, // From a Twilio number in your account
                    'body' => $messageBody,
                    'statusCallback' => $callbackUrl
                ]
            );
        } catch (Exception $e) {
            Log::error($e->getMessage());
        }
    }

    //! for change the time
    public function update(Request $request)
    {
        // dd($request);
        $user_id = Auth::user()->id;

        $validator = Validator::make($request->all(), [
            'old_service_day' => ['required', 'string', 'max:255'],
            'old_service_hour_name' => ['required',  'max:255'],
            'old_service_hour_value' => ['required',  'max:255'],
            'new_service_day' => ['required', 'string', 'max:255'],
            'new_service_hour_name' => ['required',  'max:255'],
            'new_service_hour_value' => ['required',  'max:255'],
            'new_location' => ['required', 'string', 'max:255'],
            'service_id' => 'required|exists:services,id',
        ]);

        if ($validator->fails() || ($request->service_day === 'unavaliable date')) {
            return response(['msg' => 'Bad request, missing data or date invalid!'], 400)
                ->header('Content-Type', 'text/plain');
        }

        $currentTime = tap(UserService::where(['service_id' => $request->service_id, 'user_id' => $user_id, 'service_day' => $request->old_service_day]))
            ->update(['service_day' => $request->new_service_day, 'service_hour' => $request->new_service_hour_name, 'location' => $request->new_location]); //* Done

        //! update in avaliable time table

        //*1- decrement counter to latest time
        $oldCounterName = $request->old_service_hour_name . '_counter';
        DB::table('avaliable_times')
            ->where('daily_date', $request->old_service_day)
            ->decrement($oldCounterName);

        $latestDay = DB::select("select * from avaliable_times where daily_date='$request->old_service_day'");
        $latestCounterValue = $latestDay[0]->$oldCounterName;

        DB::table('avaliable_times')
            ->where('daily_date', $request->old_service_day)
            ->update([$request->old_service_hour_name => $request->old_service_hour_value]);


        //*2- Make some changes in new times
        $currentCounterName = $request->new_service_hour_name . '_counter';

        // Get current avaliable employees ==> Counter limit
        $measureEmployeesNumber = User::where('role_id', 3)->count();

        if (!$measureEmployeesNumber) {
            return response(['msg' => 'No services avaliable now'], 400)
                ->header('Content-Type', 'text/plain');
        }

        //1==> Increace counter value
        DB::table('avaliable_times')
            ->where('daily_date', $request->new_service_day)
            ->increment($currentCounterName);

        // Get current day
        $currentDay = DB::select("select * from avaliable_times where daily_date='$request->new_service_day'");
        $currentCounterValue = $currentDay[0]->$currentCounterName;

        //2==> Check if counter less than emp counter or not 
        if ($currentCounterValue >= $measureEmployeesNumber) {
            DB::table('avaliable_times')
                ->where('daily_date', $request->new_service_day)
                ->update([$request->new_service_hour_name => 'unavaliable date']);

            $this->pickup($user_id);

            //********* Update colum in avaliable time to unavaliable */
            return response(['msg' => 'Now this date became unavaliable in this day'], 200)
                ->header('Content-Type', 'text/plain');
        }

        $this->pickup($user_id);

        return response(['msg' => 'Service stored successfully'], 200)
            ->header('Content-Type', 'text/plain');
    }

    public function show(){
        $user_id = Auth::user()->id;
        $userServiceProfileData = UserService::where('user_id', $user_id)->get();
        return response(['data' => $userServiceProfileData], 200)
            ->header('Content-Type', 'text/plain');
    }

    
}
