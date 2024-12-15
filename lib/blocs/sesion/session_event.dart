part of 'session_bloc.dart';

@immutable
sealed class SessionEvent {}

class SessionStarted extends SessionEvent {}

class SessionLoggedIn extends SessionEvent {
  final String phoneNumber;
  SessionLoggedIn(this.phoneNumber);
}

class SessionLoggedOut extends SessionEvent {}
