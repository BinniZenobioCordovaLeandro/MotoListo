part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

class AcceptService extends ServiceEvent {
  final String documentId;

  AcceptService(this.documentId);
}

class CloseService extends ServiceEvent {}

class UpdateService extends ServiceEvent {
  final String status;

  UpdateService(this.status);
}

class ServiceChanged extends ServiceEvent {
  final String status;

  ServiceChanged(this.status);
}
