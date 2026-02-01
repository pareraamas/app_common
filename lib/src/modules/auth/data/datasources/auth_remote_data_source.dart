import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../infrastructure/network/api_client.dart';
import '../../../../infrastructure/storage/auth_session.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRemoteDataSource {
  Future<String> register(String email, String password, String phone);
  Future<String> login(String email, String password);
  Future<String> forgotPassword(String email);
  Future<String> verifyResetOtp(String email, String otp);
  Future<String> resetPassword(String email, String resetToken, String newPassword);
  Future<Map<String, dynamic>> verifyOtp(String email, String otp);
  Future<Map<String, dynamic>> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _api;
  final IAuthSession _session;
  final DeviceInfoPlugin _deviceInfo;
  static final _publicOptions = Options(extra: {'requiresAuth': false});

  AuthRemoteDataSourceImpl(this._api, this._session, this._deviceInfo);

  @override
  Future<String> register(String email, String password, String phone) async {
    final response = await _api.post(
      '/master_auth/auth/register',
      options: _publicOptions,
      data: {
      'email': email,
      'password': password,
      'phone': phone,
      'user_type': 'customer'
      },
    );

    final body = response.data;
    if (body['success'] == true) {
      return body['message'] ?? 'Registration successful, OTP sent';
    } else {
      throw ServerFailure(body['message'] ?? body['error']);
    }
  }

  @override
  Future<String> login(String email, String password) async {
    final deviceId = await _getDeviceId();

    final response = await _api.post(
      '/master_auth/auth/login',
      options: _publicOptions,
      data: {
      'identity': email,
      'password': password,
      'device_id': deviceId
      },
    );

    final body = response.data;
    if (body['success'] == true) {
      _session.deviceId.value = deviceId;
      return body['message'] ?? 'OTP sent';
    } else {
      throw ServerFailure(body['message'] ?? body['error']);
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await _api.post(
      '/master_auth/auth/forgot_password',
      options: _publicOptions,
      data: {'email': email},
    );

    final body = response.data;
    if (body['success'] == true) {
      return body['message'] ?? 'OTP sent';
    } else {
      throw ServerFailure(body['message'] ?? 'Gagal mengirim OTP');
    }
  }

  @override
  Future<String> verifyResetOtp(String email, String otp) async {
    final response = await _api.post(
      '/master_auth/auth/verify_reset_otp',
      options: _publicOptions,
      data: {'email': email, 'otp': otp},
    );

    final body = response.data;
    if (body['success'] == true) {
      return body['data']['reset_token'];
    } else {
      throw ServerFailure(body['message'] ?? 'OTP tidak valid');
    }
  }

  @override
  Future<String> resetPassword(String email, String resetToken, String newPassword) async {
    final response = await _api.post(
      '/master_auth/auth/reset_password',
      options: _publicOptions,
      data: {
      'email': email,
      'reset_token': resetToken,
      'new_password': newPassword
      },
    );

    final body = response.data;
    if (body['success'] == true) {
      return body['message'] ?? 'Password reset successful';
    } else {
      throw ServerFailure(body['message'] ?? 'Gagal reset password');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final deviceId = await _getDeviceId();

    final response = await _api.post(
      '/master_auth/auth/verify_otp',
      options: _publicOptions,
      data: {
      'email': email,
      'otp': otp,
      'device_id': deviceId
      },
    );

    final body = response.data;
    if (body['success'] == true) {
      final data = body['data'];

      await _session.saveSession(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        deviceId: deviceId,
      );

      return data;
    } else {
      throw ServerFailure(body['message'] ?? body['error'] ?? 'OTP verification failed');
    }
  }

  @override
  Future<Map<String, dynamic>> getMe() async {
    final response = await _api.get('/master_auth/auth/me');
    final body = response.data;
    if (body['success'] == true) {
      return body['data'];
    } else {
      throw ServerFailure(body['message'] ?? 'Failed to fetch profile');
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
