part of 'session_bloc.dart';

@immutable
sealed class SessionState {}

final class SessionInitial extends SessionState {}

class SessionAuthenticated extends SessionState {
  final String phoneNumber;
  SessionAuthenticated(this.phoneNumber);
}

class SessionUnauthenticated extends SessionState {}
