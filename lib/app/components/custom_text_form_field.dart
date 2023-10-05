import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/widgets_scale_extension.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool? readyOnly;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String?)? onFieldSubmitted;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final int? maxLines;
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? prefixIconOnTap;
  final InputBorder? inputBorder;
  final TextStyle? textStyle;
  final bool? filled;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.hintText,
    this.obscureText,
    this.textInputAction,
    this.textInputType,
    this.readyOnly,
    this.inputFormatters,
    this.validator,
    this.onFieldSubmitted,
    this.prefixIconPath,
    this.suffixIconPath,
    this.onChanged,
    this.focusNode,
    this.onTap,
    this.maxLines,
    this.textAlignVertical,
    this.prefixIconOnTap,
    this.inputBorder,
    this.textStyle,
    this.filled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      readOnly: readyOnly ?? false,
      textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
      cursorColor: Theme.of(context).colorScheme.onSecondary,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: paddingM, horizontal: paddingM),
          enabledBorder: filled != null
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radiusXXXS),
                  borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.outline),
                )
              : inputBorder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusXXXS),
          ),
          fillColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
          filled: filled ?? true,
          suffixIcon: suffixIconPath != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    suffixIconPath!,
                    height: 24.horizontalScale,
                    width: 24.horizontalScale,
                  ),
                )
              : null,
          suffixIconConstraints: BoxConstraints(
              maxHeight: 40.horizontalScale,
              maxWidth: 40.horizontalScale,
              minHeight: 40.horizontalScale,
              minWidth: 40.horizontalScale),
          prefixIcon: prefixIconPath != null
              ? Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: prefixIconOnTap,
                    child: SvgPicture.asset(
                      prefixIconPath!,
                      height: 24.horizontalScale,
                      width: 24.horizontalScale,
                    ),
                  ),
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            maxHeight: 40.horizontalScale,
            maxWidth: 40.horizontalScale,
            minHeight: 40.horizontalScale,
            minWidth: 40.horizontalScale,
          ),
          hintText: hintText,
          hintStyle: s12W400Dark.copyWith(color: Colors.grey)),
      style: textStyle ?? s14W600Dark,
      validator: validator,
    );
  }
}
