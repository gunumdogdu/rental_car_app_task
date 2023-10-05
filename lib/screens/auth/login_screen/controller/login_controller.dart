import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/constants/enum/cache_key_enum.dart';
import 'package:flutter_base_project/app/controllers/general/session_service.dart'; // Import your SessionService
import 'package:flutter_base_project/app/libs/locale_manager/locale_manager.dart';
import 'package:flutter_base_project/app/model/response/auth/user_info_model.dart';
import 'package:flutter_base_project/app/navigation/route/route.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final SessionService _sessionService = Get.find<SessionService>(); // Get the SessionService instance
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> fKey = GlobalKey<FormState>();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cPassword = TextEditingController();

  BuildContext get context => scaffoldKey.currentContext!;

  void unfocus() => FocusScope.of(context).unfocus();

  Future<void> onTapLoginWithEmailPassword() async {
    if (fKey.currentState!.validate()) {
      String enteredEmail = cEmail.text;
      String enteredPassword = cPassword.text;

      Map<String, dynamic> loginRequest = {
        "email": enteredEmail,
        "password": enteredPassword,
      };

      // Simulating a successful login
      GetUserInfoModel userInfoModel = GetUserInfoModel(
        complete: true,
        data: UserInfoModel(
          id: 1,
          firstName: 'admin',
          lastName: 'admin',
          email: 'admin@admin.admin',
          mobilePhone: '1234567890',
        ),
        token: 'admin',
      );

      if (userInfoModel.complete == true) {
        showSnackbar('Login successful', Colors.green);

        try {
          // Save login status to LocaleManager
          await LocaleManager.instance.setBoolValue(CacheKey.loggedIn, true);

          // Save login status and user info to SessionService
          await _sessionService.logIn(userInfoModel);

          // Navigate to the home screen
          Navigator.pushReplacementNamed(context, MainScreensEnum.homeScreen.path);
        } catch (e) {
          print('Error logging in: $e');
        }
      } else {
        showSnackbar('Invalid credentials', Colors.red);
      }
    }
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
