class PlaceResult {
  final String name;
  final String mainText;
  final String secondaryText;
  final String placeId;
  double latitude;
  double longitude;

  PlaceResult({
    required this.name,
    required this.mainText,
    required this.secondaryText,
    required this.placeId,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    final name = json['description'] as String? ?? '';
    final structuredFormatting = json['structured_formatting'] as Map<String, dynamic>?;

    final mainText = structuredFormatting?['main_text'] as String? ?? '';
    final secondaryText = structuredFormatting?['secondary_text'] as String? ?? '';
    final placeId = json['place_id'] as String? ?? '';

    final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
    final location = geometry['location'] as Map<String, dynamic>? ?? {};
    final latitude = location['lat'] as double? ?? 0.0;
    final longitude = location['lng'] as double? ?? 0.0;

    return PlaceResult(
      name: name,
      mainText: mainText,
      secondaryText: secondaryText,
      placeId: placeId,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
