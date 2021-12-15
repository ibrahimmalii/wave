<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ServiceArabicResource;
use App\Http\Resources\ServiceEnglishResource;
use App\Models\Service;
use Illuminate\Http\Request;

class ServiceController extends Controller
{
    function index($lang)
    {
        if($lang === 'ar'){
            return ServiceArabicResource::Collection(Service::all());
        }
        return ServiceEnglishResource::collection(Service::all());
    }
}
