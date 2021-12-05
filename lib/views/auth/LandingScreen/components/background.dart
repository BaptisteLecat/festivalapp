import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * 0.6),
              child: SvgPicture.asset(
                "assets/images/background/landing_top.svg",
                width: size.width * 0.5,
                fit: BoxFit.fill,
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * 0.5),
              child: SvgPicture.asset(
                "assets/images/background/landing_bottom.svg",
                width: size.width * 1,
                fit: BoxFit.fill,
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
