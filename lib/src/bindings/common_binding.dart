import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../infrastructure/network/api_client.dart';
import '../infrastructure/storage/auth_session.dart';
import '../config/config_core.dart';

/// Global binding for core infrastructure services.
/// This should be used in the main app's initialBinding or GetMaterialApp(initialBinding: CommonBinding()).
class CommonBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Secure Storage
    if (!Get.isRegistered<FlutterSecureStorage>()) {
      Get.put(
        const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        ),
        permanent: true,
      );
    }

    // 2. Auth Session (Plain class, manually managed or via Get.put)
    final storage = Get.find<FlutterSecureStorage>();
    final authSession = Get.put<IAuthSession>(
      AuthSession(storage: storage),
      permanent: true,
    );

    // 3. API Client
    Get.put(
      ApiClient(
        baseUrl: ConfigCore.apiBaseUrl,
        authSession: authSession,
      ),
      permanent: true,
    );
  }
}
