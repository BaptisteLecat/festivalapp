import 'package:flutter/material.dart';
import 'package:festivalapp/views/auth/Login/components/password_handler.dart';
import 'package:festivalapp/views/auth/Register/components/CGU.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController firstNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<String> errorCodeCallback;
  final ValueChanged<bool> checkBoxCallback;
  bool isAcceptedCGU;
  RegisterForm(
      {Key? key,
      required this.formKey,
      required this.nameController,
      required this.firstNameController,
      required this.emailController,
      required this.passwordController,
      required this.isAcceptedCGU,
      required this.checkBoxCallback,
      required this.errorCodeCallback})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  void dispose() {
    super.dispose();
  }

  ///This function will be given to the child widget. It will update the value troughout the function.
  _updateCGUState(bool isAcceptedCGU) {
    setState(() {
      widget.isAcceptedCGU = isAcceptedCGU;
    });
    widget.checkBoxCallback(isAcceptedCGU);
  }

  ///This function will be given to the child widget. It will update the value troughout the function.
  _updateErrorCodeState(String errorCode) {
    setState(() {
      widget.errorCodeCallback(errorCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: widget.nameController,
                    autofocus: true,
                    cursorColor: const Color(0xff3D5382),
                    style: TextStyle(
                      color: const Color(0xff3D5382),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _inputDecorationBuilder(hintText: 'Nom d\'utilisateur'),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          /** Section for the Email */
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
          /** End Section Email */

          const SizedBox(
            height: 10,
          ),
          PasswordHandler(passwordController: widget.passwordController),
          const SizedBox(
            height: 10,
          ),
          CGU(
            isAcceptedCGU: widget.isAcceptedCGU,
            checkBoxCallback: _updateCGUState,
            errorCodeCallback: _updateErrorCodeState,
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecorationBuilder({required String hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xffEEEEEE),
      hintText: hintText,
      hintStyle: TextStyle(
        color: const Color(0x993D5382),
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: 1.5,
          color: const Color(0xffC5CCDA),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: 1.5,
          color: const Color(0xff3D5382),
        ),
      ),
    );
  }
}
