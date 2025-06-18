import 'package:flutter/material.dart';

class SelectUserTypeScreen extends StatefulWidget {
  const SelectUserTypeScreen({super.key});

  @override
  State<SelectUserTypeScreen> createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen> {
  String selected = '';

  void _goToLogin() {
    if (selected == 'user') {
      Navigator.pushNamed(context, '/login_user');
    } else if (selected == 'partner') {
      Navigator.pushNamed(context, '/login_partner');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un type d’utilisateur.')),
      );
    }
  }

  Widget _buildChoiceCard(String label, String imagePath, String value, {double borderRadius = 22, double imageHeight = 160}) {
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () {
        setState(() => selected = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.93),
          border: Border.all(color: isSelected ? Colors.red : Colors.grey.shade300, width: 2.2),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.red.withOpacity(0.13) : Colors.grey.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // IMAGE: la miniature est plus "frappante" style Jazzablanca (2e image)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.11),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: imageHeight,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.red : Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NOUVEAU: background plus frappant et overlay foncé
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFf85032), // orange/rouge
                  Color(0xFFe73827), // rouge vif
                  Color(0xFFf9d423), // jaune chaud
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.18),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(color: Colors.red.shade100, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/icons/logo.png', height: 70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Sélectionner le type d’utilisateur',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    _buildChoiceCard('Visiteurs & Touristes', 'assets/images/touristes_velo.jpeg', 'user', borderRadius: 22, imageHeight: 155),
                    _buildChoiceCard('Partenaires', 'assets/images/jazzablanca.jpg', 'partner', borderRadius: 22, imageHeight: 180),
                    const SizedBox(height: 40),
                    // SUPPRESSION du bouton Retour ici
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _goToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text('Suivant'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}