import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart' show BuildContext, FocusScope;

extension CheckInternetExtension on BuildContext {
  
  
  
  Future<bool> isInternetAvaible() async {
    try {
      const String checkInternetURL = 'google.com';
      //  ignore: unused_field
      final result = await InternetAddress.lookup(checkInternetURL);
      final isActive = result.isNotEmpty && result[0].rawAddress.isNotEmpty ? true : false;
      return isActive;
    } on SocketException catch (_) {
      return false;
    }
  }

  void unFocus() => FocusScope.of(this).unfocus();
}