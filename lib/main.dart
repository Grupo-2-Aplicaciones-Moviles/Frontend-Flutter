import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'data/services/api_client.dart';
import 'data/services/api_services.dart';
import 'providers/providers.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inyección de dependencias manual (equivalente a AppModule/NetworkModule con Hilt)
  final tokenManager = TokenManager();
  final apiClient = ApiClient(tokenManager: tokenManager);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: AuthService(apiClient),
            tokenManager: tokenManager,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => VehicleProvider(
            vehicleService: VehicleService(apiClient),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(
            bookingService: BookingService(apiClient),
          ),
        ),
      ],
      child: const WeRideApp(),
    ),
  );
}

class WeRideApp extends StatelessWidget {
  const WeRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeRide',
      debugShowCheckedModeBanner: false,
      theme: weRideTheme(),
      home: const SplashScreen(),
    );
  }
}
