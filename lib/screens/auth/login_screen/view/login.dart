import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/components/button/base_button.dart';
import 'package:flutter_base_project/app/components/custom_text_form_field.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/validation_extension.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';
import 'package:flutter_base_project/core/i10n/i10n.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';

class Login extends GetView<LoginController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.unfocus,
      child: Scaffold(
        key: controller.scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(paddingXL),
          child: Form(
            key: controller.fKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 300),
                  Text(AppLocalization.getLabels.email, style: s20W300Dark),
                  const SizedBox(height: paddingXS),
                  CustomTextFormField(
                    controller: controller.cEmail,
                    validator: (_) => controller.cEmail.text.isMail(),
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: paddingS),
                  Text(AppLocalization.getLabels.password, style: s20W300Dark),
                  const SizedBox(height: paddingXS),
                  CustomTextFormField(
                    controller: controller.cPassword,
                    validator: (_) =>
                        controller.cPassword.text.isNotEmptyController(),
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                    onFieldSubmitted: (_) =>
                        controller.onTapLoginWithEmailPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: paddingXL),
                  BaseButton(
                      onPressed: controller.onTapLoginWithEmailPassword,
                      text: AppLocalization.getLabels.login)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
