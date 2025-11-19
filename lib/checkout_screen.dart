import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, String> data;

  const CheckoutScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressC = TextEditingController();
  String delivery = 'Reguler';
  String payment = 'QRIS';

  int getDeliveryCost() => delivery == 'Express' ? 5000 : 1000;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final int basePrice = int.parse(d['price']!);
    final int finalPrice = basePrice + getDeliveryCost();

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _title("Alamat Pengiriman"),
          TextField(
            controller: addressC,
            maxLines: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: "Masukkan alamat lengkap",
            ),
          ),

          const SizedBox(height: 25),
          _title("Jenis Pengiriman"),
          _radio("Reguler", "Reguler +Rp1000", delivery, (v) {
            setState(() => delivery = v!);
          }),
          _radio("Express", "Express +Rp5000", delivery, (v) {
            setState(() => delivery = v!);
          }),

          const SizedBox(height: 25),
          _title("Rincian Pesanan"),

          _detail("Layanan", d['service']!),
          _detail("Durasi", d['day']!),
          _detail("Berat", "${d['weight']} kg"),
          _detail("Catatan", d['note']!.isEmpty ? "-" : d['note']!),
          _detail("Harga Dasar", "Rp ${d['price']}"),
          _detail("Biaya Pengiriman", "Rp ${getDeliveryCost()}"),

          const SizedBox(height: 10),
          Divider(),
          const SizedBox(height: 10),

          Text(
            "Total Akhir: Rp $finalPrice",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900,
            ),
          ),

          const SizedBox(height: 30),
          _title("Metode Pembayaran"),
          _radio("QRIS", "QRIS", payment, (v) {
            setState(() => payment = v!);
          }),
          _radio("Tunai", "Tunai", payment, (v) {
            setState(() => payment = v!);
          }),

          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BCD4),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 55),
            ),
            onPressed: () {
              if (addressC.text.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Alamat belum diisi")));
                return;
              }

              Navigator.pushNamed(
                context,
                '/payment',
                arguments: {
                  ...d,
                  'address': addressC.text,
                  'delivery': delivery,
                  'deliveryCost': getDeliveryCost().toString(),
                  'finalPrice': finalPrice.toString(),
                  'payment': payment,
                },
              );
            },
            child: Text("Lanjut ke Pembayaran"),
          ),
        ],
      ),
    );
  }

  Widget _title(String t) => Text(
    t,
    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  );

  Widget _radio(
    String val,
    String label,
    String group,
    Function(String?) onChange,
  ) {
    return RadioListTile(
      activeColor: const Color(0xFF00BCD4),
      value: val,
      groupValue: group,
      onChanged: onChange,
      title: Text(label),
    );
  }

  Widget _detail(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(title)),
          Expanded(
            flex: 4,
            child: Text(
              val,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
