import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ResetPasswordView extends GetView<AuthController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<AuthController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Masukkan password baru Anda.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => TextField(
                    controller: controller.newPasswordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (controller.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: controller.resetPassword,
                    child: const Text('Simpan Password Baru'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
