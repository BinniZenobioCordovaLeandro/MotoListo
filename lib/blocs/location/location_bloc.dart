import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:motolisto/hooks/use_position.dart';
import 'package:motolisto/hooks/use_vehicle.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionStreamSubscription;

  LocationBloc() : super(LocationInitial()) {
    on<StartLocationTracking>((event, emit) async {
      try {
        final position = await determinePosition();
        emit(LocationTracking(position));
        _positionStreamSubscription = streamPosition().listen(
          (position) {
            add(LocationChanged(position));
          },
        );
        await updateAvailable(true);
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });

    on<StopLocationTracking>((event, emit) async {
      await _positionStreamSubscription?.cancel();
      emit(LocationInitial());
      await updateAvailable(false);
    });

    on<LocationChanged>((event, emit) async {
      emit(LocationTracking(event.position));
      await updateLocation(event.position);
    });
  }
}
