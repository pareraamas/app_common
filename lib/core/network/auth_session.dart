import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interface for Authentication Session management.
/// This allows for easy mocking in tests and flexibility if implementation changes.
abstract class IAuthSession {
  RxBool get isLoggedIn;
  RxString get accessToken;
  RxString get refreshToken;
  RxString get deviceId;

  Future<void> saveSession({required String accessToken, required String refreshToken, required String deviceId});

  Future<void> clearSession();

  /// Initialize the session by loading data from storage.
  Future<void> initialize();
}

/// Implementation of [IAuthSession] using [FlutterSecureStorage].
/// This is a plain class, independent of GetX lifecycle (GetService).
class AuthSession implements IAuthSession {
  final FlutterSecureStorage _storage;

  AuthSession({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true)) {
    initialize();
  }

  @override
  final RxBool isLoggedIn = false.obs;

  @override
  final RxString accessToken = ''.obs;

  @override
  final RxString refreshToken = ''.obs;

  @override
  final RxString deviceId = ''.obs;

  @override
  Future<void> initialize() async {
    await _loadSession();
  }

  /// Loads the session from secure storage.
  Future<void> _loadSession() async {
    try {
      accessToken.value = await _storage.read(key: 'access_token') ?? '';
      refreshToken.value = await _storage.read(key: 'refresh_token') ?? '';
      deviceId.value = await _storage.read(key: 'device_id') ?? '';
      isLoggedIn.value = accessToken.isNotEmpty;
    } catch (e) {
      // Handle potential storage errors
      accessToken.value = '';
      refreshToken.value = '';
      isLoggedIn.value = false;
    }
  }

  @override
  Future<void> saveSession({required String accessToken, required String refreshToken, required String deviceId}) async {
    this.accessToken.value = accessToken;
    this.refreshToken.value = refreshToken;
    this.deviceId.value = deviceId;
    isLoggedIn.value = true;

    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(key: 'device_id', value: deviceId);
  }

  @override
  Future<void> clearSession() async {
    accessToken.value = '';
    refreshToken.value = '';
    isLoggedIn.value = false;

    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
