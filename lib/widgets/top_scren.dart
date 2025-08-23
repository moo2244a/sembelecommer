import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/pages/CartPart.dart';
import 'package:doctor/pages/profile.dart';

import 'package:doctor/profile_cubit/profile_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class TopScren extends StatefulWidget {
  const TopScren({super.key});

  @override
  State<TopScren> createState() => _TopScren();
}

class _TopScren extends State<TopScren> {
  String selectedGender = 'Men';
  final List<String> categories = ['Men', 'Women', 'Kids'];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider<ProfileCubit>(
                        create: (context) => ProfileCubit(),
                        child: const Profile(),
                      ),
                ),
              );
            },
            child: Photo(),
          ),
          SizedBox(width: 50),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(40),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGender,
                icon: Icon(Iconsax.arrow_down_1),
                items:
                    categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle()),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
              ),
            ),
          ),
          SizedBox(width: 50),

          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF9066F6), //Color(0xFF9066F6),
            child: IconButton(
              icon: Icon(
                Iconsax.bag_2,
                size: 36,

                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cartprofile()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Photo extends StatelessWidget {
  const Photo({super.key});

  String getInitials(String name) {
    List<String> parts = name.trim().split(" ");
    String initials = "";
    if (parts.isNotEmpty) initials += parts[0][0];

    if (parts.length > 1) initials += parts[1][0];
    return initials.toUpperCase();
  }

  String capitalizeWords(String name) {
    if (name.isEmpty) return "";
    return name
        .split(" ")
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : "",
        )
        .join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("user")
              .doc(FirebaseAuth.instance.currentUser!.email!)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No user data"));
        }

        var data = snapshot.data!;
        String? imageUrl = data["image"];
        String? nameuser = data["name"];

        String initials = getInitials(nameuser ?? "nm");

        return Center(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            child:
                (imageUrl != null && imageUrl.isNotEmpty)
                    ? ClipOval(
                      child: Image.network(
                        imageUrl,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "image/user.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    )
                    : Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 20, 20, 20),
                      ),
                    ),
          ),
        );
      },
    );
  }
}
