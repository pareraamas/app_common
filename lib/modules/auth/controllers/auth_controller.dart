import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../../domain/usecases/auth/register_usecase.dart';
import '../../../../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../../../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../../../../domain/usecases/auth/verify_reset_otp_usecase.dart';
import '../../../../../domain/usecases/auth/reset_password_usecase.dart';
import '../../../routes/app_pages.dart';
import '../views/verify_otp_view.dart';
import '../views/reset_password_view.dart';
import '../views/verify_reset_otp_view.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyResetOtpUseCase _verifyResetOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyResetOtpUseCase verifyResetOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _verifyResetOtpUseCase = verifyResetOtpUseCase,
        _resetPasswordUseCase = resetPasswordUseCase;

  // State
  bool isLoading = false;

  // Form
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController(); // For register
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController(); // For reset password
  final isPasswordHidden = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email dan Password wajib diisi');
      return;
    }

    isLoading = true;
    update();

    final params = LoginParams(email: email, password: password);
    final result = await _loginUseCase(params);

    result.fold(
      (failure) {
        isLoading = false;
        Get.snackbar('Gagal Login', failure.message);
        update();
      },
      (message) {
        isLoading = false;
        Get.snackbar('Sukses', message);
        update();
        // Navigate to Verify OTP
        Get.to(() => const VerifyOtpView());
      },
    );
  }

  Future<void> register() async {
    final email = emailController.text;
    final password = passwordController.text;
    final phone = phoneController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email dan Password wajib diisi');
      return;
    }

    isLoading = true;
    update();

    final params = RegisterParams(email: email, password: password, phone: phone);
    final result = await _registerUseCase(params);

    result.fold(
      (failure) {
        isLoading = false;
        Get.snackbar('Gagal Registrasi', failure.message);
        update();
      },
      (message) {
        isLoading = false;
        Get.snackbar('Sukses', message);
        update();
        // Navigate to Verify OTP
        Get.to(() => const VerifyOtpView());
      },
    );
  }

  Future<void> verifyOtp() async {
    final email = emailController.text;
    final otp = otpController.text;

    if (otp.isEmpty) {
      Get.snackbar('Error', 'OTP wajib diisi');
      return;
    }

    isLoading = true;
    update();

    final params = VerifyOtpParams(email: email, otp: otp);
    final result = await _verifyOtpUseCase(params);

    result.fold(
      (failure) {
        isLoading = false;
        Get.snackbar('Gagal Verifikasi', failure.message);
        update();
      },
      (success) {
        isLoading = false;
        Get.offAllNamed(Routes.HOME); // Navigate to Home and clear stack
      },
    );
  }

  String? resetToken; // Store reset token temporarily

  Future<void> forgotPassword() async {
    final email = emailController.text;

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email wajib diisi');
      return;
    }

    isLoading = true;
    update();

    final result = await _forgotPasswordUseCase(email);

    result.fold(
      (failure) {
        isLoading = false;
        Get.snackbar('Gagal', failure.message);
        update();
      },
      (message) {
        isLoading = false;
        Get.snackbar('Sukses', message);
        update();
        // Navigate to Verify Reset OTP View
        Get.to(() => const VerifyResetOtpView());
      },
    );
  }

  Future<void> verifyResetOtp() async {
    final email = emailController.text;
    final otp = otpController.text;

    if (otp.isEmpty) {
      Get.snackbar('Error', 'OTP wajib diisi');
      return;
    }

    isLoading = true;
    update();

    final params = VerifyResetOtpParams(email: email, otp: otp);
    final result = await _verifyResetOtpUseCase(params);

    result.fold(
      (failure) {
        isLoading = false;
        Get.snackbar('Gagal Verifikasi', failure.message);
        update();
      },
      (token) {
        isLoading = false;
        resetToken = token;
        Get.snackbar('Sukses', 'OTP terverifikasi');
        update();
        // Navigate to Reset Password View
        Get.to(() => const ResetPasswordView());
      },
    );
  }

  Future<void> resetPassword() async {
    final email = emailController.text;
    final newPassword = newPasswordController.text;

    if (resetToken == null || newPassword.isEmpty) {
      Get.snackbar('Error', 'Terjadi kesalahan, silakan ulangi proses lupa password');
      return;
    }

    isLoading = true;
    update();

    final params = ResetPasswordParams(email: email, resetToken: resetToken!, newPassword: newPassword);
    final result = await _resetPasswordUseCase(params);

    result.fold(
      (failure) {
        isLoading = false;
        Get.snackbar('Gagal Reset Password', failure.message);
        update();
      },
      (message) {
        isLoading = false;
        Get.snackbar('Sukses', message);
        update();
        // Back to Login
        Get.offAllNamed(Routes.LOGIN);
      },
    );
  }

  void loginOffline() {
    // Bypass authentication for offline testing
    Get.offAllNamed(Routes.HOME);
    Get.snackbar('Mode Offline', 'Masuk sebagai Guest (Offline Mode)');
  }
}
