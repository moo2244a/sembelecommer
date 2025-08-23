import 'package:doctor/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottonSheet extends StatelessWidget {
  const BottonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Column(
                children: [
                  IconButton(
                    iconSize: 70,
                    onPressed: () async {
                      Navigator.pop(context);
                      await BlocProvider.of<ProfileCubit>(
                        context,
                      ).getimagecamera();
                    },

                    icon: ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                      child: Icon(
                        (Icons.camera_alt),

                        color: Colors.white, // ضروري يكون فيه لون أساسي
                      ),
                    ),
                  ),
                  Text("Add With Camera"),
                ],
              ),

              Column(
                children: [
                  IconButton(
                    iconSize: 60,
                    onPressed: () async {
                      Navigator.pop(context);
                      await BlocProvider.of<ProfileCubit>(
                        context,
                      ).getimagegallery();
                    },

                    icon: ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                      child: Icon(
                        (Icons.photo_library),

                        color: Colors.white, // ضروري يكون فيه لون أساسي
                      ),
                    ),
                  ),
                  Text("Add With photo"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
