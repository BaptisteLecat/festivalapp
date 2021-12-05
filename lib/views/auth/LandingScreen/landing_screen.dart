import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:flutter/services.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      body: const Body(),
    );
  }
}
