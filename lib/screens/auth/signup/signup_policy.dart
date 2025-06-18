 import 'package:flutter/material.dart';

class SignupPolicyScreen extends StatelessWidget {
  const SignupPolicyScreen({super.key});

  void _acceptPolicy(BuildContext context) {
    Navigator.pushNamed(context, '/signup_otp');
  }

  void _declinePolicy(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politique de Confidentialité'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "Chez Cas@Event, nous nous engageons à protéger vos données personnelles. "
                  "Les informations collectées sont utilisées exclusivement pour améliorer votre expérience. "
                  "En poursuivant, vous acceptez notre politique de confidentialité et nos conditions générales d'utilisation.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _acceptPolicy(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Accepter et continuer'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _declinePolicy(context),
              child: const Text('Refuser', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
   