  // signup_qr_verification.dart
import 'package:flutter/material.dart';

class SignupQrVerificationScreen extends StatelessWidget {
  const SignupQrVerificationScreen({super.key});

  void _continue(BuildContext context) {
    Navigator.pushNamed(context, '/signup_success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/icons/logo.png', height: 80),
              const SizedBox(height: 20),
              const Text('Cas@Event | Verification QR Code',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(thickness: 2, color: Colors.red),
              const SizedBox(height: 20),
              const Text("Un mail vous a été envoyé sur manal******@ynov.com"),
              const SizedBox(height: 20),
              Image.asset('assets/images/qrcode.png', height: 160),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _continue(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Continuer"),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: const Text("Envoyer à nouveau."),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Envoyer un code"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
 