import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/add_listing_controller.dart';
import 'view/add_listing.dart';

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddListingController(),
      builder: (_) => const AddListing(),
    );
  }
}