part of 'forget_cubit.dart';

@immutable
abstract class ForgetState {}

final class ForgetInitial extends ForgetState {}

final class Forgetloding extends ForgetState {}

final class Forgetsuss extends ForgetState {}

final class ForgetFail extends ForgetState {
  String errormassage;
  ForgetFail(this.errormassage);
}
