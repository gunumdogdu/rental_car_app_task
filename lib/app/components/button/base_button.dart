import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';

class BaseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const BaseButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingM),
          child: Text(text),
        ),
      ),
    );
  }
}
