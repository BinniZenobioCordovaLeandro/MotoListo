part of 'messenger_cubit.dart';

@immutable
sealed class MessengerState {}

final class MessengerInitial extends MessengerState {}

final class MessengerShowSnackbar extends MessengerState {
  final String message;

  MessengerShowSnackbar(this.message);
}
