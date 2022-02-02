import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/views/account/admin/artist/admin_artist_page.dart';
import 'package:festivalapp/views/account/admin/event/admin_event_page.dart';
import 'package:festivalapp/views/account/admin/musicGender/admin_musicgender_page.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    const List<Widget> _pages = <Widget>[
      AdminEventPage(),
      AdminMusicGenderPage(),
      AdminArtistPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Administrateur"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColorDark,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.event),
              activeIcon: Icon(
                Icons.event,
                color: Theme.of(context).primaryColorDark,
              ),
              label: 'Evenements'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              activeIcon: Icon(
                Icons.music_note,
                color: Theme.of(context).primaryColorDark,
              ),
              label: 'Genres-Musicaux'),
          BottomNavigationBarItem(
              icon: Icon(Icons.album),
              activeIcon: Icon(
                Icons.album,
                color: Theme.of(context).primaryColorDark,
              ),
              label: 'Artistes'),
        ],
      ),
      body: SafeArea(
          child: IndexedStack(
        index: selectedIndex,
        children: _pages,
      )),
    );
  }
}
