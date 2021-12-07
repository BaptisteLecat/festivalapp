import 'package:flutter/material.dart';
import 'package:festivalapp/model/app_user.dart';
import 'package:festivalapp/common/widgets/screen_loader.dart';
import 'package:festivalapp/views/root_page.dart';
import 'package:festivalapp/views/auth/landingScreen/landing_screen.dart';
import 'package:festivalapp/services/auth/authentication.dart';

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({Key? key}) : super(key: key);

  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    Widget returnedWidget;
    return FutureBuilder(
        future: AuthenticationService().getCurrentUser(),
        builder: (context, AsyncSnapshot<AppUser?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            print("user id: ${snapshot.data!.id}");
            if (snapshot.data!.id == null) {
              returnedWidget = LandingScreen();
            } else {
              returnedWidget = RootPage(
                fromAuth: true,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            returnedWidget = const Scaffold(
              body: ScreenLoader(),
            );
          } else {
            returnedWidget = LandingScreen();
          }
          return returnedWidget;
        });
  }
}
