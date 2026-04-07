import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fasting_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FastingProvider(),
      child: MaterialApp(
        title: 'Controle de Jejum',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/settings':
              return MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
          }
        },
      ),
    );
  }
}
