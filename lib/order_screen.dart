import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? selectedService;
  String? selectedDay;
  int weight = 1;
  final noteC = TextEditingController();

  final services = [
    {'nama': 'Cuci Kering', 'harga': 3000},
    {'nama': 'Cuci + Setrika', 'harga': 4000},
    {'nama': 'Setrika Saja', 'harga': 3500},
  ];

  final days = [
    {'hari': '1 Hari', 'tambah': 5000},
    {'hari': '2 Hari', 'tambah': 2500},
    {'hari': '3 Hari', 'tambah': 1000},
  ];

  int getTotalHarga() {
    // jika belum lengkap pilihan, kembalikan 0
    if (selectedService == null || selectedDay == null) return 0;

    try {
      // temukan service dan durasi berdasarkan nama yang dipilih
      final Map<String, dynamic> service = services.firstWhere(
        (e) => e['nama'] == selectedService,
      );
      final Map<String, dynamic> durasi = days.firstWhere(
        (e) => e['hari'] == selectedDay,
      );

      // cast aman ke int (jika data berupa string angka, coba parse juga)
      int base;
      if (service['harga'] is int) {
        base = service['harga'] as int;
      } else {
        base = int.tryParse('${service['harga']}') ?? 0;
      }

      int extra;
      if (durasi['tambah'] is int) {
        extra = durasi['tambah'] as int;
      } else {
        extra = int.tryParse('${durasi['tambah']}') ?? 0;
      }

      return (base + extra) * weight;
    } catch (e) {
      // jika terjadi apa-apa (mis. firstWhere gagal), jangan crash — beri 0
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        centerTitle: true,
        title: const Text(
          "Buat Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          sectionTitle("Pilih Layanan"),
          const SizedBox(height: 12),
          ...services.map((s) => _serviceCard(s)),
          const SizedBox(height: 30),

          sectionTitle("Pilih Durasi Hari"),
          const SizedBox(height: 12),
          ...days.map((d) => _dayCard(d)),
          const SizedBox(height: 30),

          sectionTitle("Berat Cucian (kg)"),
          const SizedBox(height: 10),
          _weightSelector(),
          const SizedBox(height: 30),

          sectionTitle("Catatan Pesanan (Opsional)"),
          const SizedBox(height: 10),
          _noteField(),
          const SizedBox(height: 28),

          _totalHargaBox(),
          const SizedBox(height: 30),

          _checkoutButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================= UI COMPONENTS =============================

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _serviceCard(Map<String, dynamic> data) {
    bool active = selectedService == data['nama'];

    return GestureDetector(
      onTap: () => setState(() => selectedService = data['nama']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF00BCD4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? const Color(0xFF00BCD4) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              Icons.local_laundry_service,
              size: 30,
              color: active ? Colors.white : const Color(0xFF00BCD4),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "${data['nama']} - Rp ${data['harga']}",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayCard(Map<String, dynamic> data) {
    bool active = selectedDay == data['hari'];

    return GestureDetector(
      onTap: () => setState(() => selectedDay = data['hari']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF00BCD4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? const Color(0xFF00BCD4) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              Icons.timer_rounded,
              size: 30,
              color: active ? Colors.white : const Color(0xFF00BCD4),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "${data['hari']} (+Rp ${data['tambah']})",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weightSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _cntBtn(Icons.remove, () {
          if (weight > 1) setState(() => weight--);
        }),
        const SizedBox(width: 28),
        Text(
          "$weight kg",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: 28),
        _cntBtn(Icons.add, () => setState(() => weight++)),
      ],
    );
  }

  Widget _cntBtn(IconData icon, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: const Color(0xFF00BCD4),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _noteField() {
    return TextField(
      controller: noteC,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Contoh: Jangan dicampur dengan pakaian putih",
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00BCD4), width: 2),
        ),
      ),
    );
  }

  Widget _totalHargaBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00BCD4)),
      ),
      child: Text(
        "Total Sementara: Rp ${getTotalHarga()}",
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: Color(0xFF006064),
        ),
      ),
    );
  }

  Widget _checkoutButton() {
    return ElevatedButton(
      onPressed: () {
        if (selectedService == null || selectedDay == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lengkapi semua pilihan!")),
          );
          return;
        }

        Navigator.pushNamed(
          context,
          '/checkout',
          arguments: {
            'service': selectedService!,
            'day': selectedDay!,
            'weight': weight.toString(),
            'note': noteC.text,
            'price': getTotalHarga().toString(),
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00BCD4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text("Lanjut ke Checkout"),
    );
  }
}
