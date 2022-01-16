<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Service;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class UserProfileController extends Controller
{
    public function index($lang)
    {
        $id = Auth::id();
        $user = User::where('id', $id)->first();

        if(!$user){
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
                if(count($parsedData)){
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
        }else if ($user->role_id == 2 && $lang === 'en'){
            $services = DB::select("SELECT us.user_id, us.service_id,  us.service_day, us.service_hour, us.service_amount, us.location, us.additional_services, s.title from user_services us INNER JOIN services s ON us.service_id = s.id where us.user_id = $id");

            for ($x = 0; $x < count($services); $x++) {
                $parsedData = json_decode($services[$x]->additional_services, true);
                if(count($parsedData)){
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
}
