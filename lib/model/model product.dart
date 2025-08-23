class Product {
  String name;
  String? mainCategory;
  double price;
  int? quantity;
  List size;
  List Image;
  List? color;
  int? offer;
  String description;
  List targetType; // النوع
  bool? isFavorite;

  Product({
    required this.name,
    required this.Image,
    this.isFavorite,
    this.mainCategory,

    required this.price,
    this.quantity,
    required this.size,
    this.color,
    this.offer,
    required this.description,
    required this.targetType,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': Image,
      'price': price,
      'size': size,
      'description': description,
      'targetType': targetType,
      'mainCategory': mainCategory,
      "offer": offer ?? null,
      "isFavorite": isFavorite,
      "color": color,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      Image: List<String>.from(map['image'] ?? []),
      price: (map['price'] ?? 0).toDouble(),
      size: List<String>.from(map['size'] ?? []),
      description: map['description'] ?? '',
      targetType: List<String>.from(map['targetType'] ?? []),
      mainCategory: map['mainCategory'] ?? '',
      offer: (map['offer'] ?? null),
      isFavorite: (map['isFavorite'] ?? false),
      color: map["color"],
    );
  }

  toLowerCase() {}
}
