import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/views/account/admin/admin_page.dart';
import 'package:flutter/material.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdminPage()));
      },
      child: Container(
        decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(18))),
        child: const Center(
          child: Text("Panel Administrateur"),
        ),
      ),
    );
  }
}
