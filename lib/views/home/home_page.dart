import 'dart:async';
import 'package:festivalapp/common/widgets/inputs/searchBar/search_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  bool fromAuth;
  HomePage({Key? key, this.fromAuth = false}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showLoader = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Discussion"),
        ),
        body: Column(
          children: [SearchBar()],
        ));
  }
}
