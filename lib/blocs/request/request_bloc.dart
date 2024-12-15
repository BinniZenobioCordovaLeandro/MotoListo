import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:motolisto/hooks/use_position.dart';
import 'package:motolisto/hooks/use_request.dart';
import 'package:motolisto/hooks/use_vehicles.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial()) {
    on<LoadRequest>((event, emit) async {
      emit(RequestLoading());
      try {
        // Simula una carga de datos
        await Future.delayed(Duration(seconds: 2));
        emit(RequestLoaded());
      } catch (e) {
        emit(RequestError(e.toString()));
      }
    });

    on<SubmitRequest>((event, emit) async {
      emit(RequestLoading());
      try {
        // Simula una solicitud
        Position position = await determinePosition();
        // Aquí puedes agregar la lógica para solicitar el servicio de tuk-tuk usando la ubicación actual
        print('Ubicación actual: ${position.latitude}, ${position.longitude}');

        await sendRequestToFirestore(position).then((stream) {
          stream.listen((snapshot) {
            if (snapshot.exists) {
              Map<String, dynamic> data =
                  snapshot.data() as Map<String, dynamic>;
              print('Document data: ${data}');
              add(RequestChanged(data['status'] as String));
            } else {
              print('Document does not exist');
            }
          });
        });

        getNearVehicles(position, 50).then((value) {
          print('Vehículos cercanos: $value');
          List<String> tokens =
              value.map<String>((e) => e['token'] as String).toList();
          sendNotificationToNearbyVehicles(tokens);
        });

        emit(RequestPending());
      } catch (e) {
        emit(RequestError(e.toString()));
      }
    });

    on<CloseRequest>((event, emit) {
      emit(RequestInitial());
    });

    on<CancelRequest>((event, emit) async {
      emit(RequestLoading());
      try {
        // Simula una cancelación
        await cancelRequest();
      } catch (e) {
        emit(RequestError(e.toString()));
      }
    });

    on<RequestChanged>((event, emit) async {
      if (event.status == 'accepted') {
        emit(RequestAccepted());
      } else if (event.status == 'arrived') {
        emit(RequestArrived());
      } else if (event.status == 'going') {
        emit(RequestGoing());
      } else if (event.status == 'completed') {
        emit(RequestCompleted());
      } else if (event.status == 'cancelled') {
        emit(RequestCancelled());
      } else {
        emit(RequestPending());
      }
    });
  }
}
