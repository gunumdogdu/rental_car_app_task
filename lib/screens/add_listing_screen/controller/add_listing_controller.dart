import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:flutter_base_project/app/components/bottom_sheet/image_picker_bottom_sheet.dart';
import 'package:flutter_base_project/app/components/dialog/loading_progress.dart';
import 'package:flutter_base_project/app/constants/assets/assets.dart';
import 'package:flutter_base_project/app/constants/enum/cache_key_enum.dart';
import 'package:flutter_base_project/app/constants/enum/loading_status_enum.dart';
import 'package:flutter_base_project/app/extensions/widget_extension.dart';
import 'package:flutter_base_project/app/extensions/widgets_scale_extension.dart';
import 'package:flutter_base_project/app/libs/locale_manager/locale_manager.dart';
import 'package:flutter_base_project/app/mixin/state_bottom_sheet_mixin.dart';
import 'package:flutter_base_project/app/model/request/create_car_listing_request_model.dart';
import 'package:flutter_base_project/app/model/request/place_result_model.dart';
import 'package:flutter_base_project/app/theme/color/app_colors.dart';
import 'package:flutter_base_project/screens/home_screen/controller/home_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../../../env.dart';

class AddListingController extends GetxController with StateBottomSheetMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> fKey = GlobalKey<FormState>();

  final LocaleManager localeManager = LocaleManager.instance;

  final TextEditingController cModel = TextEditingController();
  final TextEditingController cPrice = TextEditingController();
  final TextEditingController cAvaliablity = TextEditingController();
  final picker = ImagePicker();
  final Rx<File?> _selectedImage = Rx(null);
  PlaceResult? selectedPlace;

  RxSet<Marker> markers = <Marker>{}.obs;
  LatLng? currentLocation;
  Uint8List? customMarkerOwn;
  late GoogleMapController mapController;
  final Rx<List<CreateCarListingRequestModel>> _carListings = Rx([]);
  final Rx<String?> _avaliability = Rx(null);
  final Rx<LoadingStatus> _loadingStatus = Rx(LoadingStatus.Init);

  String? get avaliability => _avaliability.value;
  set avaliability(String? value) => _avaliability.value = value;

  BuildContext get context => scaffoldKey.currentContext!;

  File? get selectedImage => _selectedImage.value;
  set selectedImage(File? value) => _selectedImage.value = value;

  List<CreateCarListingRequestModel> get carListings => _carListings.value;
  set carListings(List<CreateCarListingRequestModel> value) {
    _carListings.firstRebuild = true;
    _carListings.value = value;
  }

  LoadingStatus get loadingStatus => _loadingStatus.value;
  set loadingStatus(LoadingStatus value) => _loadingStatus.value = value;

  @override
  void onReady() async {
    super.onReady();
    try {
      loadingStatus = LoadingStatus.Loading;
      LoadingProgress.start();

      await findMyLocation();

      await initializeLocation();
      await loadListingsFromLocal();
      await loadCustomMarkerOwn();

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

  void onTapDropdownValue(String value) {
    avaliability = value;
  }

  void unfocus() => FocusScope.of(context).unfocus();

  String? avaliabilityValidator(String? _) {
    if (avaliability == null) {
      return 'Field required';
    }
    return null;
  }

  void onTapAddEventCover() {
    ImagePickerBottomSheet(
      onTapCamera: () {
        Navigator.pop(context);
        onTapPickImage(ImageSource.camera);
      },
      onTapGallery: () {
        Navigator.pop(context);
        onTapPickImage(ImageSource.gallery);
      },
    ).openBottomSheet(context: context, backgroundColor: AppColors.azureishWhite);
  }

  Future<void> onTapPickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        selectedImage = imageFile;
      }
    } catch (e) {
      OverlayToastMessage.show(textMessage: 'AppLocalization.getLabels.anErrorOccuredWhileUploadingImage');
    }
  }

  void setMarkerForSelectedPlace() {
    markers.clear();

    if (getMapMarkerOwnLocation() != null) {
      markers.add(getMapMarkerOwnLocation());
    }

    if (selectedPlace != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('SelectedPlace'),
          position: LatLng(selectedPlace!.latitude, selectedPlace!.longitude),
          infoWindow: const InfoWindow(
            title: 'Selected Place',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
    }
    log('${selectedPlace!.latitude}' '${selectedPlace!.longitude}');
  }

  Marker getMapMarkerOwnLocation() {
    return Marker(
        markerId: const MarkerId('Location'),
        position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        icon: BitmapDescriptor.fromBytes(customMarkerOwn!),
        onTap: () {});
  }

  Future<void> findMyLocation() async {
    await initializeLocation();
  }

  Future<void> initializeLocation() async {
    try {
      final location = await determinePosition();
      currentLocation = LatLng(location.latitude, location.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(currentLocation!));
      setMarkerForSelectedPlace();
    } catch (error) {
      log("Error fetching location: $error");
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('AppLocalization.getLabels.locationServicesDisabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('AppLocalization.getLabels.locationPermissionsDenied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('AppLocalization.getLabels.locationPermissionsPermanentlyDenied');
    }

    return await Geolocator.getCurrentPosition();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    const detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json';

    final response = await http.get(Uri.parse('$detailsUrl?place_id=$placeId&key=$googleMapsApiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final Map<String, dynamic> result = data['result'];
        final location = result['geometry']['location'];
        final double latitude = location['lat'] as double;
        final double longitude = location['lng'] as double;
        selectedPlace!.latitude = latitude;
        selectedPlace!.longitude = longitude;

        log('Place ID: $placeId, Latitude: $latitude, Longitude: $longitude');
      }
    } else {
      // Handle error
      log('Error fetching place details: ${response.statusCode}');
    }
  }

  Future<void> loadCustomMarkerOwn() async {
    customMarkerOwn = await getBytesFromAsset(
      path: myLocationImage,
      width: 200.horizontalScale.toInt(),
    );
    findMyLocation();
  }

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData data = await rootBundle.load(path!);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);

    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void addListing(CreateCarListingRequestModel newListing) {
    carListings.add(newListing);
  }

  Future<void> addAndSaveListing(CreateCarListingRequestModel newListing) async {
    carListings.add(newListing);
    carListings = carListings;
    await saveListingsToLocal();

    Get.find<HomeController>().onReady();
  }

  Future<void> saveListingsToLocal() async {
    await localeManager.setStringListValue(CacheKey.cars, carListings.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<void> loadListingsFromLocal() async {
    carListings = localeManager
        .getStringListValue(CacheKey.cars)
        .map((e) => CreateCarListingRequestModel.fromJson(jsonDecode(e)))
        .toList();
  }

  
}
