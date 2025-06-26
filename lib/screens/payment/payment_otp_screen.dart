import 'package:casablanca_activites/screens/confirmation/confirmation_screen.dart';
import 'package:flutter/material.dart';

class PaymentOtpScreen extends StatefulWidget {
  final String email;
  const PaymentOtpScreen({super.key, required this.email, required String sentOtp});

  @override
  State<PaymentOtpScreen> createState() => _PaymentOtpScreenState();
}

class _PaymentOtpScreenState extends State<PaymentOtpScreen> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  String? _error;
  late String _otp;

  @override
  void initState() {
    super.initState();
    
    // 🔐 Code OTP fixe pour test local uniquement
    _otp = '1234'; 
    print("Un code OTP $_otp a été envoyé à ${widget.email}");
  }

  @override
  void dispose() {
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp => _controllers.map((c) => c.text.trim()).join();

  void _validateOtp() {
    if (_enteredOtp == _otp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConfirmationScreen()),
      );
    } else {
      setState(() {
        _error = "Code incorrect. Veuillez réessayer.";
      });
    }
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        return SizedBox(
          width: 56,
          child: TextField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 28, letterSpacing: 1),
            decoration: InputDecoration(
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFAA7CFC), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (val) {
              if (val.length == 1 && i < 3) {
                FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
              }
              if (val.isEmpty && i > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
              }
              setState(() {
                _error = null;
              });
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmation de paiement")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Un code à 4 chiffres a été envoyé à ${widget.email} pour valider votre paiement.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 34),
            Center(child: _buildOtpFields()),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Color.fromARGB(255, 215, 0, 0), fontSize: 15),
                ),
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _enteredOtp.length == 4 ? _validateOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 248, 48, 48),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Valider et finaliser", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
