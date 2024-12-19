part of 'service_bloc.dart';

@immutable
sealed class ServiceState {}

final class ServiceInitial extends ServiceState {}

class ServiceAccepted extends ServiceState {
  final Map<String, dynamic> data;
  ServiceAccepted(this.data);
}

class ServiceArrived extends ServiceState {}

class ServiceGoing extends ServiceState {}

class ServiceCompleted extends ServiceState {}

class ServiceCancelled extends ServiceState {}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}
