import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormArtist extends StatefulWidget {
  final Artist artist;
  final ValueChanged<Artist> artistFunction;
  final ValueChanged<bool> changesFunction;
  List<MusicGender> listMusicGenders;
  List<Event> listEvents;
  List<S2Choice<int>> selectedMusicGendersWidgets;
  List<int> selectedMusicGendersId;
  List<S2Choice<int>> choiceMusicGenders;
  List<S2Choice<int>> selectedEventsWidgets;
  List<int> selectedEventsId;
  List<S2Choice<int>> choiceEvents;
  FormArtist({
    required this.artist,
    required this.artistFunction,
    required this.changesFunction,
    required this.listMusicGenders,
    required this.listEvents,
    required this.selectedMusicGendersWidgets,
    required this.selectedMusicGendersId,
    required this.choiceMusicGenders,
    required this.selectedEventsWidgets,
    required this.selectedEventsId,
    required this.choiceEvents,
    Key? key,
  }) : super(key: key);

  @override
  _FormArtistState createState() => _FormArtistState();
}

class _FormArtistState extends State<FormArtist> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  XFile? picture;

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

  Future<void> pickImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        picture = xFile;
        await picture!.readAsBytes().then((bytes) {
          setState(() {
            widget.artist.picture = base64Encode(bytes);
            widget.artistFunction(widget.artist);
          });
        });
      }
    });
  }

  void _updateArtistMusicGenders() {
    bool added = false;
    List<MusicGender> tempMusicGenders = [];
    widget.selectedMusicGendersWidgets.forEach((musicGenderWidget) {
      widget.listMusicGenders.forEach((musicGender) {
        if (musicGenderWidget.value == musicGender.id) {
          added = true;
          tempMusicGenders.add(musicGender);
        }
      });
    });
    //Quelque chose à été ajouté ou retiré : liste vide == retiré (on ne gère pas le cas ou rien n'est selectionne ni avant ni après)
    if (added || tempMusicGenders.isEmpty) {
      widget.artist.musicGenders = tempMusicGenders;
      widget.changesFunction(true);
      widget.artistFunction(widget.artist);
    }
    print(widget.artist.musicGenders!.length);
  }

  void _updateArtistEvents() {
    bool added = false;
    List<Event> tempEvents = [];
    print(widget.selectedEventsWidgets.length);
    widget.selectedEventsWidgets.forEach((eventWidget) {
      widget.listEvents.forEach((event) {
        if (eventWidget.value == event.id) {
          added = true;
          print(event.name);
          tempEvents.add(event);
        }
      });
    });
    //Quelque chose à été ajouté ou retiré : liste vide == retiré (on ne gère pas le cas ou rien n'est selectionne ni avant ni après)
    if (added || tempEvents.isEmpty) {
      widget.artist.events = tempEvents;
      widget.changesFunction(true);
      widget.artistFunction(widget.artist);
    }
    print(tempEvents.length);
    print(widget.artist.events!.length);
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
                    SizedBox(height: 15),
                    Container(
                      decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: SmartSelect<int>.multiple(
                        title: 'Genre musicaux',
                        placeholder: 'Aucun choix',
                        selectedValue: widget.selectedMusicGendersId,
                        choiceItems: widget.choiceMusicGenders,
                        onChange: (multiSelected) => setState(() {
                          if (multiSelected != null) {
                            if (multiSelected.choice != null) {
                              widget.selectedMusicGendersWidgets =
                                  multiSelected.choice!;
                            } else {
                              widget.selectedMusicGendersWidgets = [];
                            }
                          }
                          _updateArtistMusicGenders();
                        }),
                        choiceType: S2ChoiceType.cards,
                        groupConfig: S2GroupConfig(
                            headerStyle: S2GroupHeaderStyle(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white))),
                        groupHeaderStyle: S2GroupHeaderStyle(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white)),
                        choiceStyle: S2ChoiceStyle(
                            titleStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white)),
                        tileBuilder: (context, state) {
                          return S2Tile.fromState(
                            state,
                            isTwoLine: true,
                            leading: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Center(
                                child: Icon(
                                  Icons.music_note,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: SmartSelect<int>.multiple(
                        title: 'Evènements',
                        placeholder: 'Aucun choix',
                        selectedValue: widget.selectedEventsId,
                        choiceItems: widget.choiceEvents,
                        onChange: (multiSelected) => setState(() {
                          if (multiSelected != null) {
                            if (multiSelected.choice != null) {
                              widget.selectedEventsWidgets =
                                  multiSelected.choice!;
                            } else {
                              widget.selectedEventsWidgets = [];
                            }
                          }
                          _updateArtistEvents();
                        }),
                        choiceType: S2ChoiceType.cards,
                        groupConfig: S2GroupConfig(
                            headerStyle: S2GroupHeaderStyle(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white))),
                        groupHeaderStyle: S2GroupHeaderStyle(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white)),
                        choiceStyle: S2ChoiceStyle(
                            titleStyle: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white)),
                        tileBuilder: (context, state) {
                          return S2Tile.fromState(
                            state,
                            isTwoLine: true,
                            leading: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Center(
                                child: Icon(
                                  Icons.disc_full,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          );
                        },
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
