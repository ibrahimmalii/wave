<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;
use Twilio\Rest\Client;

class AuthController extends Controller
{

    public function createAndSendMsg($phone_number)
    {
        /* Get credentials from .env */
        $token = getenv("TWILIO_AUTH_TOKEN");
        $twilio_sid = getenv("TWILIO_SID");
        $twilio_verify_sid = getenv("TWILIO_VERIFY_SID");
        $twilio = new Client($twilio_sid, $token);
        $twilio->verify->v2->services($twilio_verify_sid)
            ->verifications
            ->create($phone_number, "sms");
    }

    protected function register(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'max:255'],
            'phone_number' => ['required', 'numeric', 'unique:users'],
            'password' => ['required', 'string', 'min:8'],
        ]);

        if ($validator->fails()) {
            return response(['msg' => 'Phone number is already exist!!'], 403)
                ->header('Content-Type', 'text/plain');
        }

        
        $this->createAndSendMsg($request->phone_number);
        User::create([
            'name' => $request->name,
            'phone_number' => $request->phone_number,
            'password' => Hash::make($request->password),
            'role_id' => 2
        ]);
        return response(['phone_number' => $request->phone_number], 200)
            ->header('Content-Type', 'text/plain');
    }

    protected function verify(Request $request)
    {
        $data = $request->validate([
            'verification_code' => ['required', 'numeric'],
            'phone_number' => ['required', 'string'],
        ]);
        /* Get credentials from .env */
        $token = getenv("TWILIO_AUTH_TOKEN");
        $twilio_sid = getenv("TWILIO_SID");
        $twilio_verify_sid = getenv("TWILIO_VERIFY_SID");
        $twilio = new Client($twilio_sid, $token);
        $verification = $twilio->verify->v2->services($twilio_verify_sid)
            ->verificationChecks
            ->create($data['verification_code'], array('to' => $data['phone_number']));
        if ($verification->valid) {
            $user = tap(User::where('phone_number', $data['phone_number']))->update(['isVerified' => true]);

            $user = User::where('phone_number', $request->phone_number)->first();
            $token = $user->createToken('auth_token')->plainTextToken;
            $data = [
                'access_token' => $token,
                'user' => $user,
            ];

            return response(['data' => $data], 200)
                ->header('Content-Type', 'text/plain');
        }
        return response(['msg' => 'Invalid verification code entered!'], 401)
            ->header('Content-Type', 'text/plain');
    }

    public function login(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'phone_number' => 'required',
            'password' => 'required',
        ]);


        if ($validator->fails()) {
            return response(['msg' => 'Phone number not found'], 404)
                ->header('Content-Type', 'text/plain');
        }

        $user = User::where('phone_number', $request->phone_number)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response(['msg' => 'Invalid credintials, please check your data and try again!'], 401)
                ->header('Content-Type', 'text/plain');
        }

        if ($user->isVerified === 0) {
            return response(['msg' => 'User need to verify his account!'], 401)
                ->header('Content-Type', 'text/plain');
        }

        $token = $user->createToken('auth_token')->plainTextToken;
        $data = [
            'access_token' => $token,
            'user' => $user,
        ];

        return response(['data' => $data], 200)
            ->header('Content-Type', 'text/plain');
    }

    // handle forget password
    public function forget(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'phone_number' => 'required',
        ]);

        if ($validator->fails()) {
            return response(['msg' => 'Number is requeired'], 401)
                ->header('Content-Type', 'text/plain');
        }

        $user = User::where('phone_number', $request->phone_number)->first();

        if (!$user) {
            return response(['msg' => 'Account not found!'], 404)
                ->header('Content-Type', 'text/plain');
        }

        // Create and send msg
        $this->createAndSendMsg($request->phone_number);

        return response(['phone_number' => $user['phone_number']], 200)
            ->header('Content-Type', 'text/plain');
    }

    public function updatePasswordFromLogin(Request $request)
    {
        $user = User::where('phone_number', $request->phone_number)->update(['password' => Hash::make($request->password)]);;

        if (!$user) {
            return response(['msg' => 'Account not found!'], 404)
                ->header('Content-Type', 'text/plain');
        }

        return response(['msg' => 'password updated successfully'], 200)
            ->header('Content-Type', 'text/plain');
    }

    public function updatePasswordFromSetting(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone_number' => 'required',
            'password' => 'required',
            'new_password' => 'required',
        ]);

        if ($validator->fails()) {
            return response(['msg' => 'Some data is required!!'], 400)
                ->header('Content-Type', 'text/plain');
        }

        $user = User::where('phone_number', $request->phone_number)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response(['msg' => 'Invalid credintials, please check your data and try again!'], 401)
                ->header('Content-Type', 'text/plain');
        }

        User::where('phone_number', $request->phone_number)->update(['password' => Hash::make($request->new_password)]);

        return response(['msg' => 'password updated successfully'], 200)
            ->header('Content-Type', 'text/plain');
    }
}
