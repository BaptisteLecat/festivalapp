import 'package:festivalapp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/views/auth/Login/login_screen.dart';
import 'package:festivalapp/views/auth/Register/register_screen.dart';
import 'background.dart';
import '../../../../common/widgets/buttons/cta_button.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

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

  Container _buildInfoText(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "L'application pour faire la fête",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Theme.of(context).primaryColorDark,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Suivez facilement tous vos événements",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Theme.of(context).primaryColorDark,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Container _buildAuthButtons(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CTAButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            content: Text(
              "Connexion",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: const Color(0xffFFFFFF),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            },
            child: Text(
              "Enregistrement",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Theme.of(context).primaryColorDark,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.1, vertical: size.height * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildTitleText("FESTIV", "APP", Theme.of(context).primaryColor,
                  Theme.of(context).backgroundColor),
              _buildInfoText(context),
              _buildAuthButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}
