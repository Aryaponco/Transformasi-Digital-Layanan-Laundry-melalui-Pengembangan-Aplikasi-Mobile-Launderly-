import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputNotifikasiScreen extends StatefulWidget {
  @override
  State<InputNotifikasiScreen> createState() => _InputNotifikasiScreenState();
}

class _InputNotifikasiScreenState extends State<InputNotifikasiScreen> {
  final titleCtrl = TextEditingController();
  final notifCtrl = TextEditingController();

  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    notifications = prefs.getStringList("notifications") ?? [];
    setState(() {});
  }

  Future<void> saveNotif() async {
    if (titleCtrl.text.trim().isEmpty || notifCtrl.text.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    String title = titleCtrl.text.trim();
    String message = notifCtrl.text.trim();

    notifications.add("$title|$message");
    await prefs.setStringList("notifications", notifications);

    titleCtrl.clear();
    notifCtrl.clear();
    setState(() {});
  }

  Future<void> editNotif(int index) async {
    final split = notifications[index].split("|");
    final editTitleCtrl = TextEditingController(text: split[0]);
    final editMsgCtrl = TextEditingController(text: split[1]);

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Edit Notifikasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitleCtrl,
                decoration: InputDecoration(labelText: "Judul"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: editMsgCtrl,
                maxLines: 3,
                decoration: InputDecoration(labelText: "Isi Notifikasi"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00BCD4),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();

                notifications[index] =
                    "${editTitleCtrl.text.trim()}|${editMsgCtrl.text.trim()}";

                await prefs.setStringList("notifications", notifications);

                Navigator.pop(ctx);
                setState(() {});
              },
              child: Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteNotif(int index) async {
    final prefs = await SharedPreferences.getInstance();
    notifications.removeAt(index);
    await prefs.setStringList("notifications", notifications);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        title: const Text(
          "Kelola Notifikasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // JUDUL NOTIF
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: "Judul Notifikasi",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00BCD4), width: 2),
                ),
              ),
            ),

            SizedBox(height: 12),

            // ISI NOTIF
            TextField(
              controller: notifCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Isi Notifikasi",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00BCD4), width: 2),
                ),
              ),
            ),

            SizedBox(height: 12),

            // BUTTON KIRIM
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveNotif,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00BCD4),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Kirim Notifikasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daftar Notifikasi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Text(
                        "Belum ada notifikasi",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final split = notifications[index].split("|");
                        String title = split[0];
                        String message = split[1];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications_rounded,
                                color: Colors.teal,
                                size: 30,
                              ),
                              SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      message,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => editNotif(index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteNotif(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
