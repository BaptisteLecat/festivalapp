import 'package:awesome_select/awesome_select.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/artist/artist_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/artist/components/form_create_artist.dart';
import 'package:flutter/material.dart';

class AdminCreateArtist extends StatefulWidget {
  AdminCreateArtist({Key? key}) : super(key: key);

  @override
  _AdminCreateArtistState createState() => _AdminCreateArtistState();
}

class _AdminCreateArtistState extends State<AdminCreateArtist> {
  bool complete = false;
  List<S2Choice<int>> selectedMusicGendersWidgets = [];
  List<S2Choice<int>> selectedEventsWidgets = [];
  late Future<List<MusicGender>> _futureMusicGender;
  List<MusicGender> listMusicGenders = [];
  late Future<List<Event>> _futureEvents;
  List<Event> listEvents = [];
  Artist? artist;

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
    _futureEvents.then((events) {
      events.forEach((event) {
        items.add(event.id);
      });
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

  void _updateCompleteValue(bool complete) {
    setState(() {
      this.complete = complete;
    });
  }

  void _updateArtistValue(Artist artist) {
    setState(() {
      this.artist = artist;
    });
  }

  Future<void> _createArtist() async {
    await ArtistFetcher().postArtist(artist: artist!).then((Artist artist) {
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
          title: Text("Ajouter un artiste"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Retour',
            onPressed: () {
              Navigator.pop(context, artist);
            },
          ),
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
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: FormCreateArtist(
                                artistFunction: _updateArtistValue,
                                completeFunction: _updateCompleteValue,
                                listMusicGenders: listMusicGenders,
                                listEvents: listEvents,
                                selectedMusicGendersWidgets:
                                    selectedMusicGendersWidgets,
                                selectedMusicGendersId:
                                    getSelectedMusicGendersId(),
                                choiceMusicGenders: buildMusicGendersWidgets(),
                                selectedEventsWidgets: selectedEventsWidgets,
                                selectedEventsId: getSelectedEventsId(),
                                choiceEvents: buildEventsWidgets(),
                              ),
                            ),
                            Visibility(
                              visible: complete,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await _createArtist();
                                  },
                                  child: const Text("Enregistrer")),
                            )
                          ],
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
