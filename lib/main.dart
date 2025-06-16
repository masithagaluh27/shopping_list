import 'package:flutter/material.dart';
import 'package:shopping_list/helper/routes.dart';
import 'package:shopping_list/screens/login_screen.dart';
import 'package:shopping_list/screens/profile_screen.dart';
import 'package:shopping_list/screens/register_screen.dart';
import 'package:shopping_list/screens/shopping_list_screen.dart';
import 'package:shopping_list/screens/statistik_screen.dart';
import 'package:shopping_list/utils/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Belanja',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),

        AppRoutes.shoppingList: (context) {
          final int userId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return ShoppingListScreen(userId: userId);
        },

        //karena butuh data dr luar u/ bag id jd seperti ini
        AppRoutes.statistik: (context) {
          final int userId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return StatistikScreen(userId: userId); //u/ kirm id ke constructorny
        },

        AppRoutes.profile: (context) {
          final int userId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return ProfileScreen(userId: userId);
        },
      },
    );
  }
}

//ini comment
