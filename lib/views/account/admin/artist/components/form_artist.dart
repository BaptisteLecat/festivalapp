import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:flutter/material.dart';

class FormArtist extends StatefulWidget {
  final Artist artist;
  final ValueChanged<Artist> artistFunction;
  final ValueChanged<bool> changesFunction;
  FormArtist({
    required this.artist,
    required this.artistFunction,
    required this.changesFunction,
    Key? key,
  }) : super(key: key);

  @override
  _FormArtistState createState() => _FormArtistState();
}

class _FormArtistState extends State<FormArtist> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.artist.name;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        "Label",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        controller: nameController,
                        cursorColor: primaryColor,
                        style: TextStyle(
                          color: const Color(0xff3D5382),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (String value) {
                          if (value != widget.artist.name) {
                            widget.artist.name = nameController.text;
                            setState(() {
                              widget.changesFunction(true);
                              widget.artistFunction(widget.artist);
                            });
                          }
                        },
                        decoration: AdvancedDecoration.inputDecoration(
                            hintText: 'Label'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
