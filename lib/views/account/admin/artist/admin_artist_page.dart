import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/model/artist.dart';
import 'package:festivalapp/model/event.dart';
import 'package:festivalapp/model/music_gender.dart';
import 'package:festivalapp/services/Api/repositories/artist/artist_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/event/event_fetcher.dart';
import 'package:festivalapp/services/Api/repositories/musicGender/musicgender_fetcher.dart';
import 'package:festivalapp/views/account/admin/artist/admin_edit_artist.dart';
import 'package:festivalapp/views/account/admin/event/admin_edit_event.dart';
import 'package:festivalapp/views/account/admin/event/components/admin_event_tile.dart';
import 'package:festivalapp/views/account/admin/musicGender/admin_edit_musicgender.dart';
import 'package:flutter/material.dart';

import 'components/admin_artist_tile.dart';

class AdminArtistPage extends StatefulWidget {
  const AdminArtistPage({Key? key}) : super(key: key);

  @override
  _AdminArtistPageState createState() => _AdminArtistPageState();
}

class _AdminArtistPageState extends State<AdminArtistPage> {
  late Future<List<Artist>> _futureArtists;
  List<Artist> listArtists = [];

  @override
  void initState() {
    _futureArtists = ArtistFetcher().getArtistList();
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
                  Text("Liste des Artistes",
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
                  future: _futureArtists,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      listArtists = snapshot.data as List<Artist>;
                      return ListView.builder(
                          itemCount: listArtists.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
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
                                child: AdminArtistTile(
                                  artist: listArtists[index],
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminEditArtist(
                                                  artist: listArtists[index],
                                                ))).then((value) {
                                      setState(() {
                                        listArtists[index] = value;
                                      });
                                    });
                                  },
                                ),
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
