import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionInitial()) {
    on<SessionStarted>((event, emit) async {
      // Aquí puedes verificar si hay una sesión activa
      // Por ejemplo, leyendo desde almacenamiento local
      final phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
      if (phoneNumber != null) {
        emit(SessionAuthenticated(phoneNumber));
      } else {
        emit(SessionUnauthenticated());
      }
    });

    on<SessionLoggedIn>((event, emit) async {
      // Aquí puedes guardar la sesión
      // await _storePhoneNumber(event.phoneNumber);
      emit(SessionAuthenticated(event.phoneNumber));
    });

    on<SessionLoggedOut>((event, emit) async {
      // Aquí puedes eliminar la sesión
      // await _clearStoredPhoneNumber();
      emit(SessionUnauthenticated());
    });
  }
}
