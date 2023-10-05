import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/components/listing_info_tile.dart';
import 'package:flutter_base_project/app/constants/enum/loading_status_enum.dart';
import 'package:flutter_base_project/app/constants/other/padding_and_radius_size.dart';
import 'package:flutter_base_project/app/extensions/widgets_scale_extension.dart';
import 'package:flutter_base_project/app/libs/app/size_config.dart';
import 'package:flutter_base_project/app/model/request/create_car_listing_request_model.dart';
import 'package:flutter_base_project/app/theme/color/app_colors.dart';
import 'package:flutter_base_project/app/theme/text_style/text_style.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/listing_detail_controller.dart';

class ListingDetail extends GetView<ListingDetailController> {
  const ListingDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateCarListingRequestModel? findCarListingById(int id) {
      return controller.carListings.firstWhere((listing) => listing.id == id);
    }

    return Scaffold(
      key: controller.scaffoldKey,
      body: Obx(
        () => controller.loadingStatus != LoadingStatus.Loaded
            ? const SizedBox.shrink()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: controller.id,
                          child: CachedNetworkImage(
                            imageUrl: 'https://thispersondoesnotexist.com/',
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenWidth,
                          ),
                        ),
                        Positioned(
                          top: 80.horizontalScale,
                          left: paddingXL,
                          child: CircleAvatar(
                            backgroundColor: AppColors.azureishWhite,
                            radius: 20.horizontalScale,
                            child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.cancel)),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(paddingXL),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            findCarListingById(controller.id)?.name ?? 'Not Found',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: s26W600Dark,
                          ),
                          const SizedBox(height: paddingM),
                          ListingInfoTile(
                            icon: Icons.abc,
                            text: '\$ ${findCarListingById(controller.id)!.price}',
                            textStyle: s14W400Dark,
                          ),
                          const SizedBox(height: paddingXS),
                          ListingInfoTile(
                            icon: Icons.abc,
                            text: controller.addresses[controller.id] ?? 'Address not found',
                            textStyle: s14W300Dark,
                          ),
                          const SizedBox(height: paddingXS),
                          ListingInfoTile(
                            icon: Icons.abc,
                            text: findCarListingById(controller.id)?.availability ?? 'Not Found',
                            textStyle: s14W300Dark,
                          ),
                          const Divider(height: paddingXXXXXL),
                          SizedBox(
                            height: 200.horizontalScale,
                            width: double.infinity,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(findCarListingById(controller.id)!.latitude!,
                                    findCarListingById(controller.id)!.longitude!),
                                zoom: 12.0,
                              ),
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                              },
                              markers: Set.from(controller.markers),
                              myLocationEnabled: true,
                              scrollGesturesEnabled: true,
                              myLocationButtonEnabled: false,
                              onMapCreated: (GoogleMapController e) async {
                                controller.setMapController(e);
                                controller.mapController = e;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: kBottomNavigationBarHeight * 1.6,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
