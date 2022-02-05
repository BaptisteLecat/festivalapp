import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_select/awesome_select.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FormEditEvent extends StatefulWidget {
  final Event event;
  final ValueChanged<Event> eventFunction;
  final ValueChanged<bool> changesFunction;
  List<MusicGender> listMusicGenders;
  List<Artist> listArtists;
  List<S2Choice<int>> selectedMusicGendersWidgets;
  List<int> selectedMusicGendersId;
  List<S2Choice<int>> choiceMusicGenders;
  List<S2Choice<int>> selectedArtistsWidgets;
  List<int> selectedArtistsId;
  List<S2Choice<int>> choiceArtists;
  FormEditEvent({
    required this.event,
    required this.eventFunction,
    required this.changesFunction,
    required this.listMusicGenders,
    required this.listArtists,
    required this.selectedMusicGendersWidgets,
    required this.selectedMusicGendersId,
    required this.choiceMusicGenders,
    required this.selectedArtistsWidgets,
    required this.selectedArtistsId,
    required this.choiceArtists,
    Key? key,
  }) : super(key: key);

  @override
  _FormEditEventState createState() => _FormEditEventState();
}

class _FormEditEventState extends State<FormEditEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  XFile? picture;

  @override
  void initState() {
    nameController.text = widget.event.name;
    descriptionController.text = widget.event.description;
    latitudeController.text = widget.event.latitude.toString();
    longitudeController.text = widget.event.longitude.toString();
    priceController.text = widget.event.price.toString();
    startDateController.text = widget.event.date.toString();
    endDateController.text = widget.event.endDate.toString();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    priceController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        picture = xFile;
        await picture!.readAsBytes().then((bytes) {
          setState(() {
            widget.event.picture = base64Encode(bytes);
            widget.eventFunction(widget.event);
          });
        });
      }
    });
  }

  void _updateEventMusicGenders() {
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
      widget.event.musicgenders = tempMusicGenders;
      widget.changesFunction(true);
      widget.eventFunction(widget.event);
    }
    print(widget.event.musicgenders.length);
  }

  void _updateEventArtists() {
    bool added = false;
    List<Artist> tempArtists = [];
    print(widget.selectedArtistsWidgets.length);
    widget.selectedArtistsWidgets.forEach((artistWidget) {
      widget.listArtists.forEach((artist) {
        if (artistWidget.value == artist.id) {
          added = true;
          print(artist.name);
          tempArtists.add(artist);
        }
      });
    });
    //Quelque chose à été ajouté ou retiré : liste vide == retiré (on ne gère pas le cas ou rien n'est selectionne ni avant ni après)
    if (added || tempArtists.isEmpty) {
      widget.event.artists = tempArtists;
      widget.changesFunction(true);
      widget.eventFunction(widget.event);
    }
    print(tempArtists.length);
    print(widget.event.artists.length);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  if (value != widget.event.name) {
                                    widget.event.name = nameController.text;
                                    setState(() {
                                      widget.changesFunction(true);
                                      widget.eventFunction(widget.event);
                                    });
                                  }
                                },
                                decoration: AdvancedDecoration.inputDecoration(
                                    hintText: 'Nom'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Description",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: descriptionController,
                                cursorColor: primaryColor,
                                style: TextStyle(
                                  color: const Color(0xff3D5382),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                onChanged: (String value) {
                                  if (value != widget.event.description) {
                                    widget.event.description =
                                        descriptionController.text;
                                    setState(() {
                                      widget.changesFunction(true);
                                      widget.eventFunction(widget.event);
                                    });
                                  }
                                },
                                decoration: AdvancedDecoration.inputDecoration(
                                    hintText: 'Description'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Latitude",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                                controller: latitudeController,
                                cursorColor: primaryColor,
                                style: TextStyle(
                                  color: const Color(0xff3D5382),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                onChanged: (String value) {
                                  if (value !=
                                      widget.event.latitude.toString()) {
                                    widget.event.latitude =
                                        double.parse(latitudeController.text);
                                    setState(() {
                                      widget.changesFunction(true);
                                      widget.eventFunction(widget.event);
                                    });
                                  }
                                },
                                decoration: AdvancedDecoration.inputDecoration(
                                    hintText: 'Latitude'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Longitude",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                                controller: longitudeController,
                                cursorColor: primaryColor,
                                style: TextStyle(
                                  color: const Color(0xff3D5382),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                onChanged: (String value) {
                                  if (value !=
                                      widget.event.longitude.toString()) {
                                    widget.event.longitude =
                                        double.parse(longitudeController.text);
                                    setState(() {
                                      widget.changesFunction(true);
                                      widget.eventFunction(widget.event);
                                    });
                                  }
                                },
                                decoration: AdvancedDecoration.inputDecoration(
                                    hintText: 'Longitude'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Prix",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 60,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                                controller: priceController,
                                cursorColor: primaryColor,
                                style: TextStyle(
                                  color: const Color(0xff3D5382),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                onChanged: (String value) {
                                  if (value != widget.event.price.toString()) {
                                    widget.event.price =
                                        double.parse(priceController.text);
                                    setState(() {
                                      widget.changesFunction(true);
                                      widget.eventFunction(widget.event);
                                    });
                                  }
                                },
                                decoration: AdvancedDecoration.inputDecoration(
                                    hintText: 'Prix'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Date de début",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            DateTimeField(
                              initialValue: widget.event.date,
                              format: DateFormat("yyyy-MM-dd HH:mm"),
                              textInputAction: TextInputAction.next,
                              controller: startDateController,
                              cursorColor: primaryColor,
                              style: TextStyle(
                                color: const Color(0xff3D5382),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: AdvancedDecoration.inputDecoration(
                                  hintText: 'Date de début'),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
                                  );
                                  DateTime combinedDate =
                                      DateTimeField.combine(date, time);
                                  if (combinedDate != widget.event.date) {
                                    widget.event.date = combinedDate;
                                    setState(() {
                                      widget.changesFunction(true);
                                      widget.eventFunction(widget.event);
                                    });
                                  }
                                  return combinedDate;
                                } else {
                                  return currentValue;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Date de fin",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            DateTimeField(
                              initialValue: widget.event.endDate,
                              format: DateFormat("yyyy-MM-dd HH:mm"),
                              textInputAction: TextInputAction.next,
                              controller: endDateController,
                              cursorColor: primaryColor,
                              style: TextStyle(
                                color: const Color(0xff3D5382),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: AdvancedDecoration.inputDecoration(
                                  hintText: 'Date de fin'),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        currentValue ?? DateTime.now()),
                                  );
                                  DateTime combinedDate =
                                      DateTimeField.combine(date, time);
                                  if (combinedDate != widget.event.endDate) {
                                    widget.event.endDate = combinedDate;
                                    setState(() {
                                      widget.changesFunction(true);
                                      widget.eventFunction(widget.event);
                                    });
                                  }
                                  return combinedDate;
                                } else {
                                  return currentValue;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
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
                            _updateEventMusicGenders();
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: SmartSelect<int>.multiple(
                          title: 'Artistes',
                          placeholder: 'Aucun choix',
                          selectedValue: widget.selectedArtistsId,
                          choiceItems: widget.choiceArtists,
                          onChange: (multiSelected) => setState(() {
                            if (multiSelected != null) {
                              if (multiSelected.choice != null) {
                                widget.selectedArtistsWidgets =
                                    multiSelected.choice!;
                              } else {
                                widget.selectedArtistsWidgets = [];
                              }
                            }
                            _updateEventArtists();
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
                      SizedBox(height: 15),
                      AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: (picture == null &&
                                    widget.event.picture == null)
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
                                          widget.changesFunction(true);
                                        },
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: secondaryColor,
                                    child:
                                        Stack(fit: StackFit.expand, children: [
                                      (picture != null)
                                          ? Image.file(File(picture!.path))
                                          : Image.memory(
                                              widget.event.getPictureEncoded(),
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
                                            widget.changesFunction(true);
                                          },
                                        ),
                                      ),
                                    ])),
                          )),
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }
}
