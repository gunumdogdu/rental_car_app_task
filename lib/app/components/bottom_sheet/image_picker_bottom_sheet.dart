import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/components/button/base_button.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';

import 'bottom_sheet_widget.dart';

class ImagePickerBottomSheet<T> extends BottomSheetWidget<T> {
  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;
  const ImagePickerBottomSheet({
    Key? key,
    required this.onTapCamera,
    required this.onTapGallery,
  }) : super(
          key: key,
          useRootNavigator: true,
          isScrollControlled: true,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingXL, vertical: paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseButton(
              text: 'Take photo',
              onPressed: onTapCamera,
            ),
            const SizedBox(height: paddingXL),
            BaseButton(
              text: 'Choose from gallery',
              onPressed: onTapGallery,
            ),
          ],
        ),
      ),
    );
  }
}
