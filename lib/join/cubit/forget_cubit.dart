import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'forget_state.dart';

class ForgetCubit extends Cubit<ForgetState> {
  ForgetCubit() : super(ForgetInitial());
  bool? loding;
  Future<void> resetPasswordIfEmailExists(String email) async {
    loding = true;
    emit(Forgetloding());
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(email).get();

      if (!docSnapshot.exists) {
        loding = false;

        emit(ForgetFail("Email not found"));
      } else {
        loding = false;
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        emit(Forgetsuss());
      }
    } catch (e) {
      loding = false;
      emit(ForgetFail("No internet connection"));
    }
  }
}
