<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class TranslateController extends Controller
{
    //
    public function index(Request $request)
    {
        $data = [
            'content' => trans('content')
        ];
        return response()->json($data, 200);
    }
}
