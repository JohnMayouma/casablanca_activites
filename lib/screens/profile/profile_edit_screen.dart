import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController(text: "john");
  final TextEditingController lastNameController = TextEditingController(text: "MAYOUMA");
  final TextEditingController emailController = TextEditingController(text: "johnmayouma82@@gmail.com");
  final TextEditingController addressController = TextEditingController(text: "Abdelmoumen");
  final TextEditingController phoneController = TextEditingController(text: "+212 781-688611");
  final TextEditingController passwordController = TextEditingController(text: "sbdfbnd65sfDvb s");

  String selectedCity = "Casablanca";
  String selectedCountry = "Maroc";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Ajouter action pour changer photo
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildTextField("Nom", firstNameController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField("Prénom", lastNameController)),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField("Email", emailController),
              const SizedBox(height: 12),
              _buildTextField("Adresse", addressController),
              const SizedBox(height: 12),
              _buildTextField("Numéro de téléphone", phoneController),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCity,
                      decoration: const InputDecoration(labelText: "Ville"),
                      items: const [
                        DropdownMenuItem(value: "Casablanca", child: Text("Casablanca")),
                        DropdownMenuItem(value: "Rabat", child: Text("Rabat")),
                        DropdownMenuItem(value: "Marrakech", child: Text("Marrakech")),
                      ],
                      onChanged: (value) => setState(() => selectedCity = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCountry,
                      decoration: const InputDecoration(labelText: "Pays"),
                      items: const [
                        DropdownMenuItem(value: "Maroc", child: Text("Maroc")),
                        DropdownMenuItem(value: "France", child: Text("France")),
                        DropdownMenuItem(value: "Espagne", child: Text("Espagne")),
                      ],
                      onChanged: (value) => setState(() => selectedCountry = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField("Mot de passe", passwordController, obscure: true),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Action suppression
                      },
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text("Supprimer"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Enregistrer les données
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Enregistrer"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value == null || value.isEmpty ? "Ce champ est requis" : null,
    );
  }
}
