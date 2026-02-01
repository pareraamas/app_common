import 'package:app_common/app_common.dart';

abstract class AuthRepository {
  Result<String> register(String email, String password, String phone);
  Result<String> login(String email, String password);
  Result<String> forgotPassword(String email);
  Result<String> verifyResetOtp(String email, String otp);
  Result<String> resetPassword(String email, String resetToken, String newPassword);
  Result<void> verifyOtp(String email, String otp);
  Result<Map<String, dynamic>> getMe();
  Future<bool> isLoggedIn();
  Future<void> logout();
}
