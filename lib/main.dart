import 'package:flutter/material.dart';
import 'package:festivalapp/views/splash_screen_wrapper.dart';
import 'package:festivalapp/common/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
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
