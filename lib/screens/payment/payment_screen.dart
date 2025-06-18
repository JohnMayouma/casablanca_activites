import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'card';
  final _formKey = GlobalKey<FormState>();

  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  late String title;
  late List<Map<String, dynamic>> selectedTickets;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    title = args['title'];
    selectedTickets = List<Map<String, dynamic>>.from(args['selectedTickets'] ?? []);
  }

  void handlePayment() {
    if (selectedMethod != 'card' || _formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/confirmation');
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var ticket in selectedTickets) {
      total += (ticket['price'] * ticket['quantity']);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paiement")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (var ticket in selectedTickets)
              Text("${ticket['quantity']} x ${ticket['type']} - ${ticket['price']} MAD"),
            const SizedBox(height: 10),
            Text("Total: ${total.toStringAsFixed(2)} MAD", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const Text(
              "Choisissez une méthode de paiement :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text("Carte"),
                  selected: selectedMethod == 'card',
                  onSelected: (_) => setState(() => selectedMethod = 'card'),
                ),
                ChoiceChip(
                  label: const Text("PayPal"),
                  selected: selectedMethod == 'paypal',
                  onSelected: (_) => setState(() => selectedMethod = 'paypal'),
                ),
                ChoiceChip(
                  label: const Text("Espèces"),
                  selected: selectedMethod == 'cash',
                  onSelected: (_) => setState(() => selectedMethod = 'cash'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (selectedMethod == 'card')
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Numéro de carte"),
                      validator: (value) => value!.isEmpty ? "Champ requis" : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: expiryController,
                            decoration: const InputDecoration(labelText: "MM/AA"),
                            validator: (value) => value!.isEmpty ? "Champ requis" : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: cvvController,
                            decoration: const InputDecoration(labelText: "CVV"),
                            validator: (value) => value!.isEmpty ? "Champ requis" : null,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Nom sur la carte"),
                      validator: (value) => value!.isEmpty ? "Champ requis" : null,
                    ),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Aucune information requise pour ce mode de paiement."),
              ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handlePayment,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
                child: const Text("Payer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
