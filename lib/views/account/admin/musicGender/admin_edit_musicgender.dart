import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/musicGender/components/form_musicgender.dart';
import 'package:flutter/material.dart';

class AdminEditMusicGender extends StatefulWidget {
  MusicGender musicGender;
  AdminEditMusicGender({Key? key, required this.musicGender}) : super(key: key);

  @override
  _AdminEditMusicGenderState createState() => _AdminEditMusicGenderState();
}

class _AdminEditMusicGenderState extends State<AdminEditMusicGender> {
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

  void _updateMusicGenderValue(MusicGender musicGender) {
    setState(() {
      widget.musicGender = musicGender;
    });
  }

  Future<void> _saveMusicGenderUpdate() async {
    await MusicGenderFetcher()
        .putMusicGender(musicGender: widget.musicGender)
        .then((MusicGender musicGender) {
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
          title: Text("Modifier un genre musical"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Retour',
            onPressed: () {
              Navigator.pop(context, widget.musicGender);
            },
          ),
          actions: [
            Visibility(
              visible: changes,
              child: IconButton(
                icon: const Icon(Icons.done),
                tooltip: 'Enregistrer',
                onPressed: () async {
                  await _saveMusicGenderUpdate();
                },
              ),
            ),
          ],
        ),
        body: SizedBox(
          child: FormMusicGender(
            musicGender: widget.musicGender.copy(),
            musicGenderFunction: _updateMusicGenderValue,
            changesFunction: _updateChangesValue,
          ),
        ));
  }
}
