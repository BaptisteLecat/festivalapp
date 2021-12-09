import 'package:festivalapp/common/widgets/inputs/inputDecoration/advanced_decoration.dart';
import 'package:flutter/material.dart';
import 'package:festivalapp/common/constants/colors.dart';
import 'package:festivalapp/views/auth/login/components/password_handler.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  bool stayConnected = false;
  ValueChanged<bool> checkBoxCallback;
  LoginForm(
      {Key? key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.stayConnected,
      required this.checkBoxCallback})
      : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void dispose() {
    widget.emailController.dispose();
    widget.passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecorationBuilder({required String hintText}) {
    return AdvancedDecoration.inputDecoration(hintText: hintText);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: [
          Container(
            height: 60,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: widget.emailController,
              autofocus: true,
              cursorColor: const Color(0xff3D5382),
              style: TextStyle(
                color: const Color(0xff3D5382),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              decoration: _inputDecorationBuilder(hintText: 'Email'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          PasswordHandler(passwordController: widget.passwordController),
          const SizedBox(
            height: 10,
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "Mot de passe oublié",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: secondaryColor),
                ),
              )
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              FormField(
                builder: (state) {
                  return Checkbox(
                      activeColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: inputBorder),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      value: widget.stayConnected,
                      onChanged: (value) {
                        setState(() {
                          widget.stayConnected = value!;
                        });
                        widget.checkBoxCallback(widget.stayConnected);
                      });
                },
              ),
              Text(
                "Rester connecté",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: secondaryColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
