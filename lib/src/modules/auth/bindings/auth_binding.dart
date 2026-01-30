import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:app_common/app_common.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Device Info
    if (!Get.isRegistered<DeviceInfoPlugin>()) {
      Get.lazyPut(() => DeviceInfoPlugin());
    }

    // Data Sources
    Get.lazyPut(() => AuthRemoteDataSourceImpl(Get.find<ApiClient>(), Get.find<IAuthSession>(), Get.find<DeviceInfoPlugin>()));

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>(), Get.find<IAuthSession>()));

    // Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => VerifyOtpUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => ForgotPasswordUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => VerifyResetOtpUseCase(Get.find<AuthRepository>()));
    Get.lazyPut(() => ResetPasswordUseCase(Get.find<AuthRepository>()));

    // Controllers
    Get.lazyPut(
      () => AuthController(
        loginUseCase: Get.find<LoginUseCase>(),
        registerUseCase: Get.find<RegisterUseCase>(),
        verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
        forgotPasswordUseCase: Get.find<ForgotPasswordUseCase>(),
        verifyResetOtpUseCase: Get.find<VerifyResetOtpUseCase>(),
        resetPasswordUseCase: Get.find<ResetPasswordUseCase>(),
      ),
    );
  }
}
