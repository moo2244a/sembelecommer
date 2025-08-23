import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/join/forget.dart';
import 'package:doctor/join/login_cubit/login_cubit.dart';

import 'package:doctor/model/modelusers.dart';
import 'package:doctor/join/Email_to_reset.dart';
import 'package:doctor/pages/homepage.dart';
import 'package:doctor/join/signup.dart';

import 'package:doctor/widgets/textfileldx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingIn extends StatelessWidget {
  final bool fromSignUp;
  final UserModel? userModel;

  const SingIn({super.key, this.fromSignUp = false, this.userModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(), // ✅ مرة واحدة بس
      child: _SingIn(fromSignUp: fromSignUp, userModel: userModel),
    );
  }
}

class _SingIn extends StatefulWidget {
  final bool fromSignUp;
  final UserModel? userModel;

  const _SingIn({required this.fromSignUp, this.userModel});

  @override
  State<_SingIn> createState() => __SingInState();
}

class __SingInState extends State<_SingIn> {
  bool isloding = false;

  __SingInState();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                right: 10,
                top: 50,
                child: Container(
                  decoration: BoxDecoration(),
                  width: 250,
                  height: 300,
                  child: Image.asset("image/Flux.png", fit: BoxFit.cover),
                ),
              ),
              Positioned(
                left: -140,
                top: -140,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 233, 233),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -110,
                top: -110,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 206, 202, 202),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,

                top: 125,
                child: SizedBox(
                  height: 600,
                  child: ListView(
                    children: [
                      Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          fontFamily: "Matangi",
                          shadows: [
                            BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(1, 3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      BlocProvider<LoginCubit>(
                        create: (context) => LoginCubit(),
                        child: MyWidget(
                          UserMode: widget.userModel,
                          fromSignUp: widget.fromSignUp,
                        ),
                      ),
                      SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an acount?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            child: Text(
                              " Sign up",
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.double,
                                decorationColor: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: const Color.fromARGB(255, 206, 202, 202),
                            ),
                          ),
                          Text(
                            "  Sign In with  ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              color: const Color.fromARGB(255, 206, 202, 202),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.facebook,
                              size: 50,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            onPressed: () {
                              print("Facebook icon pressed");
                            },
                          ),
                          SizedBox(height: 15),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.google,
                              size: 50,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                            onPressed: () {
                              print(" google icon pressed");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  bool fromSignUp;
  UserModel? UserMode;

  MyWidget({super.key, this.fromSignUp = false, this.UserMode});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void initState() {
    super.initState();
    if (widget.fromSignUp && widget.UserMode != null) {
      Email.text = widget.UserMode!.email;
      password.text = widget.UserMode!.pass;
    }
    print(
      "-------------------------------------------------------------------------${widget.UserMode}",
    );
    print(
      "-------------------------------------------------------------------------${widget.fromSignUp}",
    );
    isloding = false;
  }

  _MyWidgetState();
  TextEditingController password = TextEditingController();
  TextEditingController Email = TextEditingController();
  bool isloding = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginLoding) {
          isloding = true;
        } else if (state is LoginSuccessful) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.reload();
            if (user.emailVerified) {
              setState(() => isloding = false);
              FirebaseFirestore.instance.collection("user").doc(Email.text).set(
                {"Email": Email.text, "emailVerified": true},
                SetOptions(merge: true),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            } else {
              setState(() => isloding = false);
              if (widget.UserMode == null && widget.fromSignUp == false) {
                await user.sendEmailVerification();
                widget.fromSignUp = true;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EmailToReset(
                        senttext:
                            "We've sent you a verification email.\nPlease check your inbox and verify your email.",
                        bottonReturn: () => Navigator.pop(context),
                        bottonextReturn: "Return to Login",
                      ),
                ),
              );
            }
          } else {
            setState(() => isloding = false);
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: "ERROR",
              desc: "User not found. Please try logging in again.",
              btnOkOnPress: () {},
            ).show();
          }
        } else if (state is LoginFailure) {
          isloding = false;
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: "ERROR",
            desc: state.errorMessage,
            btnOkOnPress: () {},
          ).show();
        } else if (state is LoginInitial) {}
      },
      builder: (context, state) {
        return Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldX(
                    Controller: Email,

                    obscureText: false,
                    labelText: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  TextFieldX(
                    Controller: password,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        print("Forgot password clicked");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Forget()),
                            );
                          },
                          child: Text(
                            "Forget?",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.double,
                              decorationColor: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    obscureText: false,
                    labelText: "Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      if (value.toString().length < 11) {
                        return " Password must be at least 11 characters long.";
                      }
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            isloding ? Center(child: CircularProgressIndicator()) : SizedBox(),
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<LoginCubit>(
                    context,
                  ).login(Email.text.trim(), password.text.trim());
                }
              },
              child: Container(
                margin: EdgeInsets.all(7),

                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Text(
                  "LOGIN",
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
        );
      },
    );
  }
}
