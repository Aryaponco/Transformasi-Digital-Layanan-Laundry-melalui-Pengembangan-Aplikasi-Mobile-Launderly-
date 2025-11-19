import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, String>> promos = [];
  String currentName = "";

  @override
  void initState() {
    super.initState();
    _loadCurrentName();
    loadPromo();
  }

  Future<void> _loadCurrentName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentName = prefs.getString('fullName') ?? "Pengguna";
    });
  }

  Future<void> loadPromo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> raw = prefs.getStringList('promo') ?? [];

    promos = raw.map((e) {
      final p = e.split('|');
      return {'title': p[0], 'desc': p.length > 1 ? p[1] : ''};
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          children: [
            // ===== HEADER =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Halo, $currentName",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Layanan laundry cepat, bersih, dan terpercaya.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset('images/logo.png', width: 58),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ===== BANNER =====
            Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF00838F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.25,
                      child: Image.asset(
                        'images/banner.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "L A U N D E R L Y",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                        shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ===== MENU =====
            Row(
              children: [
                Expanded(
                  child: _menuBox(
                    context,
                    Icons.add_circle_outline_rounded,
                    "Pesanan",
                    "/order",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _menuBox(
                    context,
                    Icons.history_rounded,
                    "Riwayat",
                    "/riwayat",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _menuBox(
                    context,
                    Icons.local_shipping_outlined,
                    "Status",
                    "/status",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // ===== PROMO SECTION =====
            if (promos.isNotEmpty) ...[
              Text(
                "Promo Terbaru",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 14),

              Column(
                children: promos.map((p) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF006064),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          p['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Description (auto height, no overflow)
                        Text(
                          p['desc']!,
                          softWrap: true,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ===== MENU BOX WIDGET =====
  Widget _menuBox(BuildContext ctx, IconData icon, String title, String route) {
    return Material(
      color: const Color(0xFF00BCD4),
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(ctx, route),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
