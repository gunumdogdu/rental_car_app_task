import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/components/button/base_button.dart';
import 'package:flutter_base_project/app/components/custom_drop_down.dart';
import 'package:flutter_base_project/app/components/custom_text_form_field.dart';
import 'package:flutter_base_project/app/constants/app/app_constant.dart';
import 'package:flutter_base_project/app/constants/enum/loading_status_enum.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/validation_extension.dart';
import 'package:flutter_base_project/app/extensions/widgets_scale_extension.dart';
import 'package:flutter_base_project/app/model/request/create_car_listing_request_model.dart';
import 'package:flutter_base_project/app/model/request/place_result_model.dart';
import 'package:flutter_base_project/app/navigation/route/route.dart';
import 'package:flutter_base_project/app/theme/color/app_colors.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../controller/add_listing_controller.dart';

part '../components/maps_listing.dart';

class AddListing extends GetView<AddListingController> {
  const AddListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loadingStatus != LoadingStatus.Loaded
          ? const SizedBox.shrink()
          : GestureDetector(
              onTap: controller.unfocus,
              child: Scaffold(
                key: controller.scaffoldKey,
                appBar: AppBar(
                  title: const Text('Add new listing'),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingL, vertical: paddingL),
                    child: Form(
                      key: controller.fKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: controller.onTapAddEventCover,
                            child: SizedBox(
                              width: double.infinity,
                              height: 214.horizontalScale,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.azureishWhite,
                                    borderRadius:
                                        BorderRadius.circular(radiusM),
                                    image: controller.selectedImage == null
                                        ? null
                                        : DecorationImage(
                                            image: FileImage(
                                              controller.selectedImage!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  child: controller.selectedImage == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              size: 24.horizontalScale,
                                              color: AppColors.primary,
                                            ),
                                            Text(
                                              'Add Photo',
                                              style: s15W500Dark,
                                            )
                                          ],
                                        )
                                      : const SizedBox.shrink()),
                            ),
                          ),
                          const SizedBox(height: paddingM),
                          Text('Model', style: s14W600Dark),
                          const SizedBox(height: paddingXS),
                          CustomTextFormField(
                            controller: controller.cModel,
                            textInputAction: TextInputAction.next,
                            validator: (_) =>
                                controller.cModel.text.isNotEmptyController(),
                            hintText: '(Toyota Corolla, Automatic, 2016)',
                          ),
                          const SizedBox(height: paddingM),
                          Text('Price', style: s14W600Dark),
                          const SizedBox(height: paddingXS),
                          CustomTextFormField(
                            controller: controller.cPrice,
                            textInputAction: TextInputAction.next,
                            textInputType:
                                const TextInputType.numberWithOptions(),
                            validator: (_) => controller.cPrice.text
                                .replaceAll(',', '.')
                                .isValidPrice(),
                            hintText: ' \$25',
                          ),
                          const SizedBox(height: paddingM),
                          Text('Avaliablity', style: s14W600Dark),
                          const SizedBox(height: paddingXS),
                          CustomDropdown(
                            items: avaliablityList,
                            validator: controller.avaliabilityValidator,
                            selectedValue: controller.avaliability,
                            onTapDropdownValue: controller.onTapDropdownValue,
                            hintText: '',
                          ),
                          const SizedBox(height: paddingM),
                          Text(
                            'Choose location on map',
                            style: s14W500Dark,
                          ),
                          const SizedBox(height: paddingM),
                          _Maps(
                            controller: controller,
                          ),
                          const SizedBox(height: paddingM),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: paddingL),
                            child: BaseButton(
                              onPressed: () async =>
                                  await controller.saveListing(),
                              text: 'Save Listing',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
