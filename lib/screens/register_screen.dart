import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:shopping_list/helper/preference.dart';
import 'package:shopping_list/models/users_model.dart';

// Simpan data nama, email, dan noHp ke SharedPreferences
Future<void> simpanDataUser({
  required String nama,
  required String email,
  required String noHp,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('nama', nama);
  await prefs.setString('email', email);
  await prefs.setString('phone', noHp);
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String id = '/Register_screen_app';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      SizedBox(width: 20),
                      Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Register your account",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    'Email Address',
                    style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter some text'
                                : null,
                    decoration: InputDecoration(
                      hintText: 'example@gmail.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'Nama',
                    style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: nameController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter some text'
                                : null,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'Username',
                    style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: usernameController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter some text'
                                : null,
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: phoneController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter some text'
                                : null,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter some text'
                                : null,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffEA9459),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newUser = UserModel(
                            name: nameController.text,
                            username: usernameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                          );

                          // Simpan ke database dan ambil ID
                          int userId = await DBHELPER13.registerUser(
                            data: newUser,
                          );

                          // Simpan ke SharedPreferences
                          await simpanDataUser(
                            nama: nameController.text,
                            email: emailController.text,
                            noHp: phoneController.text,
                          );

                          // Simpan status login dan userId
                          await PreferenceHandler.saveLogin(true, userId);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registration Successful!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Navigasi ke login
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Have an account? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffEA9459),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
