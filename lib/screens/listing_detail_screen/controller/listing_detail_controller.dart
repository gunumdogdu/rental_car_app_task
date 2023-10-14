// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_base_project/app/components/dialog/loading_progress.dart';
import 'package:flutter_base_project/app/constants/enum/cache_key_enum.dart';
import 'package:flutter_base_project/app/constants/enum/loading_status_enum.dart';
import 'package:flutter_base_project/app/libs/locale_manager/locale_manager.dart';
import 'package:flutter_base_project/app/mixin/state_bottom_sheet_mixin.dart';
import 'package:flutter_base_project/app/model/request/create_car_listing_request_model.dart';
import 'package:flutter_base_project/core/services/firestore_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListingDetailController extends GetxController
    with StateBottomSheetMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  BuildContext get context => scaffoldKey.currentContext!;

  final LocaleManager localeManager = LocaleManager.instance;

  final Rx<LoadingStatus> _loadingStatus = Rx(LoadingStatus.Init);
  final Rx<List<CreateCarListingRequestModel>> _carListings = Rx([]);
  final Rx<CreateCarListingRequestModel> _listingDetail =
      Rx(CreateCarListingRequestModel());
  late GoogleMapController mapController;
  final markers = <Marker>{}.obs;

  final RxMap<String, String> _addresses = RxMap<String, String>();
  Map<String, String> get addresses => _addresses;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  set loadingStatus(LoadingStatus value) => _loadingStatus.value = value;

  CreateCarListingRequestModel get listingDetail => _listingDetail.value;
  set listingDetail(CreateCarListingRequestModel value) =>
      _listingDetail.value = value;

  List<CreateCarListingRequestModel> get carListings => _carListings.value;
  set carListings(List<CreateCarListingRequestModel> value) {
    _carListings.firstRebuild = true;
    _carListings.value = value;
  }

  final String id;
  ListingDetailController({required this.id});

  @override
  void onReady() async {
    super.onReady();
    try {
      loadingStatus = LoadingStatus.Loading;
      LoadingProgress.start();
      carListings = await General().getAllListingsFromFirestore();
      final selectedListing = findCarListingById(id);
      await fetchLocationNamesForEvents(carListings);

      if (selectedListing != null) {
        markers.value = {createMarker(selectedListing)};
      }
      LoadingProgress.stop();
      loadingStatus = LoadingStatus.Loaded;
    } catch (e) {
      LoadingProgress.stop();
      loadingStatus = LoadingStatus.Error;
      showErrorStateBottomSheet(
          message: e.toString(), onTapFirstBtn: onTapTryAgain);
    }
  }

  void onTapTryAgain() {
    Navigator.pop(context);
    onReady();
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return placemark.name ?? '';
      }
    } catch (e) {
      log('Error getting location');
    }
    return 'Unknown location';
  }

  Future<void> fetchLocationNamesForEvents(
      List<CreateCarListingRequestModel> listings) async {
    for (var listing in listings) {
      try {
        String locationName = await getAddressFromCoordinates(
            listing.latitude!, listing.longitude!);
        addresses[listing.id!] = locationName;
      } catch (e) {
        log('Error fetching location name for listing: ${listing.name}, Error: $e');
        addresses[listing.id!] = 'Unknown Location';
      }
    }
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  CreateCarListingRequestModel? findCarListingById(String id) {
    return carListings.firstWhere((listing) => listing.id == id);
  }

  Marker createMarker(CreateCarListingRequestModel listing) {
    return Marker(
      markerId: MarkerId(listing.id.toString()),
      position: LatLng(listing.latitude!, listing.longitude!),
      infoWindow: InfoWindow(title: listing.name),
    );
  }
}
