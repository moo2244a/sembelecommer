import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  DocumentSnapshot? userdata;

  ProfileCubit() : super(ProfileInitial());

  Future<void> getimagegallery() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      await uploadImageToImgBB(File(pickedFile.path));
    }
  }

  Future<void> getimagecamera() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      await uploadImageToImgBB(File(pickedFile.path));
    }
  }

  Future<void> uploadImageToImgBB(File imageFile) async {
    emit(ProfileLoding());

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

      if (response.statusCode == 200) {
        var resBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(resBody);

        String imageUrl = jsonData["data"]["url"];

        await FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .set({"image": imageUrl}, SetOptions(merge: true));

        emit(ProfileImageUpdated(imageUrl));
      } else {
        emit(ProfileFileImageUpdated());
      }
    } catch (e) {
      emit(ProfileFileImageUpdated());
    }
  }
}
