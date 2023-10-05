import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';

class BottomSheetTypedCard extends StatelessWidget {
  final Widget child;
  final double? borderRadius;

  BottomSheetTypedCard({this.borderRadius, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius ?? radiusXXL),
              topRight: Radius.circular(borderRadius ?? radiusXXL),
            ),
          ),
          child: child),
    );
  }
}
