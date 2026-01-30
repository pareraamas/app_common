import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/auth_session.dart';
import '../../routes/config_pages.dart';

class AuthMiddleware extends GetMiddleware {
  final authSession = Get.find<IAuthSession>();

  @override
  RouteSettings? redirect(String? route) {
    return authSession.isLoggedIn.value ? null : const RouteSettings(name: ConfigRoutes.LOGIN);
  }
}
