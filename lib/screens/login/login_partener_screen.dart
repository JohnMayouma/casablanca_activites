import 'package:flutter/material.dart';

class LoginPartnerScreen extends StatefulWidget {
  const LoginPartnerScreen({super.key});

  @override
  State<LoginPartnerScreen> createState() => _LoginPartnerScreenState();
}

class _LoginPartnerScreenState extends State<LoginPartnerScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkIfPartnerIsLoggedIn();
  }

  void _checkIfPartnerIsLoggedIn() async {
    bool partnerLoggedIn = false; // À remplacer par votre logique de session
    if (partnerLoggedIn) {
      Navigator.pushReplacementNamed(context, '/partner_dashboard');
    }
  }

  void _login() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/partner_dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
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
                child: Image.asset(
                  'assets/icons/logo.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Cas@Event | Partenaire',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(thickness: 2, color: Colors.red),
              const SizedBox(height: 24),
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
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  helperText: "Le mot de passe doit contenir au moins 8 caractères",
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot_password_partner');

                  },
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _login,
                  child: const Text("Se connecter", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) => setState(() => _rememberMe = val ?? false),
                  ),
                  const Text("Se souvenir de moi")
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("OU"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/icons/google_logo.png', height: 24),
                  label: const Text("Continuer avec Google", style: TextStyle(color: Color.fromARGB(221, 245, 74, 74))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "En vous inscrivant, vous acceptez les Termes et Conditions. Vos données seront traitées conformément à notre politique de confidentialité.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup_partner'),
                  child: const Text("Vous n'avez pas de compte ? Inscrivez-vous ici",
                      style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
