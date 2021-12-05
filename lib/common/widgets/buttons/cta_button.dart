import 'package:flutter/material.dart';

class CTAButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final Text content;
  final Color backgroundColor;
  const CTAButton({
    Key? key,
    required this.onPressed,
    required this.content,
    this.backgroundColor = const Color(0xffFDAB53),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 36, vertical: 6)),
            backgroundColor: MaterialStateProperty.all(this.backgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        onPressed: this.onPressed,
        child: this.content);
  }
}
