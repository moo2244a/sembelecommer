part of 'login_cubit.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginSuccessful extends LoginState {}

final class LoginLoding extends LoginState {}

final class LoginFailure extends LoginState {
  String errorMessage;
  LoginFailure(this.errorMessage);
}
