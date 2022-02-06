import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/error/app_exception.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/musicGender/components/form_create_musicgender.dart';
import 'package:festivalapp/views/account/admin/musicGender/components/form_edit_musicgender.dart';
import 'package:flutter/material.dart';

class AdminCreateMusicGender extends StatefulWidget {
  AdminCreateMusicGender({Key? key}) : super(key: key);

  @override
  _AdminCreateMusicGenderState createState() => _AdminCreateMusicGenderState();
}

class _AdminCreateMusicGenderState extends State<AdminCreateMusicGender> {
  bool complete = false;
  MusicGender? musicGender;

  @override
  void initState() {
    super.initState();
  }

  void _updateCompleteValue(bool complete) {
    setState(() {
      this.complete = complete;
    });
  }

  void _updateMusicGenderValue(MusicGender musicGender) {
    setState(() {
      this.musicGender = musicGender;
    });
  }

  Future<void> _createMusicGender() async {
    await MusicGenderFetcher()
        .postMusicGender(musicGender: musicGender!)
        .then((MusicGender musicGender) {
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
          title: Text("Ajouter un genre musical"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Retour',
            onPressed: () {
              Navigator.pop(context, musicGender);
            },
          ),
        ),
        body: SizedBox(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: FormCreateMusicGender(
                  musicGenderFunction: _updateMusicGenderValue,
                  changesFunction: _updateCompleteValue,
                ),
              ),
              Visibility(
                visible: complete,
                child: ElevatedButton(
                    onPressed: () async {
                      await _createMusicGender();
                    },
                    child: const Text("Enregistrer")),
              ),
            ],
          ),
        ));
  }
}
