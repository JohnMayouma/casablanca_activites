import 'package:flutter/material.dart';

class BookEventScreen extends StatefulWidget {
  const BookEventScreen({super.key});

  @override
  State<BookEventScreen> createState() => _BookEventScreenState();
}

class _BookEventScreenState extends State<BookEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  String? _countryCode = "+91";
  String? _selectedCountry;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Dummy country list for dropdown
  final List<Map<String, String>> _countries = [
    {"name": "India", "code": "+91", "flag": "🇮🇳"},
    {"name": "France", "code": "+33", "flag": "🇫🇷"},
    {"name": "Morocco", "code": "+212", "flag": "🇲🇦"},
    {"name": "USA", "code": "+1", "flag": "🇺🇸"},
    {"name": "Senegal", "code": "+221", "flag": "🇸🇳"},
    {"name": "Other", "code": "+00", "flag": "🌐"},
  ];

  final List<String> _genders = ["Male", "Female", "Other"];

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onContinue() {
    if (_formKey.currentState!.validate() && _acceptedTerms) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      Navigator.pushNamed(
        context,
        '/payment',
        arguments: {
          // Forward all event/ticket info from previous screen
          'title': args?['title'],
          'selectedTickets': args?['selectedTickets'],
          'imageUrl': args?['imageUrl'],
          'date': args?['date'],
          'location': args?['location'],
          'description': args?['description'],
          // User info from this form
          "userFullName": _fullNameController.text,
          "userNickname": _nicknameController.text,
          "userGender": _selectedGender,
          "userEventDate": _selectedDate?.toIso8601String(),
          "userEmail": _emailController.text,
          "userPhone": "${_countryCode ?? ""}${_phoneController.text}",
          "userCountry": _selectedCountry,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réserver maintenant", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF7F7FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text(
                  "Contact Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: _inputDecoration("Full Name"),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),

                // Nickname
                TextFormField(
                  controller: _nicknameController,
                  decoration: _inputDecoration("Nickname"),
                ),
                const SizedBox(height: 12),

                // Gender
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Genre"),
                  value: _selectedGender,
                  items: _genders
                      .map((g) =>
                          DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGender = v),
                  validator: (v) => v == null ? "Required" : null,
                ),
                const SizedBox(height: 12),

                // Event Date
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: _inputDecoration("Event Date").copyWith(
                        suffixIcon: const Icon(Icons.calendar_today_rounded, size: 21),
                      ),
                      controller: TextEditingController(
                        text: _selectedDate == null
                            ? ""
                            : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                      ),
                      validator: (_) => _selectedDate == null ? "Required" : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email").copyWith(
                    suffixIcon: const Icon(Icons.mail_outline_rounded, size: 21),
                  ),
                  validator: (v) =>
                      v != null && v.contains("@") ? null : "Enter email valid",
                ),
                const SizedBox(height: 12),

                // Phone Number
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.transparent),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _countryCode,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: _countries.map((c) {
                            return DropdownMenuItem<String>(
                              value: c["code"],
                              child: Row(
                                children: [
                                  Text(c["flag"] ?? "🌐"),
                                  const SizedBox(width: 5),
                                  Text(c["code"] ?? ""),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (code) {
                            final found =
                                _countries.firstWhere((c) => c["code"] == code);
                            setState(() {
                              _countryCode = found["code"];
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration("Phone Number").copyWith(
                          prefixIcon: null,
                        ),
                        validator: (v) => v == null || v.isEmpty ? "Required" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Country select
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("sélectionner le pays"),
                  value: _selectedCountry,
                  items: _countries
                      .map((c) => DropdownMenuItem(
                          value: c["name"], child: Text(c["name"] ?? "")))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCountry = v),
                  validator: (v) => v == null ? "Required" : null,
                ),
                const SizedBox(height: 18),

                // Terms & Policy
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                      activeColor: const Color.fromARGB(255, 236, 60, 60),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            const TextSpan(text: "j'accepte pour cas@event les "),
                            _linkSpan("Conditions d'utilisation"),
                            const TextSpan(text: ", "),
                            _linkSpan("Directives de la communauté "),
                            const TextSpan(text: ", et "),
                            _linkSpan("Politique de confidentialité"),
                            const TextSpan(text: " (Required)"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 246, 77, 77),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Continue"),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black54),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    );
  }

  TextSpan _linkSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 82, 82),
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w500,
      ),
      // You can add gesture recognizer for clickable policy links here
    );
  }
}