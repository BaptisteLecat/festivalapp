import 'dart:io';

import 'package:awesome_select/awesome_select.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:festivalapp/common/widgets/layout/icon_badge.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/artist/artist_fetcher.dart';
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
  List<S2Choice<int>>? selectedMusicGenders;
  List<S2Choice<int>>? selectedArtists;
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

  List<int> getSelectedMusicGenders() {
    List<int> items = [];
    if (selectedMusicGenders != null) {
      selectedMusicGenders!.forEach((element) {
        items.add(element.value);
      });
    } else {
      items = hydrateMusicGenders();
    }
    return items;
  }

  List<int> hydrateMusicGenders() {
    List<int> items = [];
    if (widget.event.musicgenders != null) {
      widget.event.musicgenders!.asMap().forEach((index, element) {
        items.add(index);
      });
    }
    return items;
  }

  List<S2Choice<int>> getMusicGenders() {
    List<S2Choice<int>> items = [];
    listMusicGenders.forEach((element) {
      items.add(S2Choice<int>(value: element.id!, title: element.label));
    });
    return items;
  }

  List<int> getSelectedArtists() {
    List<int> items = [];
    if (selectedArtists != null) {
      selectedArtists!.forEach((element) {
        items.add(element.value);
      });
    } else {
      items = hydrateMusicGenders();
    }
    return items;
  }

  List<int> hydrateArtists() {
    List<int> items = [];
    if (widget.event.musicgenders != null) {
      widget.event.musicgenders!.asMap().forEach((index, element) {
        items.add(index);
      });
    }
    return items;
  }

  List<S2Choice<int>> getArtists() {
    List<S2Choice<int>> items = [];
    listArtists.forEach((element) {
      items.add(S2Choice<int>(value: element.id, title: element.name));
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
                        changes: changes,
                        event: widget.event,
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
