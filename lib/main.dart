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
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna utama
      ),
      initialRoute: AppRoutes.splash, // Menggunakan konstanta dari AppRoutes
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        // Penting: userId sekarang diambil secara dinamis dari argumen rute.
        // Ini memungkinkan data spesifik pengguna ditampilkan.
        AppRoutes.shoppingList: (context) {
          // Mendapatkan userId dari argumen rute.
          // Jika tidak ada argumen yang diteruskan atau argumen bukan int, akan menggunakan default 0.
          final int userId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return ShoppingListScreen(userId: userId);
        },
        // Updated: StatistikScreen now also takes userId as an argument.
        AppRoutes.statistik: (context) {
          final int userId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return StatistikScreen(userId: userId);
        },
        // Updated: ProfileScreen now also takes userId as an argument.
        AppRoutes.profile: (context) {
          final int userId =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return ProfileScreen(userId: userId);
        },
        // Tambahkan route ID lainnya di bawah jika ada
        // AppRoutes.addItem: (context) => const AddItemScreen(),
      },
    );
  }
}
