import 'package:flutter/material.dart';
import 'package:jamal_rahnamaie/pages/userlogin/login_page.dart';
import 'package:jamal_rahnamaie/pages/userlogin/sign_up.dart';

class LoaginSignUp extends StatefulWidget {
  @override
  State<LoaginSignUp> createState() => _LoaginSignUpState();
}

class _LoaginSignUpState extends State<LoaginSignUp> {
  bool isLogin = true;

  void togglePage() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: LoginPage(
          onPressed: togglePage,
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SignUp(
          onPressed: togglePage,
        ),
      );
    }
  }
}
