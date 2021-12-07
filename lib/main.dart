import 'dart:io';

import 'package:flutter/material.dart';
import 'package:festivalapp/views/splash_screen_wrapper.dart';
import 'package:festivalapp/common/theme.dart';

///Development
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());

  ///dev
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: UniqueKey(),
      title: 'FestivApp',
      home: const SplashScreenWrapper(),
      debugShowCheckedModeBanner: false,
      theme: basicTheme(),
    );
  }
}
