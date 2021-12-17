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

    function show($id, $lang)
    {
        $service = Service::find($id);
        if(!$service){
            return response(['msg'=> 'Service not found'], 404)
                ->header('Content-Type', 'text-plain');
        }
        if($lang === 'ar'){
            return new ServiceArabicResource(Service::findOrFail($id));
        }
        return new ServiceEnglishResource(Service::findOrFail($id));
    }
}
