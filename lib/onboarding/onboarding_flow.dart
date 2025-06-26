import 'dart:io';
import 'package:flutter/material.dart';
import "../models/user_profile.dart";
import 'complete_profile_screen.dart';
import 'set_location_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _gender;
  DateTime? _birthDate;
  File? _profileImage;

  void _onProfileFilled({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String gender,
    required DateTime? birthDate,
    File? profileImage,
  }) {
    setState(() {
      _firstName = firstName;
      _lastName = lastName;
      _email = email;
      _phone = phone;
      _gender = gender;
      _birthDate = birthDate;
      _profileImage = profileImage;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetLocationScreen(
          profileImagePath: profileImage?.path ?? '',
          firstName: firstName,
          lastName: lastName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompleteProfileScreen(onProfileFilled: _onProfileFilled);
  }
}