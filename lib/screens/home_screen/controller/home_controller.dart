import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/animation/bottom_to_top_page_route.dart';
import 'package:flutter_base_project/app/constants/enum/cache_key_enum.dart';
import 'package:flutter_base_project/app/constants/enum/loading_status_enum.dart';
import 'package:flutter_base_project/app/libs/locale_manager/locale_manager.dart';
import 'package:flutter_base_project/app/mixin/state_bottom_sheet_mixin.dart';
import 'package:flutter_base_project/app/model/request/create_car_listing_request_model.dart';
import 'package:flutter_base_project/app/navigation/route/route.dart';
import 'package:flutter_base_project/app/navigation/route/route_factory.dart';
import 'package:flutter_base_project/screens/listing_detail_screen/listing_detail_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/components/dialog/loading_progress.dart';

class HomeController extends GetxController with StateBottomSheetMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext get context => scaffoldKey.currentContext!;

  final LocaleManager localeManager = LocaleManager.instance;

  final Rx<List<CreateCarListingRequestModel>> _carListings = Rx([]);
  final Rx<List<String>> _addresses = Rx([]);
  final Rx<LoadingStatus> _loadingStatus = Rx(LoadingStatus.Init);

  List<String> get addresses => _addresses.value;
  set addresses(List<String> value) {
    _addresses.firstRebuild = true;
    _addresses.value = value;
  }

  LoadingStatus get loadingStatus => _loadingStatus.value;
  set loadingStatus(LoadingStatus value) => _loadingStatus.value = value;

  List<CreateCarListingRequestModel> get carListings => _carListings.value;
  set carListings(List<CreateCarListingRequestModel> value) {
    _carListings.firstRebuild = true;
    _carListings.value = value;
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      loadingStatus = LoadingStatus.Loading;
      LoadingProgress.start();
      await loadListingsFromLocal();
      LoadingProgress.stop();
      loadingStatus = LoadingStatus.Loaded;
    } catch (e) {
      LoadingProgress.stop();
      loadingStatus = LoadingStatus.Error;
      showErrorStateBottomSheet(message: e.toString(), onTapFirstBtn: onTapTryAgain);
    }
  }

  void onTapTryAgain() {
    Navigator.pop(context);
    onReady();
  }

  Future<void> saveListingsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('carListings', json.encode(carListings.map((listing) => listing.toJson()).toList()));
  }

  void addAndSaveListing(CreateCarListingRequestModel newListing) {
    carListings.add(newListing);
    saveListingsToStorage();
  }

  void onTapFloating() => Navigator.pushNamed(MyRouteFactory.context, MainScreensEnum.addListingScreen.path);

  Future<void> loadListingsFromLocal() async {
    carListings = localeManager
        .getStringListValue(CacheKey.cars)
        .map((e) => CreateCarListingRequestModel.fromJson(jsonDecode(e)))
        .toList();
    await fetchLocationNamesForEvents(carListings);
  }

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return placemark.name ?? '';
      }
    } catch (e) {
      log('Error getting location');
    }
    return 'Unknown location';
  }

  Future<void> fetchLocationNamesForEvents(List<CreateCarListingRequestModel> listings) async {
    List<String> names = [];
    for (var listing in listings) {
      try {
        String locationName = await getAddressFromCoordinates(listing.latitude!, listing.longitude!);
        names.add(locationName);
      } catch (e) {
        log('Error fetching location name for listing: ${listing.name}, Error: $e');
        names.add('Unknown Location');
      }
    }
    addresses = names;
    log('Addresses after conversion: $addresses');
  }

  void onTapListing(int id) {
    Navigator.of(context).push(BottomToTopPageRoute(
        builder: (context) {
          return const ListingDetailScreen();
        },
        settings: RouteSettings(arguments: id)));
  }
}
