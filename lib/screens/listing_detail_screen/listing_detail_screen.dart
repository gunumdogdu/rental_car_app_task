import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/listing_detail_controller.dart';
import 'view/listing_detail.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ListingDetailController(id: ModalRoute.of(context)!.settings.arguments as int),
      builder: (_) => const ListingDetail(),
    );
  }
}
