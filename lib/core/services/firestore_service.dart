import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base_project/app/constants/enum/general_enum.dart';
import 'package:flutter_base_project/app/model/request/create_car_listing_request_model.dart';

/// Tüm moldüllerde ile kullanılan Http işlemleri burada yapılmakta
///
class General {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveListingToFirebase(
      CreateCarListingRequestModel userInfo) async {
    try {
      {
        await FirebaseFirestore.instance
            .collection(FireBaseCollectionEnums.listings.name)
            .doc()
            .set(userInfo.toJson());
      }
    } catch (e) {
      throw 'An error occured during register.';
    }
  }

  Future<List<CreateCarListingRequestModel>>
      getAllListingsFromFirestore() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FireBaseCollectionEnums.listings.name)
          .get();

      final c = snapshot.docs
          .map((DocumentSnapshot doc) => CreateCarListingRequestModel.fromJson(
              doc.data() as Map<String, dynamic>))
          .toList();
      return c;
    } catch (e) {
      throw 'An error occurred while fetching listings from Firestore.';
    }
  }

  Future<void> deleteListingFromFirestore(String modelId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FireBaseCollectionEnums.listings.name)
          .where('id', isEqualTo: modelId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot document = snapshot.docs.first;

        await document.reference.delete();
      } else {
        throw 'Listing not found.';
      }
    } catch (e) {
      throw 'An error occurred while deleting the listing from Firestore: $e';
    }
  }
}
