<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    
    public function register(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'name'=> ['required','string','max:255','min:3'],
            'email' => ['required','email','unique:users,email','max:255'],
            'password' => ['required', 'string', 'min:8','max:255', 'confirmed'],
            'phone_number' => 'min:5|string',
        ]);


        if ($validator->fails())
        {
            return 'invalid data';
        }


        $user = User::create([
            'name'=>$request->name,
            'email'=>$request->email,
            'password'=>Hash::make($request->password),
            'phone_number'=>$request->phone_number,
        ]);


        $token = $user->createToken('auth_token')->plainTextToken;

        $data = [
            'access_token' => $token,
            'user' => $user,
        ];


        return $data;
    }



    public function login(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);


        if ($validator->fails()) {
            return $this->apiResponse(null, $validator->errors(), 200);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;
        $data = [
            'access_token' => $token,
            'user' => $user,
        ];


        return $data;
    }
}
