import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../application/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();

                if (name.isEmpty) {
                  setState(() {
                    errorMessage = 'Введите имя';
                  });
                  return;
                }
                if (email.isEmpty || password.isEmpty) {
                  setState(() {
                    errorMessage = 'Введите email и пароль';
                  });
                  return;
                }

                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });

                final success = await auth.registerWithEmail(email, password, name);

                setState(() {
                  isLoading = false;
                });

                if (success) {
                  Navigator.pushReplacementNamed(context, '/main');
                } else {
                  setState(() {
                    errorMessage = 'Ошибка при регистрации';
                  });
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Зарегистрироваться"),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text("Уже есть аккаунт? Войти"),
            ),
          ],
        ),
      ),
    );
  }
}
