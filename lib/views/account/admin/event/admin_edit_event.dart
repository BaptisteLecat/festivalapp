import 'dart:io';

import 'package:awesome_select/awesome_select.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/common/widgets/layout/icon_badge.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/artist/artist_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/event/components/form_event.dart';
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
  bool changes = false;
  List<S2Choice<MusicGender>>? selectedMusicGenders;
  List<S2Choice<Artist>>? selectedArtists;
  late Future<List<MusicGender>> _futureMusicGender;
  List<MusicGender> listMusicGenders = [];
  late Future<List<Artist>> _futureArtists;
  List<Artist> listArtists = [];

  @override
  void initState() {
    _futureMusicGender = MusicGenderFetcher().getMusicGenderList();
    _futureArtists = ArtistFetcher().getArtistList();
    super.initState();
  }

  List<MusicGender> getSelectedMusicGenders() {
    List<MusicGender> items = [];
    if (selectedMusicGenders != null) {
      selectedMusicGenders!.forEach((element) {
        print(element);
        items.add(element.value);
      });
    } else {
      items = hydrateMusicGenders();
    }
    return items;
  }

  List<MusicGender> hydrateMusicGenders() {
    List<MusicGender> items = [];
    if (widget.event.musicgenders != null) {
      widget.event.musicgenders!.forEach((element) {
        print(element.label);
        items.add(element);
      });
    }
    return items;
  }

  List<S2Choice<MusicGender>> getMusicGenders() {
    List<S2Choice<MusicGender>> items = [];
    listMusicGenders.forEach((element) {
      items.add(S2Choice<MusicGender>(value: element, title: element.label));
    });
    return items;
  }

  List<Artist> getSelectedArtists() {
    List<Artist> items = [];
    if (selectedArtists != null) {
      selectedArtists!.forEach((element) {
        items.add(element.value);
      });
    } else {
      items = hydrateArtists();
    }
    return items;
  }

  List<Artist> hydrateArtists() {
    List<Artist> items = [];
    if (widget.event.artists != null) {
      widget.event.artists!.forEach((element) {
        items.add(element);
      });
    }
    return items;
  }

  List<S2Choice<Artist>> getArtists() {
    List<S2Choice<Artist>> items = [];
    listArtists.forEach((element) {
      items.add(S2Choice<Artist>(value: element, title: element.name));
    });
    return items;
  }

  void _updateChangesValue(bool changes) {
    setState(() {
      this.changes = changes;
    });
  }

  void _updateEventValue(Event event) {
    setState(() {
      widget.event = event;
    });
  }

  Future<void> _saveEventUpdate() async {
    await EventFetcher().putEvent(event: widget.event).then((Event event) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: successMessageColor,
          content: Text('Modification enregistrées')));
    }).onError((AppException error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: errorMessageColor,
          content: Text("${error.message}")));
    });
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
              onPressed: () async {
                await _saveEventUpdate();
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _futureArtists,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              listArtists = snapshot.data as List<Artist>;
              return FutureBuilder(
                future: _futureMusicGender,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    listMusicGenders = snapshot.data as List<MusicGender>;
                    return SizedBox(
                      child: FormEvent(
                        event: widget.event.copy(),
                        eventFunction: _updateEventValue,
                        changesFunction: _updateChangesValue,
                        selectedMusicGenders: selectedMusicGenders,
                        selectedIndexedMusicGenders: getSelectedMusicGenders(),
                        choiceMusicGenders: getMusicGenders(),
                        selectedArtists: selectedArtists,
                        selectedIndexedArtists: getSelectedArtists(),
                        choiceArtists: getArtists(),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
          }),
    );
  }
}
