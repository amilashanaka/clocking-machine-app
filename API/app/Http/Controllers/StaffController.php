<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StaffController extends Controller
{
    public function getData(Request $request)
    {
        try {
            $staffs = DB::table('staff')->select('id', 'name', 'rfid')->get();
            $data["success"] = true;
            if ($staffs != null) {
                $data["success"] = true;
                $data["data"] = $staffs;
                return response()->json($data);
            } else {
                $data["data"] = [];
                return response()->json($data);
            }
        } catch (Exception $e) {
            $data["success"] = false;
            $data["error"] = $e->getMessage();
            return response()->json($data);
        }
    }

    public function getStaffByNfc(Request $request)
    {
        try {
            $input = $request->all();
            $rfid = $input['rfid'];
            $staff = DB::table('staff')->where('rfid', '=', $rfid)->first();
            $data['success'] = true;

            if ($staff != null) {
                $data['data'] = $staff;
            } else {
                $data['success'] = false;
            }

            return response()->json($data);
        } catch (Exception $e) {
            $data['success'] = false;
            return response()->json($data);
        }
    }

    public function getStaffByManualAuth(Request $request)
    {
        try {
            $input = $request->all();
            $pin_code = $input['pin_code'];
            $staff = DB::table('staff')->where('pin_code', '=', $pin_code)->first();
            $data['success'] = true;

            if ($staff != null) {
                $data['data'] = $staff;
            } else {
                $data['success'] = false;
            }

            return response()->json($data);
        } catch (Exception $e) {
            $data['success'] = false;
            return response()->json($data);
        }
    }

    public function setInOut(Request $request)
    {
        try {
            $input = $request->all();
            $action = $input['action'];
            $staff_id = $input['staff_id'];
            $time = $input['time'];

            $file_available = $input['file_available'];
            $image_file_name = $input['image_file_name'];
            $file_path = '';

            if ($file_available) {
                if ($request->hasFile('image_file')) {
                    $image = $request->file('image_file');
                    if ($image->isValid()) {
                        $folder = '/uploads/images';
                        $filename = $image_file_name . '.' . $image->getClientOriginalExtension();
                        $file_path = $image->storeAs($folder, $filename, 'public');
                    }
                }
            }


            if ($action == 'in') {
                $check =  DB::table('staff_in_out')->updateOrInsert(
                    ['staff_id' => $staff_id],
                    ['in' => $time, 'image_path' => $file_path]
                );
            } else if ($action == 'out') {
                $check =  DB::table('staff_in_out')->updateOrInsert(
                    ['staff_id' => $staff_id],
                    ['out' => $time, 'image_path' => $file_path]
                );
            } else {
                $data['success'] = false;
                $data['error'] = 'Undefied action';
                return response()->json($data);
            }

            $data['success'] = $check;
            if ($check) {
                DB::table('staff_in_out_history')->insert([
                    'action' => $action,
                    'staff_id' => $staff_id,
                    'time' => $time,
                    'image_path' => $file_path
                ]);
            } else {
                $data['error'] = 'System error';
            }

            return response()->json($data);
        } catch (Exception $e) {
            $data["success"] = false;
            $data["error"] = $e->getMessage();
            return response()->json($data);
        }
    }
}
