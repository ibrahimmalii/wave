<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
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
        if ($user->role_id === 2 && $lang === 'ar') {
            //* To show data in user profile
            $services = DB::select("SELECT us.service_id,  us.service_day, us.service_hour, us.service_amount, us.location, s.title_subtitle from user_services us INNER JOIN services s ON user_id = 3");

            return response(['data' => $services], 200)
                ->header('Content-Type', 'text/plain');
        }else if ($user->role_id === 2 && $lang === 'en'){
            $services = DB::select("SELECT us.service_id,  us.service_day, us.service_hour, us.service_amount, us.location, s.title from user_services us INNER JOIN services s ON user_id = 3");

            return response(['data' => $services], 200)
                ->header('Content-Type', 'text/plain');
        }

        $msg = 'these data avaliable for only employees';
        return response(['msg' => $msg], 403)
            ->header('Content-Type', 'text/plain');
    }
}
