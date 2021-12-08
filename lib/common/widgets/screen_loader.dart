import 'package:festivalapp/common/constants/colors.dart';
import 'package:flutter/material.dart';

class ScreenLoader extends StatefulWidget {
  const ScreenLoader({Key? key}) : super(key: key);

  @override
  _ScreenLoaderState createState() => _ScreenLoaderState();
}

class _ScreenLoaderState extends State<ScreenLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.easeInOutBack,
    );

    animation = Tween<double>(
      begin: 0,
      end: -40,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animController.forward();
        }
      });

    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  Widget _buildTitleText(String firstText, String secondText, Color firstColor,
      Color secondColor) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: RichText(
        text: TextSpan(
          text: firstText,
          style: TextStyle(
              fontFamily: 'LilitaOne', fontSize: 54, color: firstColor),
          children: <TextSpan>[
            TextSpan(
              text: secondText,
              style: TextStyle(color: secondColor),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animController,
        builder: (_, child) => Stack(children: <Widget>[
              Center(
                child: Transform.translate(
                  offset: Offset(0, animation.value),
                  child: _buildTitleText(
                      "FESTIV", "APP", primaryColor, secondaryColor),
                ),
              ),
            ]));
  }
}
