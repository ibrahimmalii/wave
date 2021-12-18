<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\AvaliableTimeResource;
use App\Models\AvaliableTime;
use Illuminate\Http\Request;

class AvaliableTimeController extends Controller
{
    public function index()
    {
        return AvaliableTimeResource::Collection(AvaliableTime::all());
    }
}
