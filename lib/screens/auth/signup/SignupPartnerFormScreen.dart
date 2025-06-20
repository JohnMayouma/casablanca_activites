import 'package:flutter/material.dart';

class SignupPartnerFormScreen extends StatefulWidget {
  const SignupPartnerFormScreen({super.key});

  @override
  State<SignupPartnerFormScreen> createState() => _SignupPartnerFormScreenState();
}

class _SignupPartnerFormScreenState extends State<SignupPartnerFormScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _activityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _goToPolicyPage() {
    if (_firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _companyNameController.text.isNotEmpty &&
        _activityController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.length >= 8) {
       Navigator.pushNamed(context, '/signup_otp', arguments: {'type': 'partner'});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs correctement.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Image.asset('assets/icons/logo.png', height: 80),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Cas@Event | Inscription Partenaire',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2, color: Colors.red),
              const SizedBox(height: 24),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Prénom du responsable',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du responsable',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: "Nom de l'entreprise",
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _activityController,
                decoration: const InputDecoration(
                  labelText: "Secteur d'activité",
                  prefixIcon: Icon(Icons.work_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Adresse email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  helperText: 'Au moins 8 caractères',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToPolicyPage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Suivant', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}