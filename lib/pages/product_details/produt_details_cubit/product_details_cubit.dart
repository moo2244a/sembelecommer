import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/modelorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  bool? loding;
  int quantity = 1;
  SetSateUi() {
    emit(SetSateui());
  }

  quantity123() {
    quantity++;
    emit(ProductQuantityplass());
  }

  quantity_1_2_3() {
    if (quantity > 1) quantity--;
    emit(ProductQuantitymince());
  }

  Future<void> addOrder(Modelorder order) async {
    if (isClosed) return;
    emit(Productaddcartloading());
    try {
      final userEmail = FirebaseAuth.instance.currentUser!.email;

      final docRef =
          FirebaseFirestore.instance
              .collection('user')
              .doc(userEmail)
              .collection("orders")
              .doc();

      await docRef.set(order.toMap());

      if (!isClosed) {
        emit(Productaddcartsuss());
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProductaddcartFailure());
      }
    }
  }
}
