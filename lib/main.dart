import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode)),
      ],
      child: const VirtualTigrayApp(),
    ),
  );
}

class VirtualTigrayApp extends StatelessWidget {
  const VirtualTigrayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Virtual Tigray',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          onGenerateRoute: AppRoutes.generateRoute,
          home: const SplashScreen(),
        );
      },
    );
  }
}
