import 'package:flutter/material.dart';
import 'package:festivalapp/screens/SplashScreenWrapper.dart';
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
      title: 'Flutter Demo',
      home: SplashScreenWrapper(),
      debugShowCheckedModeBanner: false,
      theme: basicTheme(),
    );
  }
}
