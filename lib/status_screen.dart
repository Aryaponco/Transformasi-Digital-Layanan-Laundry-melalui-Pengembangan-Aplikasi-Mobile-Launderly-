import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusScreen extends StatefulWidget {
  final String fullName;

  const StatusScreen({super.key, required this.fullName});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<List<String>> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> raw = prefs.getStringList('orders') ?? [];

    setState(() {
      orders = raw.map((e) => normalize(e.split('|'))).toList();
    });
  }

  // normalize ke 11 kolom
  List<String> normalize(List<String> x) {
    if (x.length < 11) {
      return [...x, ...List.filled(11 - x.length, '-')];
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status Pesanan")),
      body: orders.isEmpty
          ? Center(
              child: Text(
                "Belum ada pesanan",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final o = normalize(orders[i]);

                final service = o[0];
                final weight = o[2];
                final date = o[9];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header layanan
                      Text(
                        service,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // info ringan
                      Text(
                        "$weight kg • $date",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // tombol lihat status
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00BCD4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/lihat_status_screen',
                              arguments: o,
                            );
                          },
                          child: const Text(
                            "Lihat Status",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
