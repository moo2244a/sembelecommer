import 'package:firebase_auth/firebase_auth.dart';

abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  User user;
  SignUpSuccess({required this.user});
}

class SignUpFailure extends SignUpState {
  String errMessage;
  String errDescription;
  SignUpFailure({required this.errMessage, required this.errDescription});
}

final class ScureText extends SignUpState {}

final class CorectPas extends SignUpState {}
