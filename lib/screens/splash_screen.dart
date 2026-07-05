import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/providers.dart';
import 'auth/login_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final auth = context.read<AuthProvider>();
    await auth.checkSession();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            auth.isLoggedIn ? const MainShell() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.electric_scooter,
                size: 96, color: WeRideColors.energyGreen),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: WeRideColors.white),
                children: [
                  TextSpan(text: 'We'),
                  TextSpan(
                      text: 'Ride',
                      style: TextStyle(color: WeRideColors.energyGreen)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Micromovilidad eléctrica',
                style: TextStyle(color: WeRideColors.mediumGray)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: WeRideColors.energyGreen),
          ],
        ),
      ),
    );
  }
}
