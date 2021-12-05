import 'package:flutter/material.dart';
import 'package:shophouse/common/widgets/buttons/hidePassword_button.dart';
import 'package:shophouse/common/widgets/inputs/input_password.dart';

class PasswordHandler extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordHandler({Key? key, required this.passwordController})
      : super(key: key);

  @override
  _PasswordHandlerState createState() => _PasswordHandlerState();
}

class _PasswordHandlerState extends State<PasswordHandler> {
  bool hidePassword = true;
  late HidePasswordButton hidePasswordButton;

  @override
  void initState() {
    super.initState();
    hidePasswordButton =
        HidePasswordButton(callback: this._updatePasswordState);
  }

  @override
  dispose() {
    super.dispose();
  }

  ///This function will be given to the child widget. It will update the value troughout the function.
  _updatePasswordState(bool hidePassword) {
    setState(() {
      this.hidePassword = hidePassword;
      print(this.hidePassword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: viewportConstraints.maxWidth,
            ),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 5,
                    child: Container(
                      height: 60,
                      child: InputPassword(
                        controller: widget.passwordController,
                        hintText: "Mot de Passe",
                        hidePassword: this.hidePassword,
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 1,
                  child: hidePasswordButton,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
