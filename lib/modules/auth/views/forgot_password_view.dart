import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Kata Sandi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<AuthController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Masukkan email Anda untuk menerima kode OTP reset password.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                if (controller.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: controller.forgotPassword,
                    child: const Text('Kirim OTP'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
