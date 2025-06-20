import 'package:flutter/material.dart';

/// --- ÉCRANS D'INTRO & AUTHENTIFICATION ---
import 'screens/splash/splash_screen.dart';
import 'screens/select_user_type/select_user_type_screen.dart';
import 'screens/login/login_user_screen.dart';
import 'screens/login/login_partener_screen.dart';
import 'screens/auth/signup/signup_form.dart';
import 'screens/auth/signup/signupPartnerFormScreen.dart';
import 'screens/auth/signup/signup_policy.dart';
import 'screens/auth/signup/signup_otp.dart';
import 'screens/auth/signup/signup_qr_verification.dart';
import 'screens/auth/signup/signup_success.dart';
import 'screens/login/ForgotPasswordScreen.dart';

/// --- WRAPPER POUR LA NAVIGATION PRINCIPALE ---
import 'screens/main_wrapper.dart';
import 'screens/partner/partner_main_wrapper.dart';

/// --- ÉCRANS SECONDAIRES UTILISATEUR ---
import 'screens/details/details_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/confirmation/confirmation_screen.dart';
import 'screens/profile/profile_edit_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/avis/avis_et_plan.dart';
import 'screens/book_event_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cas@Event',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/', // Splash screen d'abord
      routes: {
        '/': (context) => const SplashScreen(),
        '/select_user_type': (context) => const SelectUserTypeScreen(),
        '/login_user': (context) => const LoginUserScreen(),
        '/login_partner': (context) => const LoginPartnerScreen(),

        /// Inscription multi-étapes
        '/signup': (context) => const SignupFormScreen(),
        '/signup_partner': (context) => const SignupPartnerFormScreen(),
        '/signup_policy': (context) => const SignupPolicyScreen(),
        '/signup_otp': (context) => const SignupOtpScreen(),
        '/signup_qr_verification': (context) => const SignupQrVerificationScreen(),
        '/signup_success': (context) => const SignupSuccessScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),

        /// Accès principal avec navbar persistante
        '/home': (context) => const MainWrapper(),
        '/partner_dashboard': (context) => const PartnerMainWrapper(),

        /// Pages secondaires (détail, paiement, etc.)
        '/details': (context) => const DetailsScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/confirmation': (context) => const ConfirmationScreen(),
        '/profile_edit': (context) => const ProfileEditScreen(),
        '/book_event': (context) => const BookEventScreen(),

        /// Autres modules
        '/map': (context) => const MapScreen(),
        '/avis': (context) => const AvisEtPlanScreen(),
      },
    );
  }
}