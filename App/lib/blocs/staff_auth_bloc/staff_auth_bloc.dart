import 'dart:async';
import 'dart:io';

import 'package:ClockIN/graphql/g_actions.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' show join;
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:meta/meta.dart';
import 'package:ClockIN/data/staff/staff.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'staff_auth_event.dart';
part 'staff_auth_state.dart';

class StaffAuthBloc extends Bloc<StaffAuthEvent, StaffAuthState> {
  StaffAuthBloc() : super(LoadingState());

  Staff _staff;
  String _imagePath;
  CameraController _cameraController;
  GActions _actions = GActions();

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

        _staff = await _actions.getStaffId(rfid: nfcData.id);

        if (_staff != null) {
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
      _staff = await _actions.getStaffId(pinCode: event.pinCode);

      if (_staff != null) {
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
      var _data;

      if (fileAvailable) {
        var byteData = File(_imagePath).readAsBytesSync();

        var multipartFile = MultipartFile.fromBytes(
          'photo',
          byteData,
          filename: '${DateTime.now().second}.png',
          contentType: MediaType("image", "png"),
        );

        _data = {
          "image_file": multipartFile,
        };
      } else {
        _data = null;
      }

      final result = await _actions.setStaffInOut(
        staffId: _staff.id,
        action: action,
        fileAvailable: fileAvailable,
        imageFileName: Uuid().v4(),
        data: _data,
      );

      if (result != null) {
        yield SuccessState("You have registered as ${action.toUpperCase()}");
      } else {
        yield ErrorState("Oops.. Something went wrong!");
      }
    } catch (_) {
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
