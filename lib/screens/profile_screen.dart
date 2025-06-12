import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String id =
      '/profile_screen'; // ID route untuk navigasi antar halaman

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variabel yg akn mnympan informasi profil user
  String nama = '-';
  String username = '-';
  String email = '-';
  String phoneNumber = '-';

  @override
  void initState() {
    super.initState();
    dataUser();
  }

  // untuk mengambil data user dari SharedPreferences
  Future<void> dataUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // u/ mengambil setiap data. pakai '-' jika data kosong/null
      nama = prefs.getString('nama') ?? '-';
      username = prefs.getString('username') ?? '-';
      email = prefs.getString('email') ?? '-';
      phoneNumber = prefs.getString('no_hp') ?? '-';
    });
  }

  // fungsi log out
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // untk menghapus semua data yg tersimpan
    Navigator.pushReplacementNamed(context, '/login'); //diarahkn ke log in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // menghapus tombol login dg PAKSA!!!
        backgroundColor: const Color(0xffC4D9FF),
        centerTitle: true,
        title: const Text('Profil Lengkap'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Foto Profil
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    // u/ Gradien warna profile
                    colors: [
                      Color.fromARGB(255, 245, 0, 163),
                      Color.fromARGB(136, 255, 115, 0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: CircleAvatar(
                    //gambar di profil
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/cutebear.JPEG'),
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),

            // Teks Nama Pengguna
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                nama, // u/ mengambil data Nama dari SharedPreferences dari register
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_2_outlined, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      username, // u/ mengambil data username dari SharedPreferences dari register
                    ), //
                  ],
                ),
              ),
            ),

            // Informasi Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      email,
                    ), // u/ mengambil data email dari SharedPreferences dari register
                  ],
                ),
              ),
            ),

            // Nomor Telepon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone_android_rounded,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      phoneNumber,
                    ), // u/ mengambil data no hp dari SharedPreferences dari register
                    const Spacer(),
                  ],
                ),
              ),
            ),

            // tombol: "Edit" dan "Log Out"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // tmbl edit (beluum diberi fungsi)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('edit')),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Tombol Logout
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          _logout, // Ketika ditekn akn menjalankan fungsi logout
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
