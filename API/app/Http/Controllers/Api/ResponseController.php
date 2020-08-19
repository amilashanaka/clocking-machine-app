<?php

namespace App\Http\Controllers\API;


use Illuminate\Http\Request;
use App\Http\Controllers\Controller as Controller;
use Illuminate\Support\Facades\Auth;
use App\User;

class ResponseController extends Controller
{
    public function sendResponse($data)
    {
        $response = [
            'success' => true,
            'data' => $data,
        ];
        return response()->json($response, 200);
    }


    public function sendError($error, $code = 404)
    {
    	$response = [
            'success' => false,
            'error' => $error,
        ];
        return response()->json($response, $code);
    }
}
