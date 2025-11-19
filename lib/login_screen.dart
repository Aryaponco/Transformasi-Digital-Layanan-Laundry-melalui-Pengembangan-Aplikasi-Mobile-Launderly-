import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameC = TextEditingController();
  final passC = TextEditingController();
  bool hidePass = true;

  Future<void> loginUser() async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('users') ?? [];

    final username = usernameC.text.trim();
    final password = passC.text.trim();

    // Admin login
    if (password == 'admin123') {
      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    for (String data in users) {
      final u = data.split('|');
      if (u.length < 5) continue;

      if (u[0] == username && u[4] == password) {
        await prefs.setString("loggedUser", username);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Username atau password salah")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // LOGO / ICON
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(
                      Icons.local_laundry_service,
                      color: Color(0xFF00BCD4),
                      size: 65,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    "Masuk ke Akun Anda",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006064),
                    ),
                  ),

                  const SizedBox(height: 35),

                  _input(
                    controller: usernameC,
                    label: "Username",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 18),

                  _input(
                    controller: passC,
                    label: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    hide: hidePass,
                    onToggle: () => setState(() => hidePass = !hidePass),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BCD4),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      "Belum punya akun? Daftar",
                      style: TextStyle(color: Color(0xFF00BCD4)),
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

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool hide = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? hide : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF00BCD4)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  hide ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggle,
              )
            : null,
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
