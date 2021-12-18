<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Twilio\Rest\Client;

class notifiedUserController extends Controller
{
    public function pickup(Request $request, $id)
    {
        $client = new Client(getenv("TWILIO_SID"), getenv("TWILIO_AUTH_TOKEN"));
        $user = User::find($id);
        // $user->status = 'Shipped';
        // $user->notification_status = 'queued';
        // $user->save();

        $callbackUrl = str_replace('/pickup', '', 'http://www.facebook.com');


        $this->sendMessage(
            $client,
            $user->phone_number,
            'Next wash date is tomorrow, please renew the service :(',
            $callbackUrl
        );
        return response(['msg'=> 'process success :)'], 200)
            ->header('Content-Type', 'text/plain');
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
}
