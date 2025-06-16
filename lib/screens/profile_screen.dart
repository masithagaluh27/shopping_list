// ... import tetap
import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:shopping_list/helper/preference.dart';
import 'package:shopping_list/helper/routes.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});

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

      _logout(); // log out otomatis klo user ga ketemu
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

  // Fungsi utk menampilkan konfirmasi sebelum logout
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Apakah kamu yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _logout();
                },
                child: const Text(
                  'Ya, Keluar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE8F9FF),

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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android_rounded, color: Colors.blue),
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => EditProfileScreen(userId: widget.userId),
                          ),
                        );
                        if (updated == true) {
                          _loadUserData();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB3E5FC),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showLogoutConfirmation,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF5350),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
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
