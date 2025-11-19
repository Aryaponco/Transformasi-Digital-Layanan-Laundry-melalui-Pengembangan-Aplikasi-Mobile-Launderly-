import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameC = TextEditingController();
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passC = TextEditingController();
  bool hidePass = true;

  Future<void> registerUser() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];

    if (usernameC.text.isEmpty ||
        nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        phoneC.text.isEmpty ||
        passC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    bool exists = users.any((u) => u.split('|')[0] == usernameC.text.trim());
    if (exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Username sudah digunakan")));
      return;
    }

    users.add(
      '${usernameC.text}|${nameC.text}|${emailC.text}|${phoneC.text}|${passC.text}',
    );
    await prefs.setStringList('users', users);

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                "Buat Akun Baru",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006064),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              _input("Username", Icons.person_outline, usernameC),
              const SizedBox(height: 18),

              _input("Nama Lengkap", Icons.badge_outlined, nameC),
              const SizedBox(height: 18),

              _input("Email", Icons.email_outlined, emailC),
              const SizedBox(height: 18),

              _input(
                "Nomor HP",
                Icons.phone_iphone,
                phoneC,
                type: TextInputType.phone,
              ),
              const SizedBox(height: 18),

              _passwordInput(),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Daftar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordInput() {
    return TextField(
      controller: passC,
      obscureText: hidePass,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF00BCD4)),
        suffixIcon: IconButton(
          icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => hidePass = !hidePass),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 2),
        ),
      ),
    );
  }

  Widget _input(
    String label,
    IconData icon,
    TextEditingController c, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF00BCD4)),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 2),
        ),
      ),
    );
  }
}
