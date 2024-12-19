import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends HydratedBloc<SessionEvent, SessionState> {
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
      emit(SessionAuthenticated(event.phoneNumber));
    });

    on<SessionLoggedOut>((event, emit) async {
      FirebaseAuth.instance.signOut();
      emit(SessionUnauthenticated());
    });
  }

  @override
  SessionState? fromJson(Map<String, dynamic> json) {
    switch (json['state'] as String) {
      case 'SessionAuthenticated':
        return SessionAuthenticated(json['phoneNumber'] as String);
      case 'SessionUnauthenticated':
        return SessionUnauthenticated();
      default:
        return SessionInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(SessionState state) => {
        'state': state.runtimeType.toString(),
        if (state is SessionAuthenticated) 'phoneNumber': state.phoneNumber,
      };
}
