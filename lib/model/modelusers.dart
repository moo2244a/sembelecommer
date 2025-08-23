class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String pass;

  final String address;
  final List orders; // لو حابب تخزن طلباته داخل نفس الموديل

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.pass,

    required this.phone,
    required this.address,
    this.orders = const [],
  });
}
