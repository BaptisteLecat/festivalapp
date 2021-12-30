import 'dart:async';
import 'package:festivalapp/common/widgets/inputs/searchBar/search_bar.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/views/home/carousel/carousel.dart';
import 'package:festivalapp/views/home/tagFilter/tag_filter.dart';
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
  MusicGender? selectedMusicGender;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateSelectedMusicGender(MusicGender musicGender) {
    setState(() {
      this.selectedMusicGender = musicGender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
            flex: 1,
            child: SizedBox(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(
                              flex: 2,
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: SearchBar())),
                          Flexible(
                              flex: 2,
                              child: TagFilter(
                                updateMusicGender:
                                    this._updateSelectedMusicGender,
                              )),
                        ])))),
        Flexible(
          flex: 3,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Text(
                        "Festivals de musique",
                        style: Theme.of(context).textTheme.headline1,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Carousel(
                    musicGender: selectedMusicGender,
                  ))
            ],
          ),
        ),
      ],
    ));
  }
}
