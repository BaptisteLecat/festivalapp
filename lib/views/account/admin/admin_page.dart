import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/views/account/admin/event/admin_event_page.dart';
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
      Icon(
        Icons.camera,
        size: 150,
      ),
      Icon(
        Icons.chat,
        size: 150,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Administrateur"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondaryColor,
        selectedItemColor: primaryColor,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.event),
              activeIcon: Icon(
                Icons.event,
                color: primaryColor,
              ),
              label: 'Evenement'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              activeIcon: Icon(
                Icons.music_note,
                color: primaryColor,
              ),
              label: 'Genre-Musique'),
          BottomNavigationBarItem(
              icon: Icon(Icons.album),
              activeIcon: Icon(
                Icons.album,
                color: primaryColor,
              ),
              label: 'Artiste'),
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
