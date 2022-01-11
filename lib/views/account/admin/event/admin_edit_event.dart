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
  List<S2Choice<int>> selectedMusicGendersWidgets = [];
  List<S2Choice<int>> selectedArtistsWidgets = [];
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

  ///This function get the musicGenders Id from the API and the local selected.
  ///If no local selected it will add the remote ones in the local list.
  List<int> getSelectedMusicGendersId() {
    List<int> items = [];
    if (selectedMusicGendersWidgets.isNotEmpty) {
      selectedMusicGendersWidgets.forEach((musicGenderWidget) {
        items.add(musicGenderWidget.value);
      });
    } else {
      items = hydrateMusicGendersId();
    }
    return items;
  }

  ///This function get the musicGenders from the currently Event fetch in API.
  List<int> hydrateMusicGendersId() {
    List<int> items = [];
    widget.event.musicgenders.forEach((musicGender) {
      items.add(musicGender.id!);
    });
    return items;
  }

  List<S2Choice<int>> buildMusicGendersWidgets() {
    List<S2Choice<int>> items = [];
    listMusicGenders.forEach((musicGender) {
      items
          .add(S2Choice<int>(value: musicGender.id!, title: musicGender.label));
    });
    return items;
  }

  ///This function get the artists Id from the API and the local selected.
  ///If no local selected it will add the remote ones in the local list.
  List<int> getSelectedArtistsId() {
    List<int> items = [];
    if (selectedArtistsWidgets.isNotEmpty) {
      selectedArtistsWidgets.forEach((artistWidget) {
        items.add(artistWidget.value);
      });
    } else {
      items = hydrateArtistsId();
    }
    return items;
  }

  List<int> hydrateArtistsId() {
    List<int> items = [];
    widget.event.artists.forEach((artist) {
      items.add(artist.id);
    });
    return items;
  }

  List<S2Choice<int>> buildArtistsWidgets() {
    List<S2Choice<int>> items = [];
    listArtists.forEach((artist) {
      items.add(S2Choice<int>(value: artist.id, title: artist.name));
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
      FocusScope.of(context).unfocus();
    }).onError((AppException error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: errorMessageColor,
          content: Text("${error.message}")));
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier un évenement"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
          onPressed: () {
            Navigator.pop(context, widget.event);
          },
        ),
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
                        listMusicGenders: listMusicGenders,
                        listArtists: listArtists,
                        selectedMusicGendersWidgets:
                            selectedMusicGendersWidgets,
                        selectedMusicGendersId: getSelectedMusicGendersId(),
                        choiceMusicGenders: buildMusicGendersWidgets(),
                        selectedArtistsWidgets: selectedArtistsWidgets,
                        selectedArtistsId: getSelectedArtistsId(),
                        choiceArtists: buildArtistsWidgets(),
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
