import 'package:flutter/material.dart';
import 'package:shopping_list/screens/add_item_screen.dart';
import 'package:shopping_list/screens/login_screen.dart';
import 'package:shopping_list/screens/register_screen.dart';
import 'package:shopping_list/screens/setting_screen.dart';
import 'package:shopping_list/screens/shopping_list_screen.dart';
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
      initialRoute: '/', //ini connect ke page awal yg kita mau
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/shopping_list': (context) => const ShoppingListScreen(),
        '/add_item': (context) => const AddItemScreen(),

        // '/edit_item': (context) => const EditItemScreen(),
        '/statistics': (context) => const SettingScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        // SettingScreen.id (context) => const SettingScreen(),
      },
    );
  }
}
