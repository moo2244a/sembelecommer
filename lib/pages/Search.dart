import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/model%20product.dart';
import 'package:doctor/pages/ProductDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String? _Search;
  TextEditingController? controller = TextEditingController();
  List<Product> allProductNames = [];
  @override
  void initState() {
    super.initState();
    fetchAllProductNames();
    getphoto();
  }

  List<String> data = [];

  Future<List<Product>> fetchAllProductNames() async {
    final firestore = FirebaseFirestore.instance;
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    final List<String> categories = [
      'Hoodies',
      'Shorts',
      'Shoes',
      'Bags',
      'Accessories',
    ];

    try {
      for (String category in categories) {
        QuerySnapshot snapshot = await firestore.collection(category).get();

        for (var doc in snapshot.docs) {
          Product product = Product.fromMap(doc.data() as Map<String, dynamic>);
          data.add(product.name);
          allProductNames.add(product);
        }
      }

      return allProductNames;
    } catch (e) {
      print("Error fetching product names: $e");
      return [];
    }
  }

  getphoto() {
    int i = 0;
    for (; i < Shop_by_Categories.length;) {
      i++;
      Shop_by_Categories_Photo.add("image/Ellipse $i.png");
    }
  }

  final List<String> Shop_by_Categories = [
    'Hoodies',

    'Shorts',
    'Shoes',
    'Bags',

    'Accessories',
  ];
  final List<String> Shop_by_Categories_Photo = [];

  List<String> results = [];

  void updateSearch(String query) {
    setState(() {
      results =
          data
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
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
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          _Search = null;
                        } else {
                          _Search = value;
                        }

                        updateSearch(value);
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                        prefixIcon: Icon(
                          Iconsax.search_normal_1,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            controller!.clear();
                            _Search = controller!.text;
                            if (_Search == "") {
                              _Search = null;
                            }

                            setState(() {});
                          },
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          (_Search == null)
              ? Container(
                margin: EdgeInsets.all(17),
                alignment: Alignment.topLeft,
                child: Text(
                  "Shop by Categories",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : SizedBox(),
          (_Search == null)
              ? Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: Shop_by_Categories_Photo.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.fromLTRB(15, 4, 15, 4),

                        child: ListTile(
                          leading: Image.asset(Shop_by_Categories_Photo[index]),
                          title: Text(Shop_by_Categories[index]),
                        ),
                      ),
                    );
                  },
                ),
              )
              : (results.isNotEmpty)
              ? Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = allProductNames.firstWhere(
                      (p) => p.name == results[index],
                      orElse:
                          () =>
                              allProductNames[0], // fallback in case not found
                    );

                    return searchwidgets(product: product);
                  },
                ),
              )
              : Expanded(
                child: ListView(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 150, 0, 10),
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              "image/search 1.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Center(
                            child: Text(
                              "Sorry, we couldn't find any matching result for your Search.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBBC05),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              margin: EdgeInsets.all(5),
                              child: Text(
                                "Explore Categories",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}

class searchwidgets extends StatelessWidget {
  const searchwidgets({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        color: Colors.grey.shade200,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.Image[0], // أول صورة للمنتج
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50, color: Colors.grey);
              },
            ),
          ),
          title: Text(
            product.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle:
              product.offer != null
                  ? Row(
                    children: [
                      Text(
                        "EGP ${(product.price * (100 - product.offer!) / 100).toInt()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "EGP ${product.price.toInt()}",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                  : Text("EGP ${product.price.toInt()}"),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProductDetailsPage(
                      shop_by_categoriesAllProdect: product,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
