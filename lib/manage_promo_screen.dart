import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagePromoScreen extends StatefulWidget {
  @override
  State<ManagePromoScreen> createState() => _ManagePromoScreenState();
}

class _ManagePromoScreenState extends State<ManagePromoScreen> {
  List<Map<String, String>> promos = [];

  @override
  void initState() {
    super.initState();
    loadPromo();
  }

  Future<void> loadPromo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> raw = prefs.getStringList('promo') ?? [];

    promos = raw.map((e) {
      final p = e.split('|');
      return {
        'title': p.isNotEmpty ? p[0] : '',
        'desc': p.length > 1 ? p[1] : '',
      };
    }).toList();

    setState(() {});
  }

  Future<void> savePromo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> raw = promos
        .map((p) => "${p['title'] ?? ''}|${p['desc'] ?? ''}")
        .toList();

    await prefs.setStringList('promo', raw);
  }

  Future<void> deletePromo(int index) async {
    if (index < 0 || index >= promos.length) return;

    promos.removeAt(index);
    await savePromo();
    loadPromo();
  }

  Future<void> editPromo(int index) async {
    if (index < 0 || index >= promos.length) return;

    TextEditingController titleCtrl = TextEditingController(
      text: promos[index]['title'],
    );
    TextEditingController descCtrl = TextEditingController(
      text: promos[index]['desc'],
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Promo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(labelText: "Judul Promo"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(labelText: "Deskripsi Promo"),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              promos[index]['title'] = titleCtrl.text.trim();
              promos[index]['desc'] = descCtrl.text.trim();
              await savePromo();
              Navigator.pop(context);
              loadPromo();
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Color(0xFF00BCD4),
        title: Text("Manajemen Promo", style: TextStyle(color: Colors.white)),
      ),

      body: promos.isEmpty
          ? Center(
              child: Text(
                "Belum ada promo.",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(18),
              itemCount: promos.length,
              itemBuilder: (context, index) {
                final promo = promos[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo['title'] ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        promo['desc'] ?? '',
                        style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                      ),

                      SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => editPromo(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00BCD4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text("Edit"),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => deletePromo(index),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
