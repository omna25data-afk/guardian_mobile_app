import 'package:flutter/material.dart';
import 'package:guardian_app/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:guardian_app/services/guardian_repository.dart';
import 'package:guardian_app/providers/home_screen_provider.dart';
import 'package:guardian_app/providers/record_book_provider.dart';
import 'package:guardian_app/providers/registry_entry_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  final GuardianRepository repository = GuardianRepository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final GuardianRepository repository;

  // FIX: Use const and super parameters
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => RecordBookProvider(repository)),
        ChangeNotifierProvider(create: (_) => RegistryEntryProvider(repository)),
      ],
      child: MaterialApp(
        title: 'Guardian App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Tajawal',
        ),
        // FIX: Added const
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // FIX: Added const
        supportedLocales: const [
          Locale('ar', 'SA'),
        ],
        locale: const Locale('ar', 'SA'),
        debugShowCheckedModeBanner: false,
        // FIX: Added const
        home: const LoginScreen(),
      ),
    );
  }
}
