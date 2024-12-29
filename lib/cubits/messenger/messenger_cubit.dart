import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'messenger_state.dart';

class MessengerCubit extends Cubit<MessengerState> {
  MessengerCubit() : super(MessengerInitial());

  void showSnackbar(String message) {
    emit(MessengerShowSnackbar(message));
  }
}
