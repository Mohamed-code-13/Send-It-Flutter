import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:send_it/screens/main_screen.dart';
import 'package:send_it/screens/signup_screen.dart';
import 'package:send_it/widgets/custom_submit_button.dart';

import '../services/auth/authentication.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/show_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;

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
                _getLoginMsg(context),
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
                  title: 'Login',
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

  Widget _getLoginMsg(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            "Please login to your account",
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
          "Don't have an account? ",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        GestureDetector(
          onTap: () {
            Get.to(
              () => const SignUpScreen(),
              transition: Transition.fadeIn,
            );
          },
          child: Text(
            "Sign up",
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

      bool res = _checkInputFields(context);
      if (res == false) return;

      setState(() {
        HUD = true;
      });

      String msg = await Authentication.loginOldUser(email!, password!);
      setState(() {
        HUD = false;
      });

      if (msg == 'Login Successfully') {
        Get.off(
          () => MainScreen(),
          transition: Transition.fadeIn,
        );
      } else {
        showSnackBar(
          scaffoldMessenger,
          msg,
          Colors.red,
        );
      }
    }
  }

  bool _checkInputFields(BuildContext context) {
    String? msg;
    if (email == null) {
      msg = "You should enter a valid email";
    } else if (password == null) {
      msg = "You should enter a valid password";
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
