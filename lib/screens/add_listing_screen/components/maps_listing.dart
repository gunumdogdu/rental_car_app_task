part of '../view/add_listing.dart';

class _Maps extends StatelessWidget {
  const _Maps({
    required this.controller,
  });

  final AddListingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 320.horizontalScale,
        child: GoogleMap(
          compassEnabled: true,
          onTap: (LatLng tappedPoint) {
            final double latitude = tappedPoint.latitude;
            final double longitude = tappedPoint.longitude;
            controller.selectedPlace = PlaceResult(
              mainText: 'Selected Location',
              secondaryText: 'Custom Address',
              latitude: latitude,
              longitude: longitude,
              name: '',
              placeId: '',
            );
            controller.setMarkerForSelectedPlace();
          },
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
          markers: Set<Marker>.of(controller.markers),
          padding: const EdgeInsets.only(bottom: paddingXXXXXL),
          onMapCreated: (GoogleMapController e) async {
            controller.findMyLocation();
            controller.setMapController(e);
            controller.mapController = e;
          },
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              controller.currentLocation!.latitude,
              controller.currentLocation!.longitude,
            ),
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
