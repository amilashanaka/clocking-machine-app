import 'dart:async';
import 'dart:convert';

import 'package:ClockIN/const.dart';
import 'package:ClockIN/data/staff/staff.dart';
import 'package:ClockIN/util/system_message.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:meta/meta.dart';

part 'staff_auth_init_event.dart';
part 'staff_auth_init_state.dart';

class StaffAuthInitBloc extends Bloc<StaffAuthInitEvent, StaffAuthInitState> {
  StaffAuthInitBloc({
    @required this.staff,
    @required this.deviceName,
    @required this.nfc,
  }) : super(LoadingState());

  String _data;
  bool nfc;
  Staff staff;
  String deviceName;

  @override
  Stream<StaffAuthInitState> mapEventToState(
    StaffAuthInitEvent event,
  ) async* {
    if (event is InitialNfcEvent) {
      yield* _mapInitialNfcEvent(event);
    } else if (event is InitialPinCodeEvent) {
      yield* _mapInitialPinCodeEvent(event);
    } else if (event is SetPinCodeEvent) {
      yield* _mapSetPinCodeEvent(event);
    } else if (event is ConfirmDataEvent) {
      yield* _mapConfirmDataEvent();
    }
  }

  Stream<StaffAuthInitState> _mapInitialNfcEvent(InitialNfcEvent event) async* {
    try {
      yield LoadingState();

      if (staff == null) {
        yield ErrorState(SystemMessage.errSystemError);
        return;
      }

      yield ScanningNfcState();

      final nfcData = await FlutterNfcReader.read();

      if (nfcData != null) {
        bool _check = await _checkDataDuplication(nfcData.id);
        if (!_check) {
          _data = nfcData.id;
          yield PreviewDataState(
            nfc: true,
            data: nfcData.id,
            staff: staff,
          );
        } else {
          yield DuplicateDataState(nfc: nfc, data: nfcData.id);
        }
      } else {
        yield ErrorState("No NFC tags identified!");
      }
    } catch (_) {
      yield ErrorState(SystemMessage.errSystemError);
    }
  }

  Stream<StaffAuthInitState> _mapInitialPinCodeEvent(
      InitialPinCodeEvent event) async* {
    try {
      yield LoadingState();

      if (staff != null) {
        yield ShowPinCodeEntryState();
      } else {
        yield ErrorState(SystemMessage.errSystemError);
      }
    } catch (_) {
      yield ErrorState(SystemMessage.errSystemError);
    }
  }

  Stream<StaffAuthInitState> _mapSetPinCodeEvent(SetPinCodeEvent event) async* {
    try {
      yield LoadingState();

      if (event.pinCode != null) {
        bool _check = await _checkDataDuplication(event.pinCode);
        if (!_check) {
          _data = event.pinCode;
          yield PreviewDataState(
            nfc: false,
            data: event.pinCode,
            staff: staff,
          );
        } else {
          yield DuplicateDataState(nfc: nfc, data: event.pinCode);
        }
      } else {
        yield ErrorState(SystemMessage.errSystemError);
      }
    } catch (_) {
      yield ErrorState(SystemMessage.errSystemError);
    }
  }

  Stream<StaffAuthInitState> _mapConfirmDataEvent() async* {
    try {
      yield LoadingState();

      var data = {
        "staff_id": staff.id,
        "set": nfc ? "nfc" : "pin",
      };

      if (nfc) {
        data["nfc"] = _data;
      } else {
        data["pin"] = _data;
      }

      final _headers = {"x-api-key": "$deviceName${Const.apiKey}"};

      Response _response = await Dio().post(
        Const.serverURL,
        queryParameters: data,
        options: Options(headers: _headers),
      );

      if (_response.statusCode == 200) {
        var _resData = json.decode(_response.data);

        if (_resData["result"] != null) {
          String _message = nfc ? "NFC " : "Pin code ";
          _message += "for ${staff.name} updated!";
          yield SuccessState(_message);
        } else {
          yield ErrorState(SystemMessage.errSystemError);
        }
      } else {
        yield ErrorState(SystemMessage.errSystemError);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<bool> _checkDataDuplication(String _value) async {
    try {
      final data = {"get": "staff"};

      final _headers = {"x-api-key": "$deviceName${Const.apiKey}"};

      Response _response = await Dio().post(
        Const.serverURL,
        queryParameters: data,
        options: Options(headers: _headers),
      );

      if (_response.statusCode == 200) {
        var _resData = json.decode(_response.data);

        if (_resData["staff"] != null) {
          bool _check = false;
          for (var i in _resData["staff"]) {
            if (nfc && i["nfc"] == _value) {
              _check = true;
            } else if (!nfc && i["pin"] == _value) {
              _check = true;
            }
          }
          return _check;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
