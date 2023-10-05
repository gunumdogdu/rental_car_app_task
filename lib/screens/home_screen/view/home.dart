import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/constants/enum/loading_status_enum.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/widgets_scale_extension.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';
import 'package:flutter_base_project/core/i10n/i10n.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        title: Text('${AppLocalization.getLabels.welcomeTo} RentalGO'),
      ),
      body: Obx(
        () => controller.loadingStatus != LoadingStatus.Loaded
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingL, horizontal: paddingL),
                child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          height: paddingM,
                        ),
                    itemCount: controller.carListings.length,
                    itemBuilder: (context, index) {
                      final item = controller.carListings[index];
                      return GestureDetector(
                        onTap: () => controller.onTapListing(item.id!),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusM)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: paddingXS, horizontal: paddingM),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(radiusM),
                                  child: Hero(
                                    tag: UniqueKey(),
                                    child: CachedNetworkImage(
                                      imageUrl: 'https://thispersondoesnotexist.com/',
                                      height: 130.horizontalScale,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.car_repair),
                                        const SizedBox(width: paddingXS),
                                        Flexible(
                                          child: Text(
                                            controller.carListings[index].name!,
                                            style: s14W500Dark,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: paddingM),
                                    Row(
                                      children: [
                                        const Icon(Icons.price_check_rounded),
                                        const SizedBox(width: paddingXS),
                                        Text('\$ ${controller.carListings[index].price}', style: s14W500Dark),
                                      ],
                                    ),
                                    const SizedBox(height: paddingM),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined),
                                        const SizedBox(width: paddingXS),
                                        Flexible(
                                            child: Text(
                                          controller.addresses[index],
                                          style: s14W500Dark,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onTapFloating,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
