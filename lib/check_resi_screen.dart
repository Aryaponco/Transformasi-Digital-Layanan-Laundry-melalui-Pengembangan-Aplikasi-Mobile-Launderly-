import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CheckResiScreen extends StatelessWidget {
  final List<String> data;

  const CheckResiScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pesanan")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section("Layanan", data[0]),
          _section("Durasi", data[1]),
          _section("Berat", "${data[2]} kg"),
          _section("Alamat", data[3]),
          _section("Pengiriman", data[4]),
          _section("Pembayaran", data[5]),
          _section("Catatan", data[6].isEmpty ? "-" : data[6]),
          _section("Diskon", data[7]),
          _section("Tanggal", data[9]),

          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00BCD4),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: () async {
              await _downloadPDF();
            },
            child: const Text("Download Resi (PDF)"),
          ),

          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kembali"),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title)),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context ctx) => pw.Container(
          padding: pw.EdgeInsets.all(25),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "RESI LAUNDRY",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 15),

              _pdfRow("Layanan", data[0]),
              _pdfRow("Durasi", data[1]),
              _pdfRow("Berat", "${data[2]} kg"),
              _pdfRow("Alamat", data[3]),
              _pdfRow("Pengiriman", data[4]),
              _pdfRow("Pembayaran", data[5]),
              _pdfRow("Catatan", data[6].isEmpty ? "-" : data[6]),
              _pdfRow("Diskon", data[7]),
              _pdfRow("Tanggal", data[9]),

              pw.Spacer(),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  "Terima kasih telah menggunakan layanan kami",
                  style: pw.TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Share / Download sebagai file
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "resi_laundry_${data[9].replaceAll('/', '-')}.pdf",
    );
  }

  pw.Widget _pdfRow(String title, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(flex: 2, child: pw.Text(title)),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
