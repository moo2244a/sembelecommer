import 'package:doctor/model/model%20product.dart';
import 'package:doctor/model/modelorder.dart';

import 'package:doctor/pages/cubit/product_details_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ProductDetailsPage extends StatefulWidget {
  Product shop_by_categoriesAllProdect;
  ProductDetailsPage({required this.shop_by_categoriesAllProdect});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? selectedSize;
  int? selectedColor; // 0 = أسود، 1 = أبيض
  String? PriceString;
  int quantity = 1;
  Modelorder order = Modelorder();

  String? PriceStringEq;
  String? createThePrice(double Price) {
    PriceString = Price.toInt().toString(); //4500,000
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
    return BlocProvider(
      create: (context) => ProductDetailsCubit(),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is Productaddcartsuss) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Product added to cart 🛒 successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProductaddcartFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to add product to cart "),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder:
            (context, state) => Scaffold(
              backgroundColor: Colors.grey[200],
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          PageView(
                            children:
                                widget.shop_by_categoriesAllProdect.Image.map((
                                  toElement,
                                ) {
                                  return Container(
                                    margin: EdgeInsets.all(50),
                                    child: Image.network(
                                      toElement,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                          ),

                          Positioned(
                            top: 10,
                            left: 10,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
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
                                  SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shop_by_categoriesAllProdect.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              if (widget.shop_by_categoriesAllProdect.offer !=
                                  null)
                                Text(
                                  "EGP ${createThePrice(widget.shop_by_categoriesAllProdect.price * (100 - widget.shop_by_categoriesAllProdect.offer!) / 100)}",

                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                              if (widget.shop_by_categoriesAllProdect.offer ==
                                  null)
                                Text(
                                  "EGP ${createThePrice(widget.shop_by_categoriesAllProdect.price)}",

                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                              SizedBox(width: 15),
                              if (widget.shop_by_categoriesAllProdect.offer !=
                                  null)
                                Text(
                                  "EGP ${createThePrice(widget.shop_by_categoriesAllProdect.price)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Available in stock",
                            style: TextStyle(color: Colors.green),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            "About",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.shop_by_categoriesAllProdect.description,
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 16),
                          if (widget
                              .shop_by_categoriesAllProdect
                              .color!
                              .isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  widget.shop_by_categoriesAllProdect.color!
                                      .toList()
                                      .map((entry) {
                                        int index = widget
                                            .shop_by_categoriesAllProdect
                                            .color!
                                            .indexOf(entry);
                                        var c = entry;
                                        return buildColorOption(index, c);
                                      })
                                      .toList(),
                            ),
                          const SizedBox(height: 16),
                          const Text(
                            "Size",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            children:
                                widget.shop_by_categoriesAllProdect.size.map((
                                  size,
                                ) {
                                  bool isSelected = size == selectedSize;
                                  return GestureDetector(
                                    onTap: () {
                                      selectedSize = size;
                                      BlocProvider.of<ProductDetailsCubit>(
                                        context,
                                      ).SetSateUi();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        10,
                                        10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.orange
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        size.toString(),
                                        style: TextStyle(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Quantity",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<ProductDetailsCubit>(
                                        context,
                                      ).quantity_1_2_3();
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                  ),
                                  Text(
                                    BlocProvider.of<ProductDetailsCubit>(
                                      context,
                                    ).quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<ProductDetailsCubit>(
                                        context,
                                      ).quantity123();
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (selectedColor == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select at least one color",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (selectedSize == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select at least one size",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  order.quantity =
                                      BlocProvider.of<ProductDetailsCubit>(
                                        context,
                                      ).quantity;
                                  order.selectedColor = selectedColor;
                                  order.selectedSize = selectedSize;
                                  order.product =
                                      widget.shop_by_categoriesAllProdect;
                                  BlocProvider.of<ProductDetailsCubit>(
                                    context,
                                  ).addOrder(order);
                                }
                              },
                              child: const Text(
                                "Add to cart",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget buildColorOption(int index, int color) {
    bool isSelected = selectedColor == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: CircleAvatar(
          radius: 14,
          backgroundColor: Color(color),
          child:
              isSelected
                  ? const Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 255, 95, 95),
                    size: 16,
                  )
                  : null,
        ),
      ),
    );
  }
}
