<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ServiceArabicResource;
use App\Http\Resources\ServiceEnglishResource;
use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ServiceController extends Controller
{
    function index_ess($lang)
    {
        if($lang === 'ar'){
            // $services = Service::where('service_type_id', 1);
            return ServiceArabicResource::Collection(Service::where('service_type_id', 1)->get());
        }
        return ServiceEnglishResource::collection(Service::where('service_type_id', 1)->get());
    }

    function index_add($lang)
    {
        if($lang === 'ar'){
            // $services = Service::where('service_type_id', 1);
            return ServiceArabicResource::Collection(Service::where('service_type_id', 2)->get());
        }
        return ServiceEnglishResource::collection(Service::where('service_type_id', 2)->get());
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
