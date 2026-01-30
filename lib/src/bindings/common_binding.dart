import 'package:app_common/app_common.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Global binding for core infrastructure services.
/// This should be used in the main app's initialBinding or GetMaterialApp(initialBinding: CommonBinding()).
class CommonBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Secure Storage
    if (!Get.isRegistered<FlutterSecureStorage>()) {
      Get.put(const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true)), permanent: true);
    }

    // 2. Auth Session (Plain class, manually managed or via Get.put)
    final storage = Get.find<FlutterSecureStorage>();
    final authSession = Get.put<IAuthSession>(AuthSession(storage: storage), permanent: true);

    // 3. API Client
    Get.put(ApiClient(baseUrl: ConfigCore.apiBaseUrl, authSession: authSession), permanent: true);

    // 4. repositories and other services can be added here similarly
    Get.putAsync<AuthRemoteDataSource>(() async {
      // Example: return SomeRepository(apiClient: Get.find<ApiClient>());
      return AuthRemoteDataSourceImpl(Get.find<ApiClient>(), authSession, Get.put<DeviceInfoPlugin>(DeviceInfoPlugin()));
    }, permanent: true);
  }
}
