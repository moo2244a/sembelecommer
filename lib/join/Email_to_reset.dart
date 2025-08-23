import 'package:flutter/material.dart';

class EmailToReset extends StatefulWidget {
  String senttext;
  var bottonReturn;
  late String bottonextReturn;
  EmailToReset({
    super.key,
    required this.senttext,
    required this.bottonReturn,
    required this.bottonextReturn,
  });
  @override
  State<EmailToReset> createState() => _EmailToReset();
}

class _EmailToReset extends State<EmailToReset> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
      "_____________________________________________________________________________________333333__________________",
    );
  }

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
              // الدوائر والخلفية
              Positioned(
                right: MediaQuery.of(context).size.width / 2 - 150 / 2,
                top: 190,
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("image/image41.png", fit: BoxFit.cover),
                ),
              ),
              Positioned(
                left: -140,
                top: -140,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 235, 233, 233),
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
                    color: Color.fromARGB(255, 206, 202, 202),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // المحتوى الفعلي
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 150),
                      Text(
                        widget
                            .senttext, // "We Sent you an Email to reset your password."
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: widget.bottonReturn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            225,
                            168,
                            9,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.bottonextReturn, //"Return to Login"
                          style: TextStyle(
                            color: const Color.fromARGB(255, 18, 18, 18),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
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
