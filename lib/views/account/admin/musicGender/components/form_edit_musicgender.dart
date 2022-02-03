import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:flutter/material.dart';

class FormEditMusicGender extends StatefulWidget {
  final MusicGender musicGender;
  final ValueChanged<MusicGender> musicGenderFunction;
  final ValueChanged<bool> changesFunction;
  FormEditMusicGender({
    required this.musicGender,
    required this.musicGenderFunction,
    required this.changesFunction,
    Key? key,
  }) : super(key: key);

  @override
  _FormEditMusicGenderState createState() => _FormEditMusicGenderState();
}

class _FormEditMusicGenderState extends State<FormEditMusicGender> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController labelController = TextEditingController();

  @override
  void initState() {
    labelController.text = widget.musicGender.label;
    super.initState();
  }

  @override
  void dispose() {
    labelController.dispose();
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
                        controller: labelController,
                        cursorColor: primaryColor,
                        style: TextStyle(
                          color: const Color(0xff3D5382),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (String value) {
                          if (value != widget.musicGender.label) {
                            widget.musicGender.label = labelController.text;
                            setState(() {
                              widget.changesFunction(true);
                              widget.musicGenderFunction(widget.musicGender);
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
