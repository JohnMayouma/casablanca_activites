// signup_success.dart
import 'package:flutter/material.dart';
import 'dart:async';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({super.key});

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login_user');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/icons/logo.png', height: 80),
              const SizedBox(height: 20),
              const Text('Cas@Event | Bienvenue',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(thickness: 2, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Bravo !\n\nVotre compte est enregistré.\n\nVous allez être redirigé vers la page de connexion dans quelques instants.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(color: Colors.orange)
            ],
          ),
        ),
      ),
    );
  }
}
    