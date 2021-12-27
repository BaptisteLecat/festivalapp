import 'package:flutter/material.dart';

class InnerRoundedBorderUpClipper extends CustomClipper<Path> {
  var radius = 16.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(radius, 0.0);
    path.arcToPoint(Offset(0.0, radius),
        clockwise: true, radius: Radius.circular(radius));

    /*path.lineTo(0.0, size.height);
    path.arcToPoint(Offset(radius, size.height), clockwise: false);
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height), clockwise: false);*/

    path.lineTo(0.0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: false, radius: Radius.circular(20));
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: false, radius: Radius.circular(20));

    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width - radius, 0.0),
        clockwise: true, radius: Radius.circular(radius));
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}

class InnerRoundedBorderDownClipper extends CustomClipper<Path> {
  var radius = 16.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0.0);
    path.arcToPoint(Offset(0.0, size.height), clockwise: false);

    path.lineTo(0.0, size.height - radius);
    path.arcToPoint(Offset(radius, size.height),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(Offset(size.width, size.height - radius),
        clockwise: true, radius: Radius.circular(radius));
    path.lineTo(size.width, radius);
    path.arcToPoint(Offset(size.width, 0.0), clockwise: false);
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
