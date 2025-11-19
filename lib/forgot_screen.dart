import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reset_password_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final usernameC = TextEditingController();

  Future<void> checkUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];

    String username = usernameC.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Masukkan username')));
      return;
    }

    // Cari user
    bool exists = users.any((u) => u.split('|')[0] == username);

    if (!exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Username tidak ditemukan')));
      return;
    }

    // Jika ditemukan, arahkan ke halaman reset password
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(username: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: usernameC,
              decoration: InputDecoration(
                labelText: 'Masukkan Username',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: checkUsername,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 55),
              ),
              child: Text('Lanjut'),
            ),
          ],
        ),
      ),
    );
  }
}
