import 'dart:io';

import 'package:awesome_select/awesome_select.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/common/widgets/layout/icon_badge.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AdminEditEvent extends StatefulWidget {
  Event event;
  AdminEditEvent({Key? key, required this.event}) : super(key: key);

  @override
  _AdminEditEventState createState() => _AdminEditEventState();
}

class _AdminEditEventState extends State<AdminEditEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  bool changes = false;
  XFile? picture;
  List<S2Choice<int>>? selectedItems;
  late Future<List<MusicGender>> _futureMusicGender;
  List<MusicGender> listMusicGenders = [];

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

  @override
  void initState() {
    _futureMusicGender = MusicGenderFetcher().getMusicGenderList();
    nameController.text = widget.event.name;
    descriptionController.text = widget.event.description;
    latitudeController.text = widget.event.latitude.toString();
    longitudeController.text = widget.event.longitude.toString();
    priceController.text = widget.event.price.toString();
    startDateController.text = widget.event.date.toString();
    endDateController.text = widget.event.endDate.toString();
    super.initState();
  }

  Future<void> pickImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        setState(() {
          picture = xFile;
        });
      }
    });
  }

  List<int> getSelectedItems() {
    List<int> items = [];
    if (selectedItems != null) {
      selectedItems!.forEach((element) {
        items.add(element.value);
      });
    } else {
      items = hydrateItems();
    }
    return items;
  }

  List<int> hydrateItems() {
    List<int> items = [];
    if (widget.event.musicgenders != null) {
      widget.event.musicgenders!.asMap().forEach((index, element) {
        items.add(index);
      });
    }
    return items;
  }

  List<S2Choice<int>> getItems() {
    List<S2Choice<int>> items = [];
    listMusicGenders.forEach((element) {
      items.add(S2Choice<int>(value: element.id!, title: element.label));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier un évenement"),
        actions: [
          Visibility(
            visible: changes,
            child: IconButton(
              icon: const Icon(Icons.done),
              tooltip: 'Enregistrer',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Modification enregistrées')));
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _futureMusicGender,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            listMusicGenders = snapshot.data as List<MusicGender>;
            return SizedBox(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: LayoutBuilder(builder: (context, constraint) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraint.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onEditingComplete: () {
                                            if (nameController.text !=
                                                widget.event.name) {
                                              widget.event.name =
                                                  nameController.text;
                                              setState(() {
                                                changes = true;
                                              });
                                            }
                                          },
                                          decoration: AdvancedDecoration
                                              .inputDecoration(hintText: 'Nom'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onEditingComplete: () {
                                            if (descriptionController.text !=
                                                widget.event.description) {
                                              widget.event.description =
                                                  descriptionController.text;
                                              setState(() {
                                                changes = true;
                                              });
                                            }
                                          },
                                          decoration: AdvancedDecoration
                                              .inputDecoration(
                                                  hintText: 'Description'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          textInputAction: TextInputAction.next,
                                          controller: latitudeController,
                                          cursorColor: primaryColor,
                                          style: TextStyle(
                                            color: const Color(0xff3D5382),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          onEditingComplete: () {
                                            if (double.parse(latitudeController
                                                    .value.text) !=
                                                widget.event.latitude) {
                                              widget.event.latitude =
                                                  double.parse(
                                                      latitudeController
                                                          .value.text);
                                              setState(() {
                                                changes = true;
                                              });
                                            }
                                          },
                                          decoration: AdvancedDecoration
                                              .inputDecoration(
                                                  hintText: 'Latitude'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          textInputAction: TextInputAction.next,
                                          controller: longitudeController,
                                          cursorColor: primaryColor,
                                          style: TextStyle(
                                            color: const Color(0xff3D5382),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          onEditingComplete: () {
                                            if (double.parse(longitudeController
                                                    .value.text) !=
                                                widget.event.longitude) {
                                              widget.event.longitude =
                                                  double.parse(
                                                      longitudeController
                                                          .value.text);
                                              setState(() {
                                                changes = true;
                                              });
                                            }
                                          },
                                          decoration: AdvancedDecoration
                                              .inputDecoration(
                                                  hintText: 'Longitude'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          textInputAction: TextInputAction.next,
                                          controller: priceController,
                                          cursorColor: primaryColor,
                                          style: TextStyle(
                                            color: const Color(0xff3D5382),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          onEditingComplete: () {
                                            if (double.parse(priceController
                                                    .value.text) !=
                                                widget.event.price) {
                                              widget.event.price = double.parse(
                                                  priceController.value.text);
                                              setState(() {
                                                changes = true;
                                              });
                                            }
                                          },
                                          decoration: AdvancedDecoration
                                              .inputDecoration(
                                                  hintText: 'Prix'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        decoration:
                                            AdvancedDecoration.inputDecoration(
                                                hintText: 'Date de début'),
                                        onShowPicker:
                                            (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1900),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                          if (date != null) {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                      currentValue ??
                                                          DateTime.now()),
                                            );
                                            DateTime combinedDate =
                                                DateTimeField.combine(
                                                    date, time);
                                            if (combinedDate !=
                                                widget.event.date) {
                                              widget.event.date = combinedDate;
                                              setState(() {
                                                changes = true;
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        decoration:
                                            AdvancedDecoration.inputDecoration(
                                                hintText: 'Date de fin'),
                                        onShowPicker:
                                            (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1900),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                          if (date != null) {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                      currentValue ??
                                                          DateTime.now()),
                                            );
                                            DateTime combinedDate =
                                                DateTimeField.combine(
                                                    date, time);
                                            if (combinedDate !=
                                                widget.event.endDate) {
                                              widget.event.endDate =
                                                  combinedDate;
                                              setState(() {
                                                changes = true;
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: SmartSelect<int>.multiple(
                                    title: 'Genre musicaux',
                                    placeholder: 'Aucun choix',
                                    selectedValue: getSelectedItems(),
                                    choiceItems: getItems(),
                                    onChange: (multiSelected) => setState(() {
                                      changes = true;
                                      if (multiSelected != null) {
                                        selectedItems = multiSelected.choice;
                                      }
                                    }),
                                    choiceType: S2ChoiceType.cards,
                                    groupConfig: S2GroupConfig(
                                        headerStyle: S2GroupHeaderStyle(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    color: Colors.white))),
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Icon(Icons.insert_photo),
                                                      Text("Choisir une image",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white)),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    await pickImage();
                                                    changes = true;
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color: secondaryColor,
                                              child: (picture != null)
                                                  ? Image.file(
                                                      File(picture!.path))
                                                  : Image.memory(
                                                      widget.event
                                                          .getPictureEncoded(),
                                                    )),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  )),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print("sdrsdfsdfsdf");
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
        },
      ),
    );
  }
}
