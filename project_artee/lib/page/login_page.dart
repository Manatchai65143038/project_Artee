import 'package:flutter/material.dart';
import 'package:project_artee/services/login_api_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  String? errorMessage;

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      setState(() => loading = false);

      // TODO: Save token และนำไปหน้าอื่น
      print("Login สำเร็จ: ${result['staff']}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login สำเร็จ")));
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "กรุณากรอก Email"
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "กรุณากรอก Password"
                                : null,
                  ),
                  const SizedBox(height: 24),
                  loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: handleLogin,
                        child: const Text("Login"),
                      ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
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
