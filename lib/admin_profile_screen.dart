import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfileScreen extends StatefulWidget {
  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    nameCtrl.text = prefs.getString("adminName") ?? "Admin";
    emailCtrl.text = prefs.getString("adminEmail") ?? "admin@launderly.com";

    setState(() {});
  }

  Future<void> saveAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("adminName", nameCtrl.text.trim());
    await prefs.setString("adminEmail", emailCtrl.text.trim());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Data admin diperbarui")));
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("loggedAdmin");

    Navigator.pushNamedAndRemoveUntil(context, '/choice', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        elevation: 0,
        title: const Text(
          "Profil Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          // ========================= HEADER PROFILE =========================
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFF00BCD4),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  nameCtrl.text,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emailCtrl.text,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ========================= FORM INPUT =========================
          _inputField("Nama Admin", nameCtrl),
          _inputField("Email Admin", emailCtrl),

          const SizedBox(height: 25),

          // ========================= BUTTON SAVE =========================
          ElevatedButton(
            onPressed: saveAdminData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Simpan Perubahan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ========================= LOGOUT =========================
          OutlinedButton(
            onPressed: logout,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
