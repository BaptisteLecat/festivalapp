import 'package:flutter/material.dart';

class HidePasswordButton extends StatefulWidget {
  ValueChanged<bool> callback;
  final Color color;
  HidePasswordButton(
      {Key? key, required this.callback, this.color = const Color(0xff3D5382)})
      : super(key: key);

  @override
  _HidePasswordButtonState createState() => _HidePasswordButtonState();
}

class _HidePasswordButtonState extends State<HidePasswordButton> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        child: TextButton(
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(widget.color.withOpacity(0.1)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(
                        color: widget.color,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8.0)))),
            onPressed: () {
              widget.callback(!this.hidePassword);
              setState(() {
                hidePassword = !this.hidePassword;
              });
            },
            child: hidePassword
                ? Image.asset("assets/icons/hide.png")
                : Image.asset("assets/icons/show.png")));
  }
}
