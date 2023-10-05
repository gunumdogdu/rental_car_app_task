import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/widgets_scale_extension.dart';
import 'package:flutter_base_project/app/theme/color/app_colors.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final String? Function(String?)? validator;
  final void Function(String) onTapDropdownValue;
  final String hintText;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onTapDropdownValue,
    this.selectedValue,
    this.validator,
    required this.hintText,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          validator: widget.validator,
          style: s16W500Dark,
          controller: TextEditingController(text: widget.selectedValue),
          readOnly: true,
          onTap: () => setState(() {
            _isTapped = !_isTapped;
          }),
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: widget.hintText,
            suffixIcon: Padding(
                padding: const EdgeInsets.only(right: paddingM),
                child: Transform.flip(
                    flipY: _isTapped ? true : false, child: Icon(Icons.chevron_right, size: 24.horizontalScale))),
            suffixIconConstraints: BoxConstraints(
                maxHeight: 40.horizontalScale,
                maxWidth: 40.horizontalScale,
                minHeight: 40.horizontalScale,
                minWidth: 40.horizontalScale),
            focusedBorder: OutlineInputBorder(
                borderRadius: !_isTapped
                    ? BorderRadius.circular(paddingS)
                    : const BorderRadius.only(topLeft: Radius.circular(paddingS), topRight: Radius.circular(paddingS)),
                borderSide: BorderSide(width: 2, color: AppColors.primary)),
            enabledBorder: OutlineInputBorder(
              borderRadius: !_isTapped
                  ? BorderRadius.circular(paddingS)
                  : const BorderRadius.only(topLeft: Radius.circular(paddingS), topRight: Radius.circular(paddingS)),
              borderSide: BorderSide(width: 2, color: AppColors.azureishWhite),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: !_isTapped
                  ? BorderRadius.circular(paddingS)
                  : const BorderRadius.only(topLeft: Radius.circular(paddingS), topRight: Radius.circular(paddingS)),
              borderSide: BorderSide(width: 2, color: AppColors.red),
            ),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.red)),
            disabledBorder: OutlineInputBorder(
              borderRadius: !_isTapped
                  ? BorderRadius.circular(paddingS)
                  : const BorderRadius.only(topLeft: Radius.circular(paddingS), topRight: Radius.circular(paddingS)),
              borderSide: BorderSide(width: 2, color: AppColors.red),
            ),
          ),
        ),

        /// Dropdown Items
        _isTapped && widget.items.isNotEmpty
            ? DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  color: AppColors.azureishWhite,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(radiusM),
                    bottomRight: Radius.circular(radiusM),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingM, horizontal: paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.items.length,
                      (index) => InkWell(
                        onTap: () {
                          widget.onTapDropdownValue(widget.items[index]);
                          setState(() => _isTapped = !_isTapped);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: paddingXS),
                          child: Text(widget.items[index], style: s16W400Dark),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
