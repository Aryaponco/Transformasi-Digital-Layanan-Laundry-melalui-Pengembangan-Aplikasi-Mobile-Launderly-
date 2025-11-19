import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nameCtrl.text = prefs.getString('fullName') ?? '';
      _usernameCtrl.text = prefs.getString('username') ?? '';
      _emailCtrl.text = prefs.getString('email') ?? '';
      _phoneCtrl.text = prefs.getString('phone') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('fullName', _nameCtrl.text.trim());
    await prefs.setString('username', _usernameCtrl.text.trim());
    await prefs.setString('email', _emailCtrl.text.trim());
    await prefs.setString('phone', _phoneCtrl.text.trim());

    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));

    _loadProfile();
  }

  // ========================== EDIT DIALOG ==========================
  Future<void> _showEditDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit Profil",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 20),

                  _inputField("Nama Lengkap", _nameCtrl),
                  const SizedBox(height: 14),

                  _inputField("Username", _usernameCtrl),
                  const SizedBox(height: 14),

                  _inputField(
                    "Email",
                    _emailCtrl,
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  _inputField(
                    "Nomor HP",
                    _phoneCtrl,
                    type: TextInputType.phone,
                  ),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Batal",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BCD4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 2),
        ),
      ),
    );
  }

  // ========================== LOGOUT ==========================
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedUser');

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/choice', (_) => false);
  }

  // ========================== INFO CARD ==========================
  Widget _infoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ========================== UI ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profil Saya",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00BCD4),
        elevation: 1,
      ),

      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 10),

          // ========================== AVATAR ==========================
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xFF00BCD4),
                  child: const Icon(
                    Icons.person,
                    size: 65,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  _nameCtrl.text.isEmpty ? "Tidak ada nama" : _nameCtrl.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  "@${_usernameCtrl.text}",
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          _infoCard("Email", _emailCtrl.text),
          const SizedBox(height: 14),
          _infoCard("Nomor HP", _phoneCtrl.text),

          const SizedBox(height: 32),

          // ========================== EDIT BUTTON ==========================
          ElevatedButton.icon(
            onPressed: _showEditDialog,
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profil"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text("Logout", style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
