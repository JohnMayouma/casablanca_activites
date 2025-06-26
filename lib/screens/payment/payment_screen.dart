import 'package:casablanca_activites/screens/payment/payment_otp_screen.dart';
import 'package:flutter/material.dart';
// Mets le bon chemin selon ton architecture

// -------- Nouvelle page : PaypalReviewScreen --------

class PaypalReviewScreen extends StatelessWidget {
  final String eventTitle;
  final String eventImage;
  final String eventDate;
  final String eventLocation;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String seatType;
  final int quantity;
  final double pricePerSeat;
  final double tax;
  final double total;
  final String paymentMethod;
  final VoidCallback onChangePayment;

  const PaypalReviewScreen({
    super.key,
    required this.eventTitle,
    required this.eventImage,
    required this.eventDate,
    required this.eventLocation,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.seatType,
    required this.quantity,
    required this.pricePerSeat,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.onChangePayment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Summary", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF7F7FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        eventImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 248, 71, 71),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: const Text(
                                  "FREE",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  eventTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            eventDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromARGB(255, 235, 64, 62),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 15, color: Color.fromARGB(255, 245, 74, 52)),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  eventLocation,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // User info
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _rowInfo("Full Name", fullName),
                    _rowInfo("Phone Number", phoneNumber),
                    _rowInfo("Email", email),
                  ],
                ),
              ),

              // Ticket info
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _rowInfo("$quantity Seats ($seatType)", "\$${(pricePerSeat * quantity).toStringAsFixed(2)}"),
                    _rowInfo("Tax", "\$${tax.toStringAsFixed(2)}"),
                    _rowInfo("Total", "\$${total.toStringAsFixed(2)}", isBold: true),
                  ],
                ),
              ),

              // Payment method (PAYPAL UNIQUEMENT)
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 18),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/payments/paypal_logo.png",
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Paypal",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onChangePayment,
                      child: const Text(
                        "Change",
                        style: TextStyle(
                          color: Color.fromARGB(255, 224, 92, 92),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Continue Button
             SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentOtpScreen(email: email, sentOtp: '',),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 241, 79, 79),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      elevation: 0,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    child: const Text("Continue"),
  ),
),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowInfo(String left, String right, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            right,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------- FIN PaypalReviewScreen -----------

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'paypal';

  late String title;
  late List<Map<String, dynamic>> selectedTickets;
  late String eventImage;
  late String eventDate;
  late String eventLocation;

  List<Map<String, String>> savedCards = [];

  late String userFullName;
  late String userPhone;
  late String userMail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map?;

    // Sécuriser la récupération des arguments (title, event, user...)
    title = args?['title'] ?? '';
    selectedTickets = List<Map<String, dynamic>>.from(args?['selectedTickets'] ?? []);
    eventImage = args?['imageUrl'] ?? "assets/event_sample.png";
    eventDate = args?['date'] ?? "";
    eventLocation = args?['location'] ?? "";

    // Si tu passes les infos utilisateur dans les arguments, on les récupère ici :
    userFullName = args?['userFullName'] ?? '';
    userPhone = args?['userPhone'] ?? '';
    userMail = args?['userEmail'] ?? '';
  }

  void handlePayment() {
    double total = 0;
    int quantity = 0;
    String seatType = "";
    double pricePerSeat = 0;
    for (var ticket in selectedTickets) {
      quantity = ticket['quantity'];
      seatType = ticket['type'];
      pricePerSeat = (ticket['price'] as num).toDouble();
      total += (ticket['price'] * ticket['quantity']);
    }

    double tax = total * 0.1;
    double totalWithTax = total + tax;

    // UNIQUEMENT PAYPAL
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaypalReviewScreen(
          eventTitle: title,
          eventImage: eventImage,
          eventDate: eventDate,
          eventLocation: eventLocation,
          fullName: userFullName,
          phoneNumber: userPhone,
          email: userMail,
          seatType: seatType,
          quantity: quantity,
          pricePerSeat: pricePerSeat,
          tax: tax,
          total: totalWithTax,
          paymentMethod: selectedMethod,
          onChangePayment: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void goToAddCardScreen() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCardScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        savedCards.add(result);
        selectedMethod = 'card';
      });
    }
  }

  Widget paymentOption({
    required String value,
    required String label,
    required String asset,
  }) {
    return InkWell(
      onTap: () => setState(() => selectedMethod = value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selectedMethod == value ? const Color.fromARGB(255, 242, 68, 68) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: selectedMethod == value
                  ? const Color.fromARGB(255, 242, 70, 70).withOpacity(0.10)
                  : Colors.grey.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              asset,
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 23,
              height: 23,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedMethod == value ? const Color.fromARGB(255, 246, 86, 77) : Colors.grey.shade400,
                  width: 2,
                ),
                color: selectedMethod == value ? const Color.fromARGB(255, 248, 98, 61) : Colors.transparent,
              ),
              child: selectedMethod == value
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var ticket in selectedTickets) {
      total += (ticket['price'] * ticket['quantity']);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F7FA),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (var ticket in selectedTickets)
              Text("${ticket['quantity']} x ${ticket['type']} - ${ticket['price']} MAD"),
            const SizedBox(height: 8),
            Text("Total: ${total.toStringAsFixed(2)} MAD", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 22),

            const Text(
              "Select the payment method you want to use.",
              style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 18),

            paymentOption(
              value: 'paypal',
              label: 'Paypal',
              asset: 'assets/payments/paypal_logo.png',
            ),

            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 28),
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 242, 80, 62),
                  backgroundColor: const Color(0xFFecebfa),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: goToAddCardScreen,
                child: const Text("Ajouter une nouvelle carte"),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 244, 82, 82),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  padding: const EdgeInsets.all(16),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                child: const Text("Confirmer le paiement"),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

// -------- Nouvelle page : AddCardScreen --------
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Widget _buildCreditCardPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF22252B),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 24,
            child: Text(
              "Mocard",
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 65,
            child: Row(
              children: List.generate(
                4,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "●●●●",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 22,
            child: Image.asset(
              "assets/payments/amazon_logo.png",
              height: 26,
            ),
          ),
          Positioned(
            left: 20,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Card Holder name",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
                Text(
                  nameController.text.isEmpty ? "•••• ••••" : nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 160,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expiry date",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
                Text(
                  expiryController.text.isEmpty ? "••/••" : expiryController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            bottom: 22,
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Card", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
            color: Colors.black54,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF7F7FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCreditCardPreview(),
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Card Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Card Name",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 14),
                    const Text("Card Number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Card Number",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Expiry Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: expiryController,
                                decoration: InputDecoration(
                                  hintText: "Expiry...",
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: const Icon(Icons.calendar_month_outlined, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                validator: (v) => v!.isEmpty ? "Required" : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("CVV", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: cvvController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "CVV",
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                validator: (v) => v!.isEmpty ? "Required" : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pop<Map<String, String>>(context, {
                              'name': nameController.text,
                              'number': cardNumberController.text,
                              'expiry': expiryController.text,
                              'cvv': cvvController.text,
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 253, 85, 85),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("Add"),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}