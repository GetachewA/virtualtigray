import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/professionals/professionals_list_screen.dart';
import '../screens/tradespeople/tradespeople_list_screen.dart';
import '../screens/education/education_screen.dart';
import '../screens/business/business_list_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/notifications/notifications_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/role-selection':
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case '/professionals':
        return MaterialPageRoute(
            builder: (_) => const ProfessionalsListScreen());
      case '/tradespeople':
        return MaterialPageRoute(
            builder: (_) => const TradespeopleListScreen());
      case '/education':
        return MaterialPageRoute(builder: (_) => const EducationScreen());
      case '/businesses':
        return MaterialPageRoute(builder: (_) => const BusinessListScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
