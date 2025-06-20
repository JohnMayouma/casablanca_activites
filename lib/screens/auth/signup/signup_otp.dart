import 'package:flutter/material.dart';

class SignupOtpScreen extends StatefulWidget {
  const SignupOtpScreen({super.key});

  @override
  State<SignupOtpScreen> createState() => _SignupOtpScreenState();
}

class _SignupOtpScreenState extends State<SignupOtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  int _secondsRemaining = 60;
  late final _timer;

  late String userType;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    userType = (args != null && args['type'] == 'partner') ? 'partner' : 'user';
  }

  void _startTimer() {
    _timer = Future.delayed(const Duration(seconds: 1), _tick);
  }

  void _tick() {
    if (!mounted) return;
    if (_secondsRemaining > 0) {
      setState(() => _secondsRemaining--);
      _startTimer();
    }
  }

  void _verifyOtp() {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length == 6) {
      Navigator.pushNamed(
        context,
        '/signup_success',
        arguments: {'type': userType},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer le code complet")),
      );
    }
  }

  void _switchToQr() {
    Navigator.pushNamed(
      context,
      '/signup_qr_verification',
      arguments: {'type': userType},
    );
  }

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPartner = userType == 'partner';
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/icons/logo.png', height: 80),
              const SizedBox(height: 20),
              Text(
                isPartner
                    ? 'Cas@Event | Partenaire - Vérification OTP'
                    : 'Cas@Event | Verification Code OTP',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2, color: Colors.red),
              const SizedBox(height: 20),
              const Text("Un mail vous a été envoyé sur manal******@ynov.com"),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: _otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Continuer"),
              ),
              const SizedBox(height: 12),
              Text("Expire dans $_secondsRemaining s"),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: const Text("Envoyer à nouveau."),
              ),
              TextButton(
                onPressed: _switchToQr,
                child: const Text("Scanner un QR Code"),
              )
            ],
          ),
        ),
      ),
    );
  }
}