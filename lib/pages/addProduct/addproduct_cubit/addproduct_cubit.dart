import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/model%20product.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

part 'addproduct_state.dart';

class AddproductCubit extends Cubit<AddproductState> {
  AddproductCubit() : super(AddproductInitial());
  String? selectedMainCategory;
  Product user = Product(
    name: "",
    Image: [],
    price: 1,
    size: [],
    description: "",
    targetType: [],
    mainCategory: '',
    offer: null,
    color: [],
  );

  addprodutModel({
    required String name,
    required String price,
    required String description,
    required String mainCategory,
    required List<String> subCategories,
    required List<String> sizes,
    required List<String> images,
    required Set<Color> color,

    required int? discount,
  }) {
    user.name = name;
    user.Image = images;
    user.price = double.parse(price);
    user.description = description;
    user.mainCategory = mainCategory;
    user.targetType = subCategories;
    user.size = sizes;
    user.offer = discount ?? null;
    user.isFavorite = false;
    user.color = color.map((c) => c.value).toList();
    if (isClosed) return;

    logingaddprodutModel = false;
    emit(Uploadtofirebasaloding());
    try {
      FirebaseFirestore.instance
          .collection("$mainCategory")
          .doc(name)
          .set(user.toMap(), SetOptions(merge: true));
      loginguploadImageToImgBB = true;
      if (!isClosed) emit(UploadtofirebasalSuss());
    } catch (e) {
      loginguploadImageToImgBB = true;
      if (!isClosed) emit(UploadtofirebasalFile());
    }
  }

  List<Product> allProductNames = [];
  List<String> data = [];
  Future<void> fetchAllProductNames() async {
    final firestore = FirebaseFirestore.instance;

    final List<String> categories = [
      'Hoodies',
      'Shorts',
      'Shoes',
      'Bags',
      'Accessories',
    ];
    if (isClosed) return;
    try {
      for (String category in categories) {
        QuerySnapshot snapshot = await firestore.collection(category).get();

        for (var doc in snapshot.docs) {
          Product product = Product.fromMap(doc.data() as Map<String, dynamic>);
          data.add(product.name);
        }
      }
      if (!isClosed) {
        emit(fetchAllProductNamesSuss());
      }
    } catch (e) {
      if (!isClosed) {
        emit(AfetchAllProductNamesFile());
      }
    }
  }

  getselectedMainCategory(vale) {
    selectedMainCategory = vale;
    fetchAllProductNames();
  }

  bool? loginguploadImageToImgBB;
  bool? logingaddprodutModel;
  List<String> photo = [];
  String? imageUrl;
  String? selectedSubCategory;
  clearImage(int index) {
    photo.removeAt(index);
    emit(ClearImage());
  }

  Future<void> selectedMainCategor(String? value) async {
    selectedMainCategory = value;
    selectedSubCategory = null;
    emit(ChooseCategory());
  }

  Future<void> selectedSubCategor(String? value) async {
    selectedSubCategory = value;
    emit(ChooseCategory());
  }

  Future<void> getimagegallery() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      await uploadImageToImgBB(File(pickedFile.path));
    }
  }

  Future<void> uploadImageToImgBB(File imageFile) async {
    if (isClosed) return;

    loginguploadImageToImgBB = false;
    emit(AddproductPhotoloding());

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          "https://api.imgbb.com/1/upload?key=8d215e2df789b951b9880b0e54997536",
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );

      var response = await request.send();

      if (isClosed) return;

      if (response.statusCode == 200) {
        var resBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(resBody);

        String imageUr = jsonData["data"]["url"];
        imageUrl = imageUr;
        photo.add(imageUrl!);
        loginguploadImageToImgBB = true;

        if (!isClosed) emit(AddproductPhotoSuss());
      } else {
        loginguploadImageToImgBB = true;
        if (!isClosed) emit(AddproductPhotoFile());
      }
    } catch (e) {
      loginguploadImageToImgBB = true;
      if (!isClosed) emit(AddproductPhotoFile());
    }
  }

  Color selectedColor = Colors.blue;
  Set<Color> seleColor = {};
  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "Pick a Color",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ColorPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      selectedColor = color;
                      emit(ToColor());
                    },
                    showLabel: true,
                    pickerAreaHeightPercent: 0.7,
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 205, 200, 200),
                ),
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Add Color"),
                onPressed: () {
                  seleColor.add(selectedColor);
                  Navigator.of(context).pop();
                  emit(ToColorlist());
                },
              ),
            ],
          ),
    );
  }
}
