import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/join/signup_cubit/singup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(super.initialState);
  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignUpLoading());
    final auth = FirebaseAuth.instance;
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();

      FirebaseFirestore.instance.collection("user").doc(email).set({
        "Email": email,
        "name": name,
        "password": password,
        "image": null,
      });
      emit(SignUpSuccess(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(
            SignUpFailure(
              errMessage: 'This email is already in use',
              errDescription:
                  'This email is linked to an existing account. Please log in or check the entered information.',
            ),
          );
          break;
        default:
          emit(
            SignUpFailure(
              errMessage: 'Error while creating account',
              errDescription:
                  'An error occurred while creating the account! Please try again.',
            ),
          );
      }
    }
  }

  bool A_Z = false;
  bool a_z = false;
  bool diget = false;
  bool keywords = false;

  bool ObscureText = true;
  Obscure() {
    ObscureText = !ObscureText;

    emit(ScureText());
  }

  CorectPass(String password) {
    if (password.contains(RegExp(r'[A-Z]'))) {
      A_Z = true;
    } else {
      A_Z = false;
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      a_z = true;
    } else {
      a_z = false;
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      diget = true;
    } else {
      diget = false;
    }
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      keywords = true;
    } else {
      keywords = false;
    }

    emit(CorectPas());
  }
}
