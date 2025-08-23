import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:doctor/model/modelusers.dart';
import 'package:doctor/join/Email_to_reset.dart';
import 'package:doctor/pages/homepage.dart';
import 'package:doctor/join/singin.dart';
import 'package:doctor/join/signup_cubit/singup_cubit.dart';
import 'package:doctor/join/signup_cubit/singup_state.dart';
import 'package:doctor/widgets/checkpassword.dart';
import 'package:doctor/widgets/textfileldx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  TextEditingController Confirm_your_password = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Full_name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  var isloding = false;
  bool _dialogShown = false;

  SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (context) => SignUpCubit(SignUpInitialState()),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) async {
          if (state is SignUpLoading) {
            isloding = true;
          } else if (state is SignUpSuccess) {
            final user = FirebaseAuth.instance.currentUser;
            await user?.reload();

            if (user != null && user.emailVerified) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EmailToReset(
                        senttext:
                            " We've sent you a verification email.\nPlease check your inbox and verify your email.",
                        bottonReturn: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SingIn(
                                    fromSignUp: true,
                                    userModel: UserModel(
                                      id: Email.text.trim(),
                                      name: Full_name.text.trim(),
                                      email: Email.text.trim(),
                                      phone: '',
                                      address: '',
                                      pass: password.text,
                                    ),
                                  ),
                            ),
                          );
                        },
                        bottonextReturn: "Return to Login",
                      ),
                ),
              );
            }
          } else if (state is SignUpFailure) {
            isloding = false;
            if (!_dialogShown) {
              _dialogShown = true;
              Future.delayed(Duration.zero, () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: "ERROR",
                  desc: state.errMessage,
                  btnOkOnPress: () {
                    _dialogShown = false;
                  },
                ).show();
              });
            }
          } else if (state is ScureText) {}
        },
        builder: (context, state) {
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
                      top: 20,
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
                      top: 100,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,

                        child: ListView(
                          children: [
                            Text(
                              "Sign Up",
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
                            SizedBox(height: 40),

                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFieldX(
                                    Controller: Full_name,
                                    obscureText: false,
                                    labelText: "Full name",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Full name';
                                      }

                                      if (value.length > 20) {
                                        return 'Password must be at least 20 characters';
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  TextFieldX(
                                    Controller: Email,

                                    obscureText: false,
                                    labelText: "Email",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }

                                      final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );

                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }

                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 20),
                                  TextFieldX(
                                    Controller: password,
                                    onChanged: (value) {
                                      BlocProvider.of<SignUpCubit>(
                                        context,
                                      ).CorectPass(value);
                                    },
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<SignUpCubit>(
                                          context,
                                        ).Obscure();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Icon(
                                          BlocProvider.of<SignUpCubit>(
                                                context,
                                              ).ObscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                    obscureText:
                                        BlocProvider.of<SignUpCubit>(
                                          context,
                                        ).ObscureText,
                                    labelText: "Password",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length <= 20) {
                                        return 'Password must be at least 20 characters';
                                      }

                                      final passwordRegex = RegExp(
                                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$',
                                      );

                                      if (!passwordRegex.hasMatch(value)) {
                                        return 'Password must include (AB)(ab)(12)(@#)';
                                      }

                                      if (value != Confirm_your_password.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 20),
                                  TextFieldX(
                                    Controller: Confirm_your_password,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<SignUpCubit>(
                                          context,
                                        ).Obscure();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Icon(
                                          BlocProvider.of<SignUpCubit>(
                                                context,
                                              ).ObscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                      ),
                                    ),
                                    obscureText:
                                        BlocProvider.of<SignUpCubit>(
                                          context,
                                        ).ObscureText,
                                    labelText: "Confirm your password",
                                    validator: (value) {},
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),
                            RowPassword(
                              stati: BlocProvider.of<SignUpCubit>(context).A_Z,
                              titel: "At least one uppercase letter (A-Z)",
                            ),

                            RowPassword(
                              stati: BlocProvider.of<SignUpCubit>(context).a_z,
                              titel: "At least one lowercase letter (a-z)",
                            ),
                            RowPassword(
                              stati:
                                  BlocProvider.of<SignUpCubit>(context).diget,
                              titel: "At least one number (0-9)",
                            ),
                            RowPassword(
                              stati:
                                  BlocProvider.of<SignUpCubit>(
                                    context,
                                  ).keywords,
                              titel:
                                  "At least one special character (!@#\$%^&*)",
                            ),

                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<SignUpCubit>(
                                    context,
                                  ).signUpUser(
                                    email: Email.text.trim(),
                                    password: password.text,
                                    name: Full_name.text.trim(),
                                  );
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
                                  "SIGN UP",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Matangi",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SingIn(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                      decorationColor: Colors.deepOrange,
                                    ),
                                  ),
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
        },
      ),
    );
  }
}
