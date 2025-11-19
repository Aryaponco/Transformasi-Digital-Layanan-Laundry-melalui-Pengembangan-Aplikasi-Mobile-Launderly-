import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String username;

  const ResetPasswordScreen({Key? key, required this.username})
    : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passC = TextEditingController();
  bool hidePass = true;

  Future<void> updatePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];

    String newPass = passC.text.trim();

    if (newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password baru tidak boleh kosong')),
      );
      return;
    }

    List<String> updatedUsers = [];

    for (String user in users) {
      List<String> data = user.split('|');
      if (data[0] == widget.username) {
        // username|fullname|email|phone|password
        data[4] = newPass;
        updatedUsers.add(data.join('|'));
      } else {
        updatedUsers.add(user);
      }
    }

    await prefs.setStringList('users', updatedUsers);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Password berhasil diperbarui')));

    Navigator.popUntil(context, ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buat Password Baru')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: passC,
              obscureText: hidePass,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => hidePass = !hidePass);
                  },
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 55),
              ),
              child: Text('Simpan Password'),
            ),
          ],
        ),
      ),
    );
  }
}
