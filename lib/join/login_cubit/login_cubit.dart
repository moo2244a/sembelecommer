import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login(String emailAddress, String password) async {
    emit(LoginLoding());
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (isClosed) return;
      emit(LoginSuccessful());
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;

      String errorMessage = '';
      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'User account has been disabled';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many attempts, please try again later';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network connection failed';
      } else if (e.code == 'invalid-credential' ||
          e.code == 'INVALID_LOGIN_CREDENTIALS') {
        errorMessage = 'Invalid login credentials';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/Password login is not enabled';
      } else {
        errorMessage = 'Unknown error: ${e.code}';
      }

      emit(LoginFailure(errorMessage));
    } catch (e) {
      if (isClosed) return;
      emit(LoginFailure('حدث خطأ: $e'));
    }
  }
}
