import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'register_view.dart';
import 'forgot_password_view.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  controller.emailController.text = "admin@example.com";
                  controller.passwordController.text = "password123";
                },
                child: const Text(
                  'TOKO MAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan login untuk melanjutkan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => Get.to(() => const ForgotPasswordView()), child: const Text('Lupa Kata Sandi?')),
              ),
              GetBuilder<AuthController>(
                builder: (c) {
                  return SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: c.isLoading ? null : c.login,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                      child: c.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('LOGIN'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: controller.loginOffline, child: const Text('Masuk Mode Offline (Debug)')),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Get.to(() => const RegisterView()), child: const Text('Belum punya akun? Daftar')),
            ],
          ),
        ),
      ),
    );
  }
}
