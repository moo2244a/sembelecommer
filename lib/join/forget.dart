import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/join/Email_to_reset.dart';
import 'package:doctor/join/cubit/forget_cubit.dart';
import 'package:doctor/widgets/textfileldx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _Forget();
}

class _Forget extends State<Forget> {
  TextEditingController Email = TextEditingController();
  final GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetCubit(),
      child: BlocConsumer<ForgetCubit, ForgetState>(
        listener: (context, state) {
          if (state is ForgetFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errormassage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is Forgetsuss) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => EmailToReset(
                      senttext:
                          "We've sent you a password reset email.\nPlease check your inbox and reset your password.",
                      bottonReturn: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      bottonextReturn: "Return to Login",
                    ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true, // علشان يحرك الشاشة وقت الكيبورد
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
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
                      top: 50, // مكان الزر من فوق
                      left: 20, // مكان الزر من اليسار
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // وظيفة الرجوع
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 20,
                      right: 20,
                      top: 160,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,

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
                              child: TextFieldX(
                                Controller: Email,
                                obscureText: false,
                                labelText: "Email",
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "Email is empty";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: 20),
                            if (BlocProvider.of<ForgetCubit>(context).loding ==
                                true)
                              Center(child: CircularProgressIndicator()),
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                if (_formKey!.currentState!.validate()) {
                                  BlocProvider.of<ForgetCubit>(
                                    context,
                                  ).resetPasswordIfEmailExists(Email.text);
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
                                  "Continue",
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
