import 'package:awesome_select/awesome_select.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/artist/artist_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/event/components/form_create_event.dart';
import 'package:flutter/material.dart';

class AdminCreateEvent extends StatefulWidget {
  AdminCreateEvent({Key? key}) : super(key: key);

  @override
  _AdminCreateEventState createState() => _AdminCreateEventState();
}

class _AdminCreateEventState extends State<AdminCreateEvent> {
  bool complete = false;
  Event? event;
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
    _futureMusicGender.then((musicGenders) {
      musicGenders.forEach((musicGender) {
        items.add(musicGender.id!);
      });
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
    _futureArtists.then((artists) {
      artists.forEach((artist) {
        items.add(artist.id);
      });
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

  void _updateCompleteValue(bool complete) {
    setState(() {
      this.complete = complete;
    });
  }

  void _updateEventValue(Event event) {
    setState(() {
      this.event = event;
    });
  }

  Future<void> _createEvent() async {
    await EventFetcher().postEvent(event: event!).then((Event event) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: successMessageColor,
          content: Text('Création réussie.')));
      FocusScope.of(context).unfocus();
      setState(() {
        this.complete = false;
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
        title: Text("Modifier un évenement"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
          onPressed: () {
            Navigator.pop(context, event);
          },
        ),
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
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: FormCreateEvent(
                              eventFunction: _updateEventValue,
                              completeFunction: _updateCompleteValue,
                              listMusicGenders: listMusicGenders,
                              listArtists: listArtists,
                              selectedMusicGendersWidgets:
                                  selectedMusicGendersWidgets,
                              selectedMusicGendersId:
                                  getSelectedMusicGendersId(),
                              choiceMusicGenders: buildMusicGendersWidgets(),
                              selectedArtistsWidgets: selectedArtistsWidgets,
                              selectedArtistsId: getSelectedArtistsId(),
                              choiceArtists: buildArtistsWidgets(),
                            ),
                          ),
                          Visibility(
                            visible: complete,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await _createEvent();
                                },
                                child: const Text("Enregistrer")),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
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
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
          }),
    );
  }
}
