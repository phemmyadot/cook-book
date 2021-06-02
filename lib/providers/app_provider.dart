import 'package:flutter/material.dart';
import 'package:recipiebook/utils/locator.dart';
import 'package:recipiebook/services/app_services.dart';

class AppProvider with ChangeNotifier {
  AppServices _appServices = locator<AppServices>();

  Future<void> registerUserProfile(String userName, String userId) =>
      _appServices.registerUserProfile(userName, userId);
}
