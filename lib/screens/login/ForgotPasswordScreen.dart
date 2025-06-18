import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool showConfirmation = false;
  bool isResetPhase = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mot de passe oublié")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Cas@Event | Mot de passe oublié',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            if (!isResetPhase) ...[
              const Text(
                'Entrez l’adresse email associée à votre compte.\nNous vous enverrons un lien pour réinitialiser votre mot de passe.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24)),
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
                    "Un lien pour réinitialiser votre mot de passe a été envoyé sur ${_emailController.text.replaceRange(5, _emailController.text.indexOf('@'), "******")}.",
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                )
            ]
            else ...[
              const Text("Entrez votre nouveau mot de passe", style: TextStyle(fontSize: 16)),
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
                  labelText: "Confirmer le nouveau mot de passe",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              if (showError)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text("Le second mot de passe ne correspond pas au premier.",
                      style: TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_newPasswordController.text != _confirmPasswordController.text) {
                    setState(() => showError = true);
                    return;
                  }
                  setState(() => showError = false);
                  // logique de réinitialisation ici
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mot de passe réinitialisé avec succès.")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text("Réinitialiser le mot de passe"),
              )
            ]
          ],
        ),
      ),
    );
  }
}
    