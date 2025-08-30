import 'package:flutter/material.dart';
import 'package:project_artee/services/login_api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ยังไม่เสร็จ

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  String? error;

  void handleLogin() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data['token']);
      await prefs.setString("role", data['role']);

      // redirect ไปหน้าแรก
      Navigator.pushReplacementNamed(context, "/");
    } catch (e) {
      setState(() {
        error = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (error != null)
                    Text(error!, style: TextStyle(color: Colors.red)),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : handleLogin,
                      child:
                          loading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Login"),
                    ),
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
