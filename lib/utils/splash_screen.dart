import 'package:flutter/material.dart';
import 'package:shopping_list/constant/app_style.dart';
import 'package:shopping_list/helper/preference.dart';
import 'package:shopping_list/screens/login_screen.dart';
import 'package:shopping_list/screens/shopping_list_screen.dart'; // Import halaman utama

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
      print("isLogin: $isLogin"); // Debug log untuk status login

      // Jika sudah login, arahkan ke halaman utama
      // Jika belum login, arahkan ke halaman login
      if (isLogin) {
        // Navigasi ke halaman utama dan menghapus semua halaman sebelumnya dari stack
        Navigator.pushNamedAndRemoveUntil(
          context,
          ShoppingListScreen.id,
          (route) => false,
        );
      } else {
        // Navigasi ke halaman login dan menghapus semua halaman sebelumnya dari stack
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.id,
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
