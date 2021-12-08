import 'package:festivalapp/common/constants/colors.dart';
import 'package:flutter/material.dart';

class DefaultDecoration {
  static inputDecoration({required String hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: secondaryColor,
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      border: InputBorder.none,
    );
  }
}
