import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPromoScreen extends StatefulWidget {
  @override
  State<AddPromoScreen> createState() => _AddPromoScreenState();
}

class _AddPromoScreenState extends State<AddPromoScreen> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  Future<void> savePromo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> raw = prefs.getStringList('promo') ?? [];

    raw.add("${titleCtrl.text.trim()}|${descCtrl.text.trim()}");

    await prefs.setStringList("promo", raw);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00BCD4),
        title: Text("Tambah Promo", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(labelText: "Judul Promo"),
            ),
            SizedBox(height: 15),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: "Deskripsi Promo"),
              maxLines: 3,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: savePromo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00BCD4),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
