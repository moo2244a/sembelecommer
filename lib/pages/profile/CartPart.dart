import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/modelorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Cartprofile extends StatelessWidget {
  Cartprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          SizedBox(height: 40),

          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Iconsax.arrow_left_2,
                      size: 30,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                Text(
                  "Cart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection("orders")
                      .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Cart is empty"));
                }
                final List<Modelorder> listCartItems =
                    snapshot.data!.docs.map<Modelorder>((doc) {
                      return Modelorder.fromMap(
                        doc.data() as Map<String, dynamic>,
                        docId: doc.id,
                      );
                    }).toList();
                double totalPrice = 0;
                for (var order in listCartItems) {
                  double finalPrice =
                      order.product!.offer != null
                          ? order.product!.price *
                              (100 - order.product!.offer!) /
                              100
                          : order.product!.price;
                  totalPrice += finalPrice * order.quantity!;
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listCartItems.length,
                        itemBuilder: (context, index) {
                          return ProductCart(order: listCartItems[index]);
                        },
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "EGP ${totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Divider(color: Colors.grey[300], thickness: 1),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Checkout",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCart extends StatelessWidget {
  Modelorder order;
  ProductCart({super.key, required this.order});
  void deleteOrder() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("orders")
        .doc(order.id)
        .delete();
  }

  String? PriceStringEq;
  String? createThePrice(double Price) {
    String PriceString = Price.toInt().toString();
    PriceStringEq = PriceString;
    int one = 3;
    for (int i = 0; i < PriceStringEq!.length; i++) {
      if (i % one == 0 && i != 0) {
        PriceStringEq =
            "${PriceStringEq!.substring(0, PriceStringEq!.length - i)},${PriceStringEq!.substring(PriceStringEq!.length - i, PriceStringEq?.length)}";
        one += 4;
      }
    }
    return PriceStringEq;
  }

  @override
  Widget build(BuildContext context) {
    double finalPrice =
        order.product!.offer != null
            ? order.product!.price * (100 - order.product!.offer!) / 100
            : order.product!.price;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          // الصورة مع Badge الخصم
          Stack(
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  order.product!.Image[0],
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              if (order.product!.offer != null)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      "${order.product!.offer!.toInt()}% OFF",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المنتج
                Text(
                  order.product!.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      "Size: ",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      order.selectedSize ?? "-",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Color: ",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Color(
                        order.product!.color?[order.selectedColor ?? 0] ??
                            0xFF3366CC,
                      ),
                    ),
                    SizedBox(width: 30),
                    IconButton(
                      onPressed: () {
                        deleteOrder();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${order.product!.name} has been removed",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (order.product!.offer != null)
                      Text(
                        "EGP ${createThePrice(order.product!.price)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      "EGP ${createThePrice(finalPrice)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Qty: ${order.quantity}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
