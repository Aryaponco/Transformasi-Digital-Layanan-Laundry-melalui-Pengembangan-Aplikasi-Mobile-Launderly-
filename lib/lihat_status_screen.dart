import 'package:flutter/material.dart';

class LihatStatusScreen extends StatelessWidget {
  final List<String> data;

  const LihatStatusScreen({super.key, required this.data});

  List<String> normalize(List<String> d) {
    if (d.length < 11) {
      return [...d, ...List.filled(11 - d.length, '-')];
    }
    return d;
  }

  int mapStatusToIndex(String status) {
    final s = status.toLowerCase();
    if (s.contains("diterima") || s.contains("menunggu")) return 0;
    if (s.contains("dicuci") || s.contains("proses")) return 1;
    if (s.contains("disetrika")) return 2;
    if (s.contains("siap") || s.contains("selesai")) return 3;
    return 0;
  }

  IconData stepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.download_rounded;
      case 1:
        return Icons.local_laundry_service;
      case 2:
        return Icons.iron_rounded;
      case 3:
        return Icons.check_circle_rounded;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = normalize(data);

    final service = d[0];
    final duration = d[1];
    final weight = d[2];
    final address = d[3];
    final delivery = d[4];
    final payment = d[5];
    final note = d[6];
    final discount = d[7];
    final status = d[8];
    final date = d[9];

    final currentStep = mapStatusToIndex(status);

    const steps = ["Diterima", "Dicuci", "Disetrika", "Siap"];

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Status")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Status Pesanan",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF00BCD4).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    stepIcon(currentStep),
                    color: Color(0xFF00BCD4),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$weight kg • $duration • $date",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF00BCD4).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Color(0xFF00BCD4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (i) {
              final active = i <= currentStep;
              return Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: active ? 56 : 44,
                    height: active ? 56 : 44,
                    decoration: BoxDecoration(
                      color: active ? Color(0xFF00BCD4) : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      stepIcon(i),
                      color: Colors.white,
                      size: active ? 28 : 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    steps[i],
                    style: TextStyle(
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active ? Color(0xFF00BCD4) : Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 30),

          buildRow("Layanan", service),
          buildRow("Durasi", duration),
          buildRow("Berat", "$weight kg"),
          buildRow("Alamat", address),
          buildRow("Pengiriman", delivery),
          buildRow("Pembayaran", payment),
          buildRow("Catatan", note),
          buildRow("Diskon", discount),
          buildRow("Tanggal", date),

          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF006064),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Kembali"),
          ),
        ],
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
