import 'package:festivalapp/services/api/repositories/user/user_fetcher.dart';
import 'package:festivalapp/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/common/widgets/menu/fab_bottom_app_bar.dart';

class RootPage extends StatefulWidget {
  bool fromAuth;
  RootPage({Key? key, this.fromAuth = false}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _lastSelected = 0;
  late Widget displayedPage;

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
      displayedPage = _getDisplayedPage();
      print(displayedPage);
    });
  }

  Widget _getDisplayedPage() {
    Widget page = HomePage();
    switch (_lastSelected) {
      case 0:
        page = HomePage(
          fromAuth: widget.fromAuth,
        );
        break;
      case 1:
        page = HomePage();
        break;
      case 2:
        page = HomePage();
        break;
      case 3:
        page = HomePage();
        break;
      default:
        page = HomePage(
          fromAuth: widget.fromAuth,
        );
    }

    setState(() {
      widget.fromAuth = false;
    });

    return page;
  }

  @override
  void initState() {
    super.initState();
    displayedPage = _getDisplayedPage();
    UserFetcher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: FABBottomAppBar(
          backgroundColor: Colors.white,
          color: Colors.black,
          selectedColor: primaryColor,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(
                iconData: AssetImage("assets/icons/menu/home.png"),
                selectedIconData:
                    AssetImage("assets/icons/menu/home_selected.png"),
                text: 'Home'),
            FABBottomAppBarItem(
                iconData: AssetImage("assets/icons/menu/shopping-cart.png"),
                selectedIconData:
                    AssetImage("assets/icons/menu/shopping-cart_selected.png"),
                text: 'Cart'),
            FABBottomAppBarItem(
                iconData: AssetImage("assets/icons/menu/family.png"),
                selectedIconData:
                    AssetImage("assets/icons/menu/family_selected.png"),
                text: 'Family'),
            FABBottomAppBarItem(
                iconData: AssetImage("assets/icons/menu/user.png"),
                selectedIconData:
                    AssetImage("assets/icons/menu/user_selected.png"),
                text: 'Account'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 64.0,
          height: 64.0,
          child: new FloatingActionButton(
            backgroundColor: primaryColor,
            shape: new CircleBorder(),
            elevation: 0.0,
            child: Padding(
                padding: EdgeInsets.all(14),
                child: Image.asset("assets/icons/menu/search.png")),
            onPressed: () {},
          ),
        ),
        body: SafeArea(child: displayedPage));
  }
}
