import 'package:doctor/model/model product.dart';

class Modelorder {
  String? selectedSize;
  int? selectedColor;
  Product? product;
  int? quantity;
  String? id;

  Modelorder({
    this.id,
    this.selectedSize,
    this.selectedColor,
    this.product,
    this.quantity,
  });

  // تحويل الكائن إلى Map للتخزين في Firestore
  Map<String, dynamic> toMap() {
    return {
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
      'product': product != null ? product!.toMap() : null,
    };
  }

  // استرجاع الكائن من Map
  factory Modelorder.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Modelorder(
      id: docId,
      selectedSize: map['selectedSize'],
      selectedColor: map['selectedColor'],
      quantity: map['quantity'],
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
    );
  }
}
