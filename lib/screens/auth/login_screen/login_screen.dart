import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/login_controller.dart';
import 'view/login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginController(),
      builder: (_) => const Login(),
    );
  }
}