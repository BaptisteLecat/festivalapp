import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/artist/artist_fetcher.dart';
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

  @override
  void initState() {
    super.initState();
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
        body: SizedBox(
          child: FormArtist(
            artist: widget.artist.copy(),
            artistFunction: _updateArtistValue,
            changesFunction: _updateChangesValue,
          ),
        ));
  }
}
