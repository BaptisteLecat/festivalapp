import 'package:flutter/material.dart';
import 'inputDecoration/default_decoration.dart';

class InputPassword extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  bool hidePassword;
  InputPassword(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.hidePassword})
      : super(key: key);

  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      obscureText: widget.hidePassword,
      cursorColor: const Color(0xff3D5382),
      validator: (password) {
        if (password != null) {
          if (password.length < 2) {
            return "Minimum 2 caractères.";
          }
        }
      },
      style: TextStyle(
        color: const Color(0x993D5382),
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      decoration: DefaultDecoration.inputDecoration(hintText: widget.hintText),
    );
  }
}
