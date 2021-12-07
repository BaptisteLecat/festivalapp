import 'package:festivalapp/common/error/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/Model/app_user.dart';
import 'package:festivalapp/common/widgets/loading.dart';
import 'package:festivalapp/views/Auth/Login/login_screen.dart';
import 'package:festivalapp/views/auth/Register/components/register_form.dart';
import '../../../../common/widgets/buttons/cta_button.dart';
import '../../../../services/auth/authentication.dart';
import 'package:festivalapp/common/constants/colors.dart';

class Body extends StatefulWidget {
  final AuthenticationService _auth = AuthenticationService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isAcceptedCGU = false;
  bool loading = false;
  String error = "";
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ///This function will be given to the child widget. It will update the value troughout the function.
  _updateErrorCodeState(String errorCode) {
    setState(() {
      widget.error = "Une erreur est survenue";
    });
  }

  ///This function will be given to the child widget. It will update the value troughout the function.
  _updateCGUState(bool isAcceptedCGU) {
    setState(() {
      widget.isAcceptedCGU = isAcceptedCGU;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? Loading()
        : Container(
            height: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Flexible(flex: 2, child: _headerBuilder()),
                Flexible(
                  flex: 6,
                  child: Flex(
                    children: [
                      Expanded(
                        child: RegisterForm(
                          formKey: widget.formKey,
                          nameController: widget.nameController,
                          firstNameController: widget.firstNameController,
                          emailController: widget.emailController,
                          passwordController: widget.passwordController,
                          isAcceptedCGU: widget.isAcceptedCGU,
                          checkBoxCallback: _updateCGUState,
                          errorCodeCallback: _updateErrorCodeState,
                        ),
                      ),
                      Center(
                        child: _errorMessage(widget.error),
                      )
                    ],
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                Flexible(flex: 2, child: _footerBuilder()),
              ],
            ),
          );
  }

  Container _headerBuilder() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text(
            "Créez un compte",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Color(0xff3D5382),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "Bienvenue ! Créez un compte pour commencer votre discussion.",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Color(0x993D5382),
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Container _footerBuilder() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CTAButton(
              onPressed: () async {
                if (widget.formKey.currentState?.validate() == true &&
                    widget.isAcceptedCGU) {
                  setState(() {
                    widget.loading = true;
                  });
                  var name = widget.nameController.value.text;
                  var firstname = widget.firstNameController.value.text;
                  var password = widget.passwordController.value.text;
                  var email = widget.emailController.value.text;

                  dynamic result = await widget._auth
                      .registerInWithEmailAndPassword(
                          name, firstname, email, password)
                      .then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }).onError((AppException error, stackTrace) {
                    setState(() {
                      widget.loading = false;
                      widget.error = (error.message != null)
                          ? error.message!
                          : "Une erreur est survenue";
                    });
                  });
                } else {
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
              },
              content: const Text(
                "Enregistrement",
                style: TextStyle(color: Colors.white, fontSize: 22),
              )),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text(
                "Vous avez déjà un compte?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff3D5382),
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ))
        ],
      ),
    );
  }

  Text _errorMessage(String errorMessage) {
    return Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: errorMessageColor,
          fontSize: 16,
          fontWeight: FontWeight.normal),
    );
  }
}
