import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:casablanca_activites/screens/welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoAnimation;
  late VideoPlayerController _videoController;
  bool _videoReady = false;
  bool _timerDone = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _logoAnimation = CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    );
    _logoAnimationController.forward();

    // 1. Initialisation vidéo en background
    _videoController = VideoPlayerController.network(
      'https://github.com/JohnMayouma/casablanca_assets/raw/main/casa_video.mp4',
    );
    _videoController.initialize().then((_) {
      _videoController.setVolume(0);
      _videoController.setLooping(true);
      setState(() {
        _videoReady = true;
      });
      _tryNavigate();
    });

    // 2. Timer splash
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _timerDone = true;
      });
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (_videoReady && _timerDone && !_navigated) {
      _navigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(videoController: _videoController),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    if (!_navigated) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoAnimation,
              child: Image.asset(
                'assets/icons/logo.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _logoAnimation,
              child: const Text(
                'Cas@Event',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(color: Colors.red)
          ],
        ),
      ),
    );
  }
}