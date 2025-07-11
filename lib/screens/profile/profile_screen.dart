import 'package:flutter/material.dart';
// N'oublie pas d'importer ta page de paiement
import '../payment/payment_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemple de nom récupéré dynamiquement depuis l’inscription
    final String fullName = "John MAYOUMA";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // La barre du bas a été retirée ici

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // (Optionnel) ajouter la modification photo ici
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 253, 86, 86),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30),
            _buildTile(
              context,
              Icons.edit,
              "Modifier le profil",
              onTap: () => Navigator.pushNamed(context, "/profile_edit"),
            ),
            _buildTile(context, Icons.notifications_none, "Notification", onTap: () {}),
            _buildTile(context, Icons.lock_outline, "Sécurité", onTap: () {}),
            _buildTile(
              context,
              Icons.payment,
              "Paiement",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                );
              },
            ),
            _buildTile(context, Icons.color_lens_outlined, "Apparence", onTap: () {}),
            _buildTile(context, Icons.help_outline, "Aide", onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Color.fromARGB(255, 248, 83, 83)),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}