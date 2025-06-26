import 'package:flutter/material.dart';

class ForgotPasswordPartnerScreen extends StatefulWidget {
  const ForgotPasswordPartnerScreen({super.key});

  @override
  State<ForgotPasswordPartnerScreen> createState() => _ForgotPasswordPartnerScreenState();
}

class _ForgotPasswordPartnerScreenState extends State<ForgotPasswordPartnerScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool showConfirmation = false;
  bool isResetPhase = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mot de passe partenaire oublié")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Cas@Event | Partenaire - Mot de passe oublié',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            if (!isResetPhase) ...[
              const Text(
                'Entrez l’adresse email liée à votre compte partenaire.\nVous recevrez un lien de réinitialisation.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Partenaire',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                onPressed: () {
                  setState(() {
                    showConfirmation = true;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      isResetPhase = true;
                    });
                  });
                },
                child: const Text("Envoyer"),
              ),
              if (showConfirmation)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Un lien a été envoyé à ${_emailController.text.replaceRange(5, _emailController.text.indexOf('@'), "******")}.",
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
            ] else ...[
              const Text("Définissez un nouveau mot de passe", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Nouveau mot de passe",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirmez le mot de passe",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              if (showError)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Les mots de passe ne correspondent pas.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_newPasswordController.text != _confirmPasswordController.text) {
                    setState(() => showError = true);
                    return;
                  }
                  setState(() => showError = false);
                  // logique réelle à implémenter ici
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mot de passe partenaire réinitialisé.")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text("Réinitialiser le mot de passe"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
