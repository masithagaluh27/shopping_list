import 'package:flutter/material.dart';
import 'package:shopping_list/constant/app_style.dart'; // Assuming this file exists and is correct
import 'package:shopping_list/helper/preference.dart';
import 'package:shopping_list/helper/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String id = '/splash_screen'; // ID halaman untuk navigasi

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Fungsi untuk mengganti halaman setelah delay 3 detik
  void changePage() {
    Future.delayed(const Duration(seconds: 3), () async {
      // Cek status login dari SharedPreferences
      bool isLogin = await PreferenceHandler.getLogin();
      // Also get the userId if needed for the ShoppingListScreen navigation
      int? userId = await PreferenceHandler.getUserId();
      print(
        "isLogin: $isLogin, userId: $userId",
      ); // Debug log untuk status login dan userId

      // Jika sudah login, arahkan ke halaman utama (ShoppingListScreen)
      // Jika belum login, arahkan ke halaman login (LoginScreen)
      if (isLogin && userId != null) {
        // Navigasi ke halaman utama dan menghapus semua halaman sebelumnya dari stack
        // Using AppRoutes.shoppingList and passing the userId as arguments
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.shoppingList,
          (route) => false,
          arguments: userId, // Pass the userId to the ShoppingListScreen
        );
      } else {
        // Navigasi ke halaman login dan menghapus semua halaman sebelumnya dari stack
        // Using AppRoutes.login for consistency
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    });
  }

  @override
  void initState() {
    changePage(); // Panggil fungsi pindah halaman saat splash dimulai
    super.initState();
  }

  // UI Splash Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Tengah secara vertikal
          children: [
            const Spacer(), // Untuk memberi ruang di atas
            // Logo aplikasi dengan ukuran yang lebih kecil
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset('assets/images/notes.PNG'),
            ),

            const SizedBox(height: 20),

            // Nama aplikasi dengan style besar dan tebal
            const Text(
              "urnotes App",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xff9B7EBD),
              ),
            ),

            const Spacer(), // Untuk memberi ruang di bawah
            // Versi aplikasi (ditempatkan dengan SafeArea agar tidak menabrak pinggiran bawah layar)
            SafeArea(
              child: Text("v 1.0.0", style: AppStyle.fontRegular(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}

//splash screen
