import 'dart:async';

import 'package:ClockIN/const.dart';
import 'package:ClockIN/data/staff/staff.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc() : super(StaffLoading());

  @override
  Stream<StaffState> mapEventToState(
    StaffEvent event,
  ) async* {
    if (event is LoadStaffEvent) {
      yield* _mapLoadStaffEvent();
    }
  }

  Stream<StaffState> _mapLoadStaffEvent() async* {
    try {
      yield StaffLoading();

      Response response = await Dio().get(Const.loadStaffURL);

      if (response.data["success"]) {
        List<Staff> _staffs = [];
        for (var i in response.data["data"]) {
          _staffs.add(Staff.fromMap(i));
        }
        if (_staffs.length > 0) {
          yield StaffLoaded(_staffs);
        } else {
          yield StaffLoadedEmpty();
        }
      } else {
        yield StaffLoadedEmpty();
      }
    } catch (error) {
      print(error);
      yield StaffLoadedEmpty();
    }
  }
}
