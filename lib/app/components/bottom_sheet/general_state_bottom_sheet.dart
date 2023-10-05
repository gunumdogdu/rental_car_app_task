import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/components/button/base_button.dart';
import 'package:flutter_base_project/app/components/card/bottom_sheet_typed_card.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/widget_extension.dart';
import 'package:flutter_base_project/app/libs/app/size_config.dart';
import 'package:flutter_base_project/app/theme/color/app_colors.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';

import 'bottom_sheet_widget.dart';

class GeneralStateBottomSheet<T> extends BottomSheetWidget<T> {
  final VoidCallback onTapFirstBtn;
  final VoidCallback? onTapSecondBtn;
  final String title;
  final String subtitle;
  final String firstBtnText;
  final String? secondBtnText;
  final bool isSecondBtnVisible;
  final String svgPath;
  const GeneralStateBottomSheet(
      {Key? key,
      required this.onTapFirstBtn,
      this.isSecondBtnVisible = true,
      this.onTapSecondBtn,
      required this.firstBtnText,
      this.secondBtnText,
      required this.title,
      required this.subtitle,
      required this.svgPath})
      : super(key: key, useRootNavigator: true, isScrollControlled: true, enableDrag: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: paddingXXXXXXXL),
              Expanded(child: Image.asset(svgPath)),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: BottomSheetTypedCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: paddingXS, vertical: paddingXL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: s26W500Dark,
                            ),
                            const SizedBox(height: paddingXS),
                            Text(
                              subtitle,
                              style: s16W500Dark,
                            ),
                            const Spacer(),
                            BaseButton(onPressed: onTapFirstBtn, text: firstBtnText),
                            Padding(
                              padding: const EdgeInsets.only(top: paddingXXXS),
                              child: BaseButton(onPressed: onTapSecondBtn ?? () {}, text: secondBtnText ?? ''),
                            ).isVisible(isSecondBtnVisible),
                            SizedBox(
                              height: SizeConfig.safeAreaPadding.bottom,
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
