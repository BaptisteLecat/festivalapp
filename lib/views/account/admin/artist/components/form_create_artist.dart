import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_select/awesome_select.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormCreateArtist extends StatefulWidget {
  final ValueChanged<Artist> artistFunction;
  final ValueChanged<bool> completeFunction;
  List<MusicGender> listMusicGenders;
  List<Event> listEvents;
  List<S2Choice<int>> selectedMusicGendersWidgets;
  List<int> selectedMusicGendersId;
  List<S2Choice<int>> choiceMusicGenders;
  List<S2Choice<int>> selectedEventsWidgets;
  List<int> selectedEventsId;
  List<S2Choice<int>> choiceEvents;
  FormCreateArtist({
    required this.artistFunction,
    required this.completeFunction,
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
  _FormCreateArtistState createState() => _FormCreateArtistState();
}

class _FormCreateArtistState extends State<FormCreateArtist> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  XFile? picture;
  String? artistPicture;
  List<MusicGender>? artistListMusicGenders;
  List<Event>? artistListEvents;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  bool _formIsComplete() {
    bool somethingWrong = false;

    if (_formKey.currentState!.validate()) {
      if (nameController.text == "" && nameController.text == null) {
        somethingWrong = true;
      }

      if (artistListEvents == null ||
          artistListMusicGenders == null ||
          artistPicture == null) {
        somethingWrong = true;
      }
    }

    if (somethingWrong == false) {
      setState(() {
        widget.completeFunction(true);
        widget.artistFunction(_hydrateObject());
      });
    }

    return (somethingWrong) ? false : true;
  }

  Artist _hydrateObject() => Artist(
        iri: "",
        id: 0,
        name: nameController.text,
        musicGenders: artistListMusicGenders,
        events: artistListEvents,
        picture: artistPicture,
      );

  Future<void> pickImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        picture = xFile;
        await picture!.readAsBytes().then((bytes) {
          setState(() {
            artistPicture = base64Encode(bytes);
            _formIsComplete();
          });
        });
      }
    });
  }

  Uint8List getPictureEncoded() {
    if (picture != null) {
      return const Base64Decoder().convert(artistPicture!);
    } else {
      throw Exception("Aucune image disponible");
    }
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
      artistListMusicGenders = tempMusicGenders;
      _formIsComplete();
    }
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
      artistListEvents = tempEvents;
    }
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
                        "Nom",
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
                          _formIsComplete();
                        },
                        decoration:
                            AdvancedDecoration.inputDecoration(hintText: 'Nom'),
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
                    SizedBox(
                      height: 15,
                    ),
                    AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: (picture == null && artistPicture == null)
                              ? Container(
                                  color: secondaryColor,
                                  child: Center(
                                    child: InkWell(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.insert_photo),
                                          Text("Choisir une image",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ],
                                      ),
                                      onTap: () async {
                                        await pickImage();
                                      },
                                    ),
                                  ),
                                )
                              : Container(
                                  color: secondaryColor,
                                  child: Stack(fit: StackFit.expand, children: [
                                    (picture != null)
                                        ? Image.file(File(picture!.path))
                                        : Image.memory(
                                            getPictureEncoded(),
                                          ),
                                    Center(
                                      child: InkWell(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.insert_photo),
                                            Text("Choisir une image",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.white)),
                                          ],
                                        ),
                                        onTap: () async {
                                          await pickImage();
                                        },
                                      ),
                                    ),
                                  ])),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
