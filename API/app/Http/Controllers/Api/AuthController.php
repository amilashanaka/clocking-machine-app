<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\User;

use Illuminate\Http\Request;
use App\Http\Controllers\API\ResponseController as ResponseController;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;
use Validator;

class AuthController extends Controller
{
   
    //create user
    public function signup(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|',
            'username' => 'required|string|unique|',
            'email' => 'required|string|email|unique:users',
            'password' => 'required',
            // 'address' => 'required|string',  
            // 'phone' => 'required|string',
        ]);

        if($validator->fails()){
            return $this->sendError($validator->errors());       
        }

        $input = $request->all();
        $input['password'] = bcrypt($input['password']);
        $input['user_type'] = '2';
        $input['status'] = '0';
        $user = User::create($input);
        if($user){
            $success['token'] =  $user->createToken('token')->accessToken;
            $success['message'] = "Registration successfull..";
            return $this->sendResponse($success);
        }
        else{
            $error = "Sorry! Registration is not successfull.";
            return $this->sendError($error, 401); 
        }
        
    }
    
    //login
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string',
            'password' => 'required'
        ]);

        if($validator->fails()){
            return $this->sendError($validator->errors());       
        }

        $credentials = request(['username', 'password']);
        if(!Auth::attempt($credentials)){
            $error = "Unauthorized";
            $res['success'] = false;
            $res['error'] = $error;
            return response()->json($res);
        }
        $user = $request->user();
        $res['success'] = true;
        // $res['token'] =  $user->createToken('token')->accessToken;
        $res['user'] =  $user;
        return response()->json($res);
    }

    //logout
    public function logout(Request $request)
    {
        
        $isUser = $request->user()->token()->revoke();
        if($isUser){
            // $request->user()->token()->delete();
            $success['message'] = "Successfully logged out.";
            return $this->sendResponse($success);
        }
        else{
            // $request->user()->token()->delete();
            $error = "Something went wrong.";
            return $this->sendError($error);
        }
            
        
    }

    //getuser
    public function getUser(Request $request)
    {
        //$id = $request->user()->id;
        $user = $request->user();
        if($user){
            return $this->sendResponse($user);
        }
        else{
            $error = "user not found";
            return $this->sendError($error);
        }
    }
    
    

    public function updateUser(Request $request){
        $id= $request->user()->id;
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|',
            'email' => ['required', 'string', 'email', Rule::unique('users')->ignore($id)],
            'shop_name' => 'required|string',
            'address' => 'required|string',
            'phone' => 'required|string',
        ]);

        if($validator->fails()){
            return $this->sendError($validator->errors());       
        }

        $user = User::find($id);

        $user->name  = $request->name;
        $user->email  = $request->email;
        $user->shop_name  = $request->shop_name;
        $user->address  = $request->address;
        $user->phone  = $request->phone;
        if($request->password != '' || $request->password != null){
            $user->password = $request->password;
        }

        try {

            $user->save();
            return $this->sendResponse($request->user());

        } catch (Exception $e) {

            return $this->sendError($e);
        }

    }
}
