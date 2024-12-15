part of 'request_bloc.dart';

@immutable
sealed class RequestEvent {}

class LoadRequest extends RequestEvent {}

class SubmitRequest extends RequestEvent {}

class CloseRequest extends RequestEvent {}

class CancelRequest extends RequestEvent {}

class RequestChanged extends RequestEvent {
  final String status;
  RequestChanged(this.status);
}
