import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/pages/Search.dart';
import 'package:doctor/model/model%20product.dart';
import 'package:doctor/pages/addProduct.dart';

import 'package:doctor/widgets/top_scren.dart';
import 'package:doctor/widgets/widget_prodect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Tellusaboutyourself();
}

class _Tellusaboutyourself extends State<Homepage> {
  final SearchPageState _searchPageKey = SearchPageState();
  String PageStateCA = "Hoodies";
  Future<List<Product>>? productsFuture;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts(PageStateCA);
    _searchPageKey.getphoto(); //دي صورة الفئات
  }

  Future<List<Product>> fetchProducts(String name) async {
    try {
      QuerySnapshot snapshot = await firestore.collection(name).get();
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  void changeCategory(String category) {
    setState(() {
      PageStateCA = category;
      productsFuture = fetchProducts(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 40),
          TopScren(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(13.8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Iconsax.search_normal_1,
                    size: 22,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Search",
                    style: TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: _searchPageKey.Shop_by_Categories_Photo.length,
              itemBuilder: (context, index) {
                final category = _searchPageKey.Shop_by_Categories[index];
                return GestureDetector(
                  onTap: () => changeCategory(category),
                  child: Container(
                    margin: EdgeInsets.all(3),
                    height: 100,
                    width: 80,

                    decoration: BoxDecoration(
                      color:
                          (_searchPageKey.Shop_by_Categories[index] ==
                                  PageStateCA)
                              ? const Color.fromARGB(255, 3, 3, 3)
                              : const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 65,
                          width: 65,

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              _searchPageKey.Shop_by_Categories_Photo[index],
                            ),
                          ),
                        ),
                        SizedBox(height: 3),

                        Container(
                          child: Text(
                            _searchPageKey.Shop_by_Categories[index],
                            style: TextStyle(
                              color:
                                  (_searchPageKey.Shop_by_Categories[index] ==
                                          PageStateCA)
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : Color.fromARGB(255, 3, 3, 3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("حدث خطأ في تحميل المنتجات"));
                }
                final products = snapshot.data ?? [];
                return GridView.builder(
                  itemCount: products.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AddProductPage(pageState: PageStateCA),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.green.shade100,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 50,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return WidgetProdect(
                        index: index - 1,
                        Shop_by_CategoriesAllProdect: products,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
