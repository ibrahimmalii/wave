<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\AvaliableTimeResource;
use App\Models\AvaliableTime;
use App\Models\MyEvent;
use App\Models\Service;
use App\Models\User;
use App\Models\UserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class AvaliableTimeController extends Controller
{
    public function index()
    {
        return AvaliableTimeResource::Collection(AvaliableTime::all());
    }

    public function index_emp()
    {
        $id = Auth::id();
        $user = User::where('id', $id)->first();
        if (!$user) {
            $msg = 'Authentication field';
            return response(['msg' => $msg], 403)
                ->header('Content-Type', 'text/plain');
        }

        if ($user->role_id == 3) {
            $services = DB::select("SELECT s.title, s.title_subtitle, us.id, us.service_day, us.service_hour, us.service_amount, us.location, us.additional_services, us.arrived_at, us.completed_at, u.name as client_name, u.phone_number FROM user_services us INNER JOIN users u ON us.user_id = u.id INNER JOIN services s ON us.service_id = s.id");
            // dd($services);
            for ($x = 0; $x < count($services); $x++) {
                $parsedData = json_decode($services[$x]->additional_services, true);
                if (is_countable($parsedData) && count($parsedData) > 0) {
                    $additional_services_names = [];
                    foreach ($parsedData as $value) {
                        $add_service = Service::where('id', $value)->first();
                        array_push($additional_services_names, $add_service);
                    }
                    $services[$x]->additional_services = $additional_services_names;
                }
            }

            return response(['data' => $services], 200)
                ->header('Content-Type', 'text/plain');
        }

        $msg = 'these data avaliable for only employees';
        return response(['msg' => $msg], 403)
            ->header('Content-Type', 'text/plain');
    }
    public function index_user($lang)
    {
        $id = Auth::id();
        $user = User::where('id', $id)->first();

        if (!$user) {
            $msg = 'Authentication field';
            return response(['msg' => $msg], 403)
                ->header('Content-Type', 'text/plain');
        }
        // dd($user->role_id == 2 && $lang === 'en');
        if ($user->role_id == 2 && $lang === 'ar') {
            //* To show data in user profile
            $services = DB::select("SELECT us.service_id,  us.service_day, us.service_hour, us.service_amount, us.location, us.additional_services, s.title_subtitle from user_services us INNER JOIN services s ON us.service_id = s.id where us.user_id = $id");
            // dd(count($services));
            for ($x = 0; $x < count($services); $x++) {
                $parsedData = json_decode($services[$x]->additional_services, true);
                if (is_countable($parsedData) && count($parsedData) > 0) {
                    $additional_services_names = [];
                    foreach ($parsedData as $value) {
                        $add_service = Service::where('id', $value)->first();
                        array_push($additional_services_names, $add_service);
                    }
                    $services[$x]->additional_services = $additional_services_names;
                }
            }

            return response(['data' => $services], 200)
                ->header('Content-Type', 'text/plain');
        } else if ($user->role_id == 2 && $lang === 'en') {
            $services = DB::select("SELECT us.user_id, us.service_id,  us.service_day, us.service_hour, us.service_amount, us.location, us.additional_services, s.title from user_services us INNER JOIN services s ON us.service_id = s.id where us.user_id = $id");

            for ($x = 0; $x < count($services); $x++) {
                $parsedData = json_decode($services[$x]->additional_services, true);
                if (is_countable($parsedData) && count($parsedData) > 0) {
                    $additional_services_names = [];
                    foreach ($parsedData as $value) {
                        $add_service = Service::where('id', $value)->first();
                        array_push($additional_services_names, $add_service);
                    }
                    $services[$x]->additional_services = $additional_services_names;
                }
            }

            return response(['data' => $services], 200)
                ->header('Content-Type', 'text/plain');
        }

        $msg = 'these data avaliable for only employees';
        return response(['msg' => $msg], 403)
            ->header('Content-Type', 'text/plain');
    }

    //* About update arrived and finshed time 
    public function updateArrivedAt(Request $request)
    {
        $id = Auth::id();
        $user = User::where('id', $id)->first();
        if (!$user) {
            $msg = 'Authentication field';
            return response(['msg' => $msg], 403)
                ->header('Content-Type', 'text/plain');
        }

        $validator = Validator::make($request->all(), [
            'serviceId' => 'required',
            'arrived_at' => 'required | string'
        ]);

        if ($user->role_id == 3) {
            UserService::where('id', $request->serviceId)
                ->update([
                    'arrived_at' => $request->arrived_at,
                    'service_performer' => $user->name
                ]);

            return response(['msg' => 'updated successfully'], 201)
                ->header('Content-Type', 'text/plain');
        }

        if ($user->role_id != 3) {
            $msg = 'Normal user can not update this value';
            return response(['msg' => $msg], 403)
                ->header('Content-Type', 'text/plain');
        } else if (!$validator) {
            $msg = 'Bad request, Some date invalid';
            return response(['msg' => $msg], 400)
                ->header('Content-Type', 'text/plain');
        }
    }

    public function updateCompletedAt(Request $request)
    {
        $id = Auth::id();
        $user = User::where('id', $id)->first();
        if (!$user) {
            $msg = 'Authentication field';
            return response(['msg' => $msg], 403)
                ->header('Content-Type', 'text/plain');
        }

        $validator = Validator::make($request->all(), [
            'serviceId' => 'required',
            'completed_at' => 'required | string'
        ]);

        if ($validator->fails()) {
            $msg = 'Bad request, Some date invalid';
            return response(['msg' => $msg], 400)
                ->header('Content-Type', 'text/plain');
        }

        if ($user->role_id != 3) {
            $msg = 'Normal user can not update this value';
            return response(['msg' => $msg], 403)
                ->header('Content-Type', 'text/plain');
        }

        if ($user->role_id == 3) {
            UserService::where('id', $request->serviceId)
                ->update([
                    'completed_at' => $request->completed_at
                ]);

            return response(['msg' => 'updated successfully'], 201)
                ->header('Content-Type', 'text/plain');
        }
    }

    public function pushNotification()
    {
        $event = new MyEvent('hello ibrahim');
    }
}
