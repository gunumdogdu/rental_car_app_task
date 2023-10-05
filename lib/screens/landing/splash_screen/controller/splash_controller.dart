import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_project/app/constants/enum/cache_key_enum.dart';
import 'package:flutter_base_project/app/controllers/general/session_service.dart';
import 'package:flutter_base_project/app/libs/locale_manager/locale_manager.dart';
import 'package:flutter_base_project/app/navigation/route/route.dart';
import 'package:flutter_base_project/app/navigation/route/route_factory.dart';
import 'package:flutter_base_project/core/i10n/i10n.dart';
import 'package:flutter_base_project/firebase_options.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../app/components/message/error_message_dialog.dart';

class SplashController extends GetxController {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
    ready();
  }

  BuildContext get context => scaffoldKey.currentContext!;

  Future<void> init() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // log("FCMToken $fcmToken");

    /// telefonu çevirdiğimiz de sayfanın rotate olmaması için eklendi.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> ready() async {
    final context = scaffoldKey.currentContext!;
    final future = Future.delayed(const Duration(seconds: 2));
    final sessionService = Get.put(SessionService());

    // LocaleManager.instance.clearAll();
    future.whenComplete(() async {
      try {
        await authenticateWithBiometrics();

        bool isLogin = LocaleManager.instance.getBoolValue(CacheKey.loggedIn) ?? false;

        if (isLogin) {
          Navigator.pushNamedAndRemoveUntil(MyRouteFactory.context, MainScreensEnum.homeScreen.path, (route) => false);
        } else {
          if (sessionService.isUserLogin()) {
            Navigator.pushNamedAndRemoveUntil(context, MainScreensEnum.homeScreen.path, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, MainScreensEnum.loginScreen.path, (route) => false);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
        tryAgainMessage(AppLocalization.getLabels.defaultErrorMessage);
      }
    });
  }

  Future<void> authenticateWithBiometrics() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    final bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    if (canCheckBiometrics) {
      final bool isBiometricSupported = await localAuth.isDeviceSupported();
      if (isBiometricSupported) {
        try {
          final bool isAuthenticated = await localAuth.authenticate(
            options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: true),
            localizedReason: 'Authenticate with Face ID',
          );

          if (!isAuthenticated) {
            throw Exception('Biometric authentication failed.');
          }
        } catch (e) {
          throw Exception('Biometric authentication error: $e');
        }
      } else {
        throw Exception('Biometrics not supported on this device.');
      }
    } else {
      throw Exception('Biometrics not available.');
    }
  }

  /// Tekrar yükle popup
  tryAgainMessage(String message) {
    ErrorMessageDialog(
      text: message,
      buttonText: AppLocalization.getLabels.tryAgainBtnText,
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop();
        ready();
      },
    ).show(barrierDismissible: false);
  }
}
