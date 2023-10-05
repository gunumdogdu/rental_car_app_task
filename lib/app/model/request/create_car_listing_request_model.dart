// To parse this JSON data, do
//
//     final createCarListingRequestModel = createCarListingRequestModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

CreateCarListingRequestModel createCarListingRequestModelFromJson(String str) =>
    CreateCarListingRequestModel.fromJson(json.decode(str));

String createCarListingRequestModelToJson(CreateCarListingRequestModel data) => json.encode(data.toJson());

class CreateCarListingRequestModel {
  int? id;
  String? name;
  int? price;
  File? eventImage;
  double? latitude;
  double? longitude;
  String? availability;

  CreateCarListingRequestModel({
    this.id,
    this.name,
    this.price,
    this.eventImage,
    this.latitude,
    this.longitude,
    this.availability,
  });

  factory CreateCarListingRequestModel.fromJson(Map<String, dynamic> json) => CreateCarListingRequestModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        eventImage: json["eventImage"] != null ? File(json["eventImage"]) : null,
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        availability: json["availability"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "eventImage": eventImage?.path,
        "latitude": latitude,
        "longitude": longitude,
        "availability": availability,
      };
}