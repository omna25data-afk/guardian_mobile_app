import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guardian_app/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'بوابة الأمين الشرعي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006400),
          primary: const Color(0xFF006400),
          secondary: const Color(0xFF004d00),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: GoogleFonts.tajawalTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.tajawal(textStyle: textTheme.bodyMedium),
        ),
        appBarTheme: const AppBarTheme(
           backgroundColor: Color(0xFF006400),
           foregroundColor: Colors.white,
           elevation: 2,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}
