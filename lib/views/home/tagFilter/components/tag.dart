import 'package:festivalapp/common/constants/colors.dart';
import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  String content;
  bool isSelected;
  Tag({Key? key, required this.content, required this.isSelected})
      : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    Color color = secondaryColor;
    if (widget.isSelected) {
      color = primaryColor;
    }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: (widget.isSelected)
            ? const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                color: primaryColor)
            : const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18)),
                color: secondaryColor),
        child: Center(
            child: Text(
          widget.content,
          style: Theme.of(context).textTheme.bodyText1,
        )));
  }
}
