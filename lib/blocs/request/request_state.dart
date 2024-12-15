part of 'request_bloc.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestLoaded extends RequestState {}

class RequestPending extends RequestState {}

class RequestAccepted extends RequestState {}

class RequestArrived extends RequestState {}

class RequestGoing extends RequestState {}

class RequestCompleted extends RequestState {}

class RequestCancelled extends RequestState {}

class RequestError extends RequestState {
  final String message;
  RequestError(this.message);
}
