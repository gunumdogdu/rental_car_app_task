import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/constants/assets/assets.dart';
import 'package:flutter_base_project/app/navigation/route/route_factory.dart';

import '../components/bottom_sheet/general_state_bottom_sheet.dart';

mixin StateBottomSheetMixin {
  Future<void> showErrorStateBottomSheet(
      {required String message, VoidCallback? onTapFirstBtn, String? firstBtnText, String? title}) async {
    await GeneralStateBottomSheet(
      onTapFirstBtn: onTapFirstBtn ?? () => Navigator.pop(MyRouteFactory.context),
      firstBtnText: firstBtnText ?? 'Try Again',
      title: title ?? 'An Error Occured',
      subtitle: message,
      svgPath: myLocationImage,
      isSecondBtnVisible: false,
    ).showBottomSheet(context: MyRouteFactory.context);
  }

  Future<void> showSuccessStateBottomSheet({String? message, String? title, VoidCallback? onTapFirstBtn}) async {
    await GeneralStateBottomSheet(
            isSecondBtnVisible: false,
            onTapFirstBtn: onTapFirstBtn ?? () => Navigator.pop(MyRouteFactory.context),
            firstBtnText: 'Done',
            title: title ?? 'Well done!',
            subtitle: message ?? 'Update succesfully completed.',
            svgPath: myLocationImage)
        .showBottomSheet(context: MyRouteFactory.context);
  }

  Future<void> showTwoOptionSuccessStateBottomSheet(
      {String? firstBtnText,
      String? secondBtnText,
      String? message,
      VoidCallback? onTapFirstBtn,
      VoidCallback? onTapSecondBtn}) async {
    await GeneralStateBottomSheet(
            isSecondBtnVisible: true,
            onTapFirstBtn: onTapFirstBtn ?? () => Navigator.pop(MyRouteFactory.context),
            firstBtnText: firstBtnText ?? 'Done',
            secondBtnText: secondBtnText ?? 'Back',
            onTapSecondBtn: onTapSecondBtn ?? () => Navigator.pop(MyRouteFactory.context),
            title: 'Well done!',
            subtitle: message ?? 'Succesfully completed.',
            svgPath: myLocationImage)
        .showBottomSheet(context: MyRouteFactory.context);
  }
}
