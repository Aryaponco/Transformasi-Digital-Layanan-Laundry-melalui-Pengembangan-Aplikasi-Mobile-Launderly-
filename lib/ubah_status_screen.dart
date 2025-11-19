import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbahStatusScreen extends StatefulWidget {
  @override
  State<UbahStatusScreen> createState() => _UbahStatusScreenState();
}

class _UbahStatusScreenState extends State<UbahStatusScreen> {
  List<Map<String, String>> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('orders') ?? [];

    orders = list.map((row) {
      final parts = row.split('|');
      return {
        'service': parts[0],
        'day': parts[1],
        'weight': parts[2],
        'address': parts[3],
        'delivery': parts[4],
        'payment': parts[5],
        'note': parts[6],
        'paid': parts[7],
        'status': parts[8],
        'time': parts[9],
      };
    }).toList();

    setState(() {});
  }

  Future<void> saveOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> newList = orders.map((o) {
      return '${o['service']}|${o['day']}|${o['weight']}|${o['address']}|${o['delivery']}|${o['payment']}|${o['note']}|${o['paid']}|${o['status']}|${o['time']}';
    }).toList();

    await prefs.setStringList('orders', newList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Status Pesanan"),
        backgroundColor: Color(0xFF00BCD4),
        foregroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final o = orders[index];
                return _orderCard(o, index);
              },
            ),
    );
  }

  // EMPTY STATE (CENTERED PERFECTLY)
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 90, color: Colors.grey.shade400),
          SizedBox(height: 15),
          Text(
            "Belum ada pesanan",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ORDER CARD
  Widget _orderCard(Map<String, String> o, int index) {
    return Container(
      padding: EdgeInsets.all(18),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _info("Layanan", o['service']),
          _info("Durasi", o['day']),
          _info("Berat", "${o['weight']} kg"),
          _info("Alamat", o['address']),
          _info("Pengiriman", o['delivery']),
          _info("Metode Bayar", o['payment']),
          _info("Status Saat Ini", o['status']),
          SizedBox(height: 10),

          Text(
            "Ubah Status",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),

          SizedBox(height: 8),

          _statusDropdown(o, index),

          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Status Dropdown (DI-MODERNKAN)
  Widget _statusDropdown(Map<String, String> o, int index) {
    final statuses = [
      "Diterima",
      "Diproses",
      "Dicuci",
      "Selesai",
      "Dikirim",
      "Sudah Diambil",
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF00BCD4), width: 1.7),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: SizedBox(),
        value: o['status'],
        items: statuses.map((s) {
          return DropdownMenuItem(
            value: s,
            child: Text(
              s,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            orders[index]['status'] = val!;
            saveOrders();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Status berhasil diperbarui"),
              backgroundColor: Color(0xFF00BCD4),
            ),
          );
        },
      ),
    );
  }

  // INFO ROW
  Widget _info(String title, String? val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(title, style: TextStyle(color: Colors.grey[700])),
          ),
          Expanded(
            flex: 5,
            child: Text(
              val ?? "-",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
