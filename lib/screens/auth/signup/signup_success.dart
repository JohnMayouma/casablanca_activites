import 'package:flutter/material.dart';
import 'dart:async';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({super.key});

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  late String userType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    userType = (args != null && args['type'] == 'partner') ? 'partner' : 'user';
    Timer(const Duration(seconds: 3), () {
      if (userType == 'partner') {
        Navigator.pushReplacementNamed(context, '/login_partner');
      } else {
        Navigator.pushReplacementNamed(context, '/login_user');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPartner = userType == 'partner';
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
              Text(
                isPartner
                    ? 'Cas@Event | Bienvenue Partenaire'
                    : 'Cas@Event | Bienvenue',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                isPartner
                    ? 'Bravo !\n\nVotre compte partenaire est enregistré.\n\nVous allez être redirigé vers la page de connexion partenaire dans quelques instants.'
                    : 'Bravo !\n\nVotre compte est enregistré.\n\nVous allez être redirigé vers la page de connexion dans quelques instants.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
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