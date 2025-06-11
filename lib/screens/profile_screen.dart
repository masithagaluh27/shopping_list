import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String id = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nama = '-';
  String username = '-';
  String email = '-';
  String phoneNumber = '-';

  @override
  void initState() {
    super.initState();
    dataUser();
  }

  Future<void> dataUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? '-';
      username = prefs.getString('username') ?? '-';
      email = prefs.getString('email') ?? '-';
      phoneNumber = prefs.getString('no_hp') ?? '-';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // untuk menghapus semua data login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //untuk membuang panah secara paksa!!!
        backgroundColor: const Color(0xffC4D9FF),

        centerTitle: true,
        title: const Text('Profil Lengkap'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Foto Profil
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
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
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/cutebear.JPEG'),
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),

            // Nama
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                nama,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // username
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
                    Text(username),
                  ],
                ),
              ),
            ),
            // Email
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
                    Text(email),
                  ],
                ),
              ),
            ),

            // phone number
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
                    Text(phoneNumber),
                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Tombol Postingan dan Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
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
                  Expanded(
                    child: GestureDetector(
                      onTap: _logout,
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
