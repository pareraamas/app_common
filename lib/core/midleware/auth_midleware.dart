import 'package:app_common/app_common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Pastikan path import AuthSession Anda benar
// import 'package:your_package/auth_session.dart';

class AuthMiddleware extends GetMiddleware {
  // Ambil instance AuthSession yang sudah didaftarkan di Get.find()
  final authSession = Get.find<IAuthSession>();

  @override
  RouteSettings? redirect(String? route) {
    // Jika user TIDAK login, arahkan ke halaman login

    // Jika sudah login, biarkan (return null)
    return authSession.isLoggedIn.value ? null : RouteSettings(name: ConfigRoutes.LOGIN);
  }
}
