<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class EmployeesProfileController extends Controller
{
    public function index ()
    {
        $id = Auth::id();
        $user = User::where('id', $id)->first();
        if($user->role_id === 3){
            $services=DB::select("SELECT us.id, us.service_day, us.service_hour, us.service_amount, us.location, us.arrived_at, us.completed_at, u.name as client_name, u.phone_number FROM user_services us INNER JOIN users u ON us.user_id = u.id");
            return response(['data' => $services], 200)
                ->header('Content-Type', 'text/plain');
        }

        $msg = 'these data avaliable for only employees';
        return response(['msg' => $msg], 403)
                ->header('Content-Type', 'text/plain');
    }
}
