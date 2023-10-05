import 'package:flutter/material.dart' show PageRoute, RouteSettings;
import 'package:flutter_base_project/app/navigation/route/page_route_builder.dart';
import 'package:flutter_base_project/screens/add_listing_screen/add_listing_screen.dart';
import 'package:flutter_base_project/screens/auth/login_screen/login_screen.dart';
import 'package:flutter_base_project/screens/home_screen/home_screen.dart';
import 'package:flutter_base_project/screens/listing_detail_screen/listing_detail_screen.dart';
import 'package:flutter_base_project/screens/screens.dart';

typedef PageRouteFun = PageRoute Function(RouteSettings);

enum MainScreensEnum {
  init('/'),
  landingScreen('/landingScreen'),
  homeScreen('/homeScreen'),
  addListingScreen('/addListingScreen'),
  loginScreen('/loginScreen'),
  listingDetailScreen('/listingDetailScreen');

  const MainScreensEnum(this.path);

  final String path;
}

Map<String, PageRouteFun> mainRoutesMap = {
  MainScreensEnum.init.path: (_) => goToPage(const SplashScreen(), _),
  MainScreensEnum.landingScreen.path: (_) => goToPage(const LandingScreen(), _),
  MainScreensEnum.homeScreen.path: (_) => goToPage(const HomeScreen(), _),
  MainScreensEnum.addListingScreen.path: (_) => goToPage(const AddListingScreen(), _),
  MainScreensEnum.loginScreen.path: (_) => goToPage(const LoginScreen(), _),
  MainScreensEnum.listingDetailScreen.path: (_) => goToPage(const ListingDetailScreen(), _),
};
