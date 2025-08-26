import 'package:flutter/material.dart';
import 'package:project_artee/page/home_page.dart';
import 'package:project_artee/views/home_view.dart';
import 'package:project_artee/views/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future sing_up() async {
    String url =
        "http://10.244.22.218/project_work/register.php"; // Add your registration URL here
    final response = await http.post(
      Uri.parse(url),
      body: {'username': userController.text, 'password': passController.text},
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.account_circle, size: 200),
                  const Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: userController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อผู้ใช้';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ยังไม่ได้สมัครสมาชิก?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterView(),
                            ),
                          );
                        },
                        child: const Text("สมัครสมาชิก"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
