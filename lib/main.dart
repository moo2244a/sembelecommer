import 'package:doctor/pages/homepage.dart';
import 'package:doctor/join/singin.dart';
import 'package:doctor/pages/profile/profile_cubit/profile_cubit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileCubit()),
        // لو عندك Cubits تانية
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Doctor App",
      home: CheckAuth(), // هنا هنتأكد من حالة المستخدم
    );
  }
}

class CheckAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return SingIn();
        }

        final user = snapshot.data;

        if (user != null && !user.emailVerified) {
          return SingIn(); // فيه يوزر لكن الإيميل مش متحقق
        }

        return Homepage(); // اليوزر موجود وإيميله متحقق
      },
    );
  }
}
