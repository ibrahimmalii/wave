<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class PhoneVerificationController extends Controller
{
    public function show(Request $request)
    {
        // return $request->user()->hasVerifiedPhone()
        //     ? redirect()->route('home')
        //     : view('verifyphone');

            return $request->user()->hasVerifiedPhone()
            ? 'success verification'
            : 'insert your verify code here';
    }

    public function verify(Request $request)
    {
        if ($request->user()->verification_code !== $request->code) {
            throw ValidationException::withMessages([
                'code' => ['The code your provided is wrong. Please try again or request another call.'],
            ]);
        }

        if ($request->user()->hasVerifiedPhone()) {
            return 'success';
        }

        $request->user()->markPhoneAsVerified();

        // return redirect()->route('home')->with('status', 'Your phone was successfully verified!');
        return 'Your phone was successfully verified!';
    }
}
