import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Add this import
import 'package:flutter/foundation.dart'; // Required for kReleaseMode
import 'screens/home_screen.dart';

void main() {
  runApp(
    DevicePreview(
      // Only enable preview in debug mode, not in the final APK
      enabled: !kReleaseMode,
      builder: (context) => const TransitTrackApp(),
    ),
  );
}

class TransitTrackApp extends StatelessWidget {
  const TransitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Tracking App',
      debugShowCheckedModeBanner: false,

      // These 3 lines are REQUIRED for Device Preview to work:
      // useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE94560),
          brightness: Brightness.dark,
          primary: const Color(0xFFE94560),
          surface: const Color(0xFF1A1A2E),
        ),
        scaffoldBackgroundColor: const Color(0xFF16213E),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
