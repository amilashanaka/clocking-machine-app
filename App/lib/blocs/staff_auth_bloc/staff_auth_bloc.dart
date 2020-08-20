import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' show join;
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:meta/meta.dart';

import 'package:ClockIN/data/staff/staff.dart';
import 'package:ClockIN/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'staff_auth_event.dart';
part 'staff_auth_state.dart';

class StaffAuthBloc extends Bloc<StaffAuthEvent, StaffAuthState> {
  StaffAuthBloc() : super(LoadingState());

  Staff _staff;
  String _imagePath;
  CameraController _cameraController;

  @override
  Stream<StaffAuthState> mapEventToState(
    StaffAuthEvent event,
  ) async* {
    if (event is ReadNfcEvent) {
      yield* _mapReadNfcEvent();
    } else if (event is ManualAuthEvent) {
      yield ShowManualAuthState();
    } else if (event is SetManualAuthEvent) {
      yield* _mapSetManualAuthEventEvent(event);
    } else if (event is InActionEvent) {
      yield* _mapInOutActionEvent(true);
    } else if (event is OutActionEvent) {
      yield* _mapInOutActionEvent(false);
    }
  }

  Stream<StaffAuthState> _mapReadNfcEvent() async* {
    try {
      yield ScanningNfcState();

      _imagePath = "";

      final nfcData = await FlutterNfcReader.read();

      if (nfcData != null) {
        String _image = await _captureImage();
        _imagePath = _image;

        if (_image == null || _image == "") {
          yield ErrorState("Oops.. Something went wrong!");
          return;
        }

        final data = {
          'rfid': nfcData.id,
        };

        Response response =
            await Dio().post(Const.getStaffByNfcURL, data: data);

        if (response.data['success']) {
          _staff = Staff.fromMap(response.data['data']);
          yield SelectActionState(_staff);
        } else {
          yield ErrorState("NFC tag is not identified!\n\nID: ${nfcData.id}");
        }
      } else {
        yield ErrorState("No NFC tags identified!");
      }
    } catch (_) {
      yield ErrorState("Oops.. Something went wrong!");
    }
  }

  Stream<StaffAuthState> _mapSetManualAuthEventEvent(
      SetManualAuthEvent event) async* {
    try {
      yield LoadingState();

      _imagePath = "";

      final data = {'pin_code': event.pinCode};

      Response response = await Dio().post(
        Const.getStaffByManualURL,
        data: data,
      );
      if (response.data['success']) {
        _staff = Staff.fromMap(response.data['data']);
        yield SelectActionState(_staff);
      } else {
        yield ErrorState(
            "Entered PIN CODE is not valid!\n\nPIN CODE : ${event.pinCode}");
      }
    } catch (_) {
      yield ErrorState("Oops.. Something went wrong!");
    }
  }

  Stream<StaffAuthState> _mapInOutActionEvent(bool inAction) async* {
    try {
      yield LoadingState();

      final action = inAction ? "in" : "out";
      final fileAvailable = (_imagePath != null && _imagePath != "");
      final imageFile =
          fileAvailable ? await MultipartFile.fromFile(_imagePath) : null;

      final data = FormData.fromMap({
        "file_available": fileAvailable,
        "image_file": imageFile,
        "image_file_name": Uuid().v4(),
        "action": action,
        "staff_id": _staff.id,
        "time": DateTime.now().toString()
      });

      Response response = await Dio().post(Const.setStaffInOutURL, data: data);
      if (response.data["success"]) {
        yield SuccessState("You have registered as ${action.toUpperCase()}");
      } else {
        yield ErrorState("Oops.. Something went wrong!");
      }
    } catch (error) {
      print(error);
      yield ErrorState("Oops.. Something went wrong!");
    }
  }

  Future<String> _captureImage() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras.last,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController.initialize();

      final path =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      await _cameraController.takePicture(path);

      return path;
    } catch (_) {
      return null;
    }
  }
}
