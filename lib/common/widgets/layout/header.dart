import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final String title;
  final String content;
  const Header({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.start,
          ),
          Text(
            widget.content,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
