part of 'staff_auth_init_bloc.dart';

@immutable
abstract class StaffAuthInitEvent {}

class InitialNfcEvent extends StaffAuthInitEvent {}

class InitialPinCodeEvent extends StaffAuthInitEvent {}

class SetPinCodeEvent extends StaffAuthInitEvent {
  final String pinCode;

  SetPinCodeEvent(this.pinCode);
}

class ConfirmDataEvent extends StaffAuthInitEvent {}
