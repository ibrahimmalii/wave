<?php

namespace App\Http\Controllers;

use App\Http\Resources\OfferArResource;
use App\Http\Resources\OfferResource;
use App\Models\Offer;
use Illuminate\Http\Request;

class OfferController extends Controller
{
    public function index($lang)
    {
        if ($lang === 'en') {
            $offers = OfferResource::collection(Offer::where('active', 1)->get());
            return response(['msg' => 'completed successfully', 'data' => $offers], 200)
                ->header('Content-Type', 'text/plain');
        }

        $offers = OfferArResource::collection(Offer::where('active', 1)->get());
        return response(['msg' => 'completed successfully', 'data' => $offers], 200)
            ->header('Content-Type', 'text/plain');
    }
}
