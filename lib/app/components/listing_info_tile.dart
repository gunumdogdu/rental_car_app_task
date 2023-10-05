import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/widgets_scale_extension.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';

class ListingInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle? textStyle;
  const ListingInfoTile({
    super.key,
    required this.icon,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.horizontalScale),
        const SizedBox(width: paddingXS),
        Flexible(
          child: Text(
            text,
            style: textStyle ?? s12W300Dark,
          ),
        ),
      ],
    );
  }
}
