import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/event/admin_edit_event.dart';
import 'package:festivalapp/views/account/admin/event/components/admin_event_tile.dart';
import 'package:festivalapp/views/account/admin/musicGender/admin_edit_musicgender.dart';
import 'package:flutter/material.dart';

import 'components/admin_musicgender_tile.dart';

class AdminMusicGenderPage extends StatefulWidget {
  const AdminMusicGenderPage({Key? key}) : super(key: key);

  @override
  _AdminMusicGenderPageState createState() => _AdminMusicGenderPageState();
}

class _AdminMusicGenderPageState extends State<AdminMusicGenderPage> {
  late Future<List<MusicGender>> _futureMusicGenders;
  List<MusicGender> listMusicGenders = [];

  @override
  void initState() {
    _futureMusicGenders = MusicGenderFetcher().getMusicGenderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Liste des Genres Musicaux",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white)),
                  Container(
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Text("Ajouter",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: FutureBuilder(
                  future: _futureMusicGenders,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      listMusicGenders = snapshot.data as List<MusicGender>;
                      return ListView.builder(
                          itemCount: listMusicGenders.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Supprimer",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              child: AdminMusicGenderTile(
                                musicGender: listMusicGenders[index],
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminEditMusicGender(
                                                musicGender:
                                                    listMusicGenders[index],
                                              ))).then((value) {
                                    setState(() {
                                      listMusicGenders[index] = value;
                                    });
                                  });
                                },
                              ),
                            );
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
