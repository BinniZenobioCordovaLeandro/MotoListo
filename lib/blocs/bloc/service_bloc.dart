import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:motolisto/hooks/use_service.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  String? currentDocumentId;
  Map<String, dynamic>? currentData;

  ServiceBloc() : super(ServiceInitial()) {
    on<ServiceEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AcceptService>((event, emit) {
      try {
        currentDocumentId = event.documentId;
        acceptServiceFromFirestore(event.documentId).then((stream) {
          stream.listen((snapshot) {
            if (snapshot.exists) {
              Map<String, dynamic> data =
                  snapshot.data() as Map<String, dynamic>;
              currentData = data;
              print('Document data: ${data}');
              add(ServiceChanged(data['status'] as String));
            } else {
              print('Document does not exist');
            }
          });
        });
      } catch (e) {
        emit(ServiceError(e.toString()));
      }
    });

    on<CloseService>((event, emit) {
      emit(ServiceInitial());
    });

    on<UpdateService>((event, emit) {
      updateServiceFromFirestore(currentDocumentId!, event.status);
    });

    on<ServiceChanged>((event, emit) {
      if (event.status == 'accepted') {
        emit(ServiceAccepted(
          currentData!,
        ));
      } else if (event.status == 'arrived') {
        emit(ServiceArrived());
      } else if (event.status == 'going') {
        emit(ServiceGoing());
      } else if (event.status == 'completed') {
        emit(ServiceCompleted());
      } else if (event.status == 'cancelled') {
        emit(ServiceCancelled());
      } else {
        emit(ServiceError('Estado desconocido'));
      }
    });
  }
}
