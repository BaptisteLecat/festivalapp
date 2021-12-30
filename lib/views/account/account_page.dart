import 'package:festivalapp/services/Api/repositories/auth/auth_fetcher.dart';
import 'package:festivalapp/views/account/components/admin_button.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthFetcher().whoAmI(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Column(
              children: const [Flexible(child: AdminButton())],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text("Une erreur est survenue"),
          );
        }
      },
    );
  }
}
