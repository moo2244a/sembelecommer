import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor/model/modleprofile.dart';
import 'package:doctor/pages/AddressProfile.dart';
import 'package:doctor/pages/CartPart.dart';

import 'package:doctor/pages/Wishlistprofile.dart';
import 'package:doctor/pages/bottonSheet.dart';
import 'package:doctor/join/singin.dart';
import 'package:doctor/profile_cubit/profile_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iconsax/iconsax.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  _ProfileState();

  DocumentSnapshot? userdata;

  final List<Modleprofile> contient = [
    Modleprofile(
      botton: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Addressprofile()),
        );
      },
      title: "Address",
    ),
    Modleprofile(
      botton: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Wishlistprofile()),
        );
      },
      title: "Wishlist",
    ),
    Modleprofile(
      botton: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Cartprofile()),
        );
      },
      title: "Shopping Cart",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        children: [
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
              ],
            ),
          ),

          SizedBox(height: 20),
          Photo(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),

            itemCount: contient.length,
            itemBuilder: (context, i) {
              return profilecontainer(
                botton: () => contient[i].botton(context),
                title: contient[i].title,
              );
            },
          ),
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SingIn()),
              );
            },
            child: Container(
              margin: EdgeInsets.all(40),

              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: Text(
                "Sign Out",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Matangi",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class profilecontainer extends StatelessWidget {
  GestureTapCallback botton;
  String title;
  profilecontainer({super.key, required this.botton, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: botton,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(16),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Icon(Iconsax.arrow_right, size: 30, color: Colors.black),
          ],
        ),
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
        String name = capitalizeWords(nameuser ?? "Name");
        String initials = getInitials(nameuser ?? "nm");

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return BlocProvider.value(
                      value: context.read<ProfileCubit>(),
                      child: BottonSheet(),
                    );
                  },
                );
              },
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      child:
                          (imageUrl != null && imageUrl.isNotEmpty)
                              ? ClipOval(
                                child: Image.network(
                                  imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.broken_image,
                                      size: 30,
                                      color: const Color.fromARGB(
                                        255,
                                        43,
                                        43,
                                        43,
                                      ),
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Card(
                color: Colors.grey.shade200,
                child: ListTile(
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(FirebaseAuth.instance.currentUser!.email!),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
