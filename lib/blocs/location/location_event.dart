part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

class StartLocationTracking extends LocationEvent {}

class StopLocationTracking extends LocationEvent {}

class LocationChanged extends LocationEvent {
  final Position position;
  LocationChanged(this.position);
}
