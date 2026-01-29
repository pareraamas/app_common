import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:app_common/app_common.dart';

class AuthRemoteDataSource {
  final ApiClient _api;
  final IAuthSession _session;
  final DeviceInfoPlugin _deviceInfo;

  AuthRemoteDataSource(this._api, this._session, this._deviceInfo);

  Future<String> register(String email, String password, String phone) async {
    final response = await _api.post('/master_auth/auth/register', data: {'email': email, 'password': password, 'phone': phone, 'user_type': 'customer'});

    final body = response.data;
    if (body['success'] == true) {
      return body['message'] ?? 'Registration successful, OTP sent';
    } else {
      throw ServerFailure(body['message'] ?? body['error']);
    }
  }

  Future<String> login(String email, String password) async {
    final deviceId = await _getDeviceId();

    final response = await _api.post('/master_auth/auth/login', data: {'identity': email, 'password': password, 'device_id': deviceId});

    final body = response.data;
    if (body['success'] == true) {
      _session.deviceId.value = deviceId;
      return body['message'] ?? 'OTP sent';
    } else {
      throw ServerFailure(body['message'] ?? body['error']);
    }
  }

  Future<String> forgotPassword(String email) async {
    final response = await _api.post('/master_auth/auth/forgot_password', data: {'email': email});

    final body = response.data;
    if (body['success'] == true) {
      return body['message'] ?? 'OTP sent';
    } else {
      throw ServerFailure(body['message'] ?? 'Gagal mengirim OTP');
    }
  }

  Future<String> verifyResetOtp(String email, String otp) async {
    final response = await _api.post('/master_auth/auth/verify_reset_otp', data: {'email': email, 'otp': otp});

    final body = response.data;
    if (body['success'] == true) {
      return body['data']['reset_token'];
    } else {
      throw ServerFailure(body['message'] ?? 'OTP tidak valid');
    }
  }

  Future<String> resetPassword(String email, String resetToken, String newPassword) async {
    final response = await _api.post('/master_auth/auth/reset_password', data: {'email': email, 'reset_token': resetToken, 'new_password': newPassword});

    final body = response.data;
    if (body['success'] == true) {
      return body['message'] ?? 'Password reset successful';
    } else {
      throw ServerFailure(body['message'] ?? 'Gagal reset password');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final deviceId = await _getDeviceId();

    final response = await _api.post('/master_auth/auth/verify_otp', data: {'email': email, 'otp': otp, 'device_id': deviceId});

    final body = response.data;
    if (body['success'] == true) {
      final data = body['data'];

      await _session.saveSession(accessToken: data['access_token'], refreshToken: data['refresh_token'], deviceId: deviceId);

      return data;
    } else {
      throw ServerFailure(body['message'] ?? body['error'] ?? 'OTP verification failed');
    }
  }

  Future<String> _getDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios_device';
    } else if (Platform.isMacOS) {
      return 'macos_dev_device_123';
    }
    return 'unknown_device';
  }
}
