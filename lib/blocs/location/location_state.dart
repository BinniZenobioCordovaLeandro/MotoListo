part of 'location_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

class LocationTracking extends LocationState {
  final Position position;
  LocationTracking(this.position);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
