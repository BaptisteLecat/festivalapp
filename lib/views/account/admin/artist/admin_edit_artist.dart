import 'package:awesome_select/awesome_select.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/artist/artist_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/artist/components/form_artist.dart';
import 'package:festivalapp/views/account/admin/musicGender/components/form_musicgender.dart';
import 'package:flutter/material.dart';

class AdminEditArtist extends StatefulWidget {
  Artist artist;
  AdminEditArtist({Key? key, required this.artist}) : super(key: key);

  @override
  _AdminEditArtistState createState() => _AdminEditArtistState();
}

class _AdminEditArtistState extends State<AdminEditArtist> {
  bool changes = false;
  List<S2Choice<int>> selectedMusicGendersWidgets = [];
  List<S2Choice<int>> selectedEventsWidgets = [];
  late Future<List<MusicGender>> _futureMusicGender;
  List<MusicGender> listMusicGenders = [];
  late Future<List<Event>> _futureEvents;
  List<Event> listEvents = [];

  @override
  void initState() {
    _futureMusicGender = MusicGenderFetcher().getMusicGenderList();
    _futureEvents = EventFetcher().getEventList();
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
    widget.artist.musicGenders!.forEach((musicGender) {
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

  ///This function get the events Id from the API and the local selected.
  ///If no local selected it will add the remote ones in the local list.
  List<int> getSelectedEventsId() {
    List<int> items = [];
    if (selectedEventsWidgets.isNotEmpty) {
      selectedEventsWidgets.forEach((eventWidget) {
        items.add(eventWidget.value);
      });
    } else {
      items = hydrateEventsId();
    }
    return items;
  }

  ///This function get the events from the currently Event fetch in API.
  List<int> hydrateEventsId() {
    List<int> items = [];
    widget.artist.events!.forEach((event) {
      items.add(event.id);
    });
    return items;
  }

  List<S2Choice<int>> buildEventsWidgets() {
    List<S2Choice<int>> items = [];
    listEvents.forEach((event) {
      items.add(S2Choice<int>(value: event.id, title: event.name));
    });
    return items;
  }

  void _updateChangesValue(bool changes) {
    setState(() {
      this.changes = changes;
    });
  }

  void _updateArtistValue(Artist artist) {
    setState(() {
      widget.artist = artist;
    });
  }

  Future<void> _saveArtistUpdate() async {
    await ArtistFetcher()
        .putArtist(artist: widget.artist)
        .then((Artist artist) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: successMessageColor,
          content: Text('Modification enregistrées')));
      FocusScope.of(context).unfocus();
      setState(() {
        this.changes = false;
      });
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
          title: Text("Modifier un artiste"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Retour',
            onPressed: () {
              Navigator.pop(context, widget.artist);
            },
          ),
          actions: [
            Visibility(
              visible: changes,
              child: IconButton(
                icon: const Icon(Icons.done),
                tooltip: 'Enregistrer',
                onPressed: () async {
                  await _saveArtistUpdate();
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: _futureEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                listEvents = snapshot.data as List<Event>;
                return FutureBuilder(
                  future: _futureMusicGender,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      listMusicGenders = snapshot.data as List<MusicGender>;
                      return SizedBox(
                        child: FormArtist(
                          artist: widget.artist.copy(),
                          artistFunction: _updateArtistValue,
                          changesFunction: _updateChangesValue,
                          listMusicGenders: listMusicGenders,
                          listEvents: listEvents,
                          selectedMusicGendersWidgets:
                              selectedMusicGendersWidgets,
                          selectedMusicGendersId: getSelectedMusicGendersId(),
                          choiceMusicGenders: buildMusicGendersWidgets(),
                          selectedEventsWidgets: selectedEventsWidgets,
                          selectedEventsId: getSelectedEventsId(),
                          choiceEvents: buildEventsWidgets(),
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
            }));
  }
}
