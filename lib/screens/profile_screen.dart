import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:shopping_list/helper/preference.dart';
import 'package:shopping_list/helper/routes.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});
  // static const String id =   '/profile_screen';

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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await DBHELPER13.getUserById(widget.userId);
    if (user != null) {
      setState(() {
        nama = user.name ?? '-';
        username = user.username ?? '-';
        email = user.email;
        phoneNumber = user.phone ?? '-';
      });
    } else {
      print("User with ID ${widget.userId} not found in database.");

      _logout();
    }
  }

  // fungsi log out
  Future<void> _logout() async {
    await PreferenceHandler.deleteLogin();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
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
                nama, // u/ mengambil data Nama dari database berdasarkan userId
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
                      username, // u/ mengambil data username dari database berdasarkan userId
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
                    ), // u/ mengambil data email dari database berdasarkan userId
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
                    ), // u/ mengambil data no hp dari database berdasarkan userId
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
                  // tmbl edit
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // fungsi edit nanti bisa navigasi ke halaman edit profil
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EditProfileScreen(userId: widget.userId),
                          ),
                        );
                        if (updated == true) {
                          // Refresh data profil setelah melakukan perubahan
                          _loadUserData();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('Edit')),
                      ),
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
