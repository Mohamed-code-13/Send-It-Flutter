import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:send_it/services/auth/authentication.dart';
import 'package:send_it/widgets/custom_submit_button.dart';
import 'package:send_it/widgets/show_snack_bar.dart';

import '../widgets/custom_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? username;
  String? password;

  GlobalKey<FormState> _globalKey = GlobalKey();

  bool HUD = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: HUD,
          child: Form(
            key: _globalKey,
            child: ListView(
              children: [
                _getLogo(),
                _getSignInMsg(context),
                CustomInputField(
                  label: 'Username',
                  hintText: 'Enter your username',
                  onChanged: (String val) => username = val,
                ),
                CustomInputField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  onChanged: (String val) => email = val,
                ),
                CustomInputField(
                  label: 'Password',
                  hintText: 'Enter your Password',
                  obscure: true,
                  onChanged: (String val) => password = val,
                ),
                CustomSubmitButton(
                  title: 'Sign Up',
                  onTap: () => _onSumbit(context),
                ),
                _switchToSignUpScreen(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLogo() {
    return Image.asset(
      'assets/logo.jpg',
      height: MediaQuery.of(context).size.height * 0.35,
    );
  }

  Widget _getSignInMsg(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "Create a new account",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _switchToSignUpScreen(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Text(
            "Login",
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSumbit(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

      email = email!.trim();
      username = username!.trim();

      bool res = _checkInputFields(context);
      if (res == false) return;

      setState(() {
        HUD = true;
      });

      String msg = await Authentication.registerNewUser(
        email!,
        password!,
        username!,
      );

      setState(() {
        HUD = false;
      });

      showSnackBar(
        scaffoldMessenger,
        msg,
        (msg[0] == 'R') ? Colors.green : Colors.red,
      );
    }
  }

  bool _checkInputFields(BuildContext context) {
    String? msg;
    if (email == null) {
      msg = "You should enter a valid email";
    } else if (password == null) {
      msg = "You should enter a valid password";
    } else if (username == null) {
      msg = "You should enter a valid username";
    }

    if (msg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
      return false;
    }
    return true;
  }
}
