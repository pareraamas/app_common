import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';

part 'config_routes.dart';

class ConfigPages {
  ConfigPages._();

  static final routes = [GetPage(name: _Paths.LOGIN, page: () => const LoginView(), binding: AuthBinding())];
}
