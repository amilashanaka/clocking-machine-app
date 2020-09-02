import 'dart:async';

import 'package:ClockIN/const.dart';
import 'package:ClockIN/graphql/g_queries.dart';
import 'package:ClockIN/data/staff/staff.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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

      final httpLink = HttpLink(uri: Const.graphqlURL);
      final link = Link.from([httpLink]);
      final GraphQLClient _graphQLClient =
          GraphQLClient(cache: InMemoryCache(), link: link);

      final result = await _graphQLClient
          .query(QueryOptions(documentNode: gql(GQueries.getEmployees)));

      print(result.toString());

      if (!result.hasException) {
        List<Staff> _staffs = [];
        for (var i in result.data['employees']['data']) {
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
