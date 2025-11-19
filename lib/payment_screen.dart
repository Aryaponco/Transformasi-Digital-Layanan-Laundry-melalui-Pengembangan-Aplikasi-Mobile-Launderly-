import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, String> data;

  const PaymentScreen({Key? key, required this.data}) : super(key: key);

  Future<void> saveOrder(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> orders = prefs.getStringList('orders') ?? [];

    String row =
        '${data['service']}|${data['day']}|${data['weight']}|${data['address']}|${data['delivery']}|${data['payment']}|${data['note']}|0|Diterima|${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}';

    orders.add(row);
    await prefs.setStringList('orders', orders);

    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    String payment = data['payment']!;

    // Jika tunai, langsung simpan lalu redirect
    if (payment == 'Tunai') {
      saveOrder(context);
      return Scaffold(
        body: Center(
          child: Text("Mengalihkan...", style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran QRIS"),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Scan QRIS untuk menyelesaikan pembayaran",
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00BCD4), width: 2),
              ),
              child: Image.asset(
                "images/qris.jpg",
                height: 230,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 35),

            ElevatedButton(
              onPressed: () => saveOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 55),
              ),
              child: Text("Sudah Membayar"),
            ),
          ],
        ),
      ),
    );
  }
}
