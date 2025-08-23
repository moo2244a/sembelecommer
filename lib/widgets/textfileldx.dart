import 'package:flutter/material.dart';

class TextFieldX extends StatelessWidget {
  bool obscureText = false;

  Widget? suffixIcon;
  Widget? prefixIcon;
  String labelText;
  final validator;
  final onChanged;

  TextEditingController Controller = TextEditingController();
  TextFieldX({
    super.key,
    this.suffixIcon,
    required this.obscureText,
    required this.labelText,
    required this.validator,
    required this.Controller,
    this.prefixIcon,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      controller: Controller,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 51, 53, 48)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 51, 53, 48)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 51, 53, 48)),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 247, 246, 246),
      ),
    );
  }
}
