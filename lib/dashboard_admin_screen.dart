import 'package:flutter/material.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile_admin'),
            icon: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ================================
              // HEADER
              // ================================
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset('images/logo.png', height: 55),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Selamat datang, Admin!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ================================
              // BANNER
              // ================================
              Container(
                height: 165,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BCD4), Color(0xFF00838F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
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
                        opacity: 0.2,
                        child: Image.asset(
                          "images/banner.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "L A U N D E R L Y",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(color: Colors.black45, blurRadius: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================================
              // STATISTICS TITLE
              // ================================
              Text(
                "Statistik Order",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade900,
                ),
              ),

              const SizedBox(height: 15),

              // ================================
              // STATISTICS ROW 1
              // ================================
              Row(
                children: [
                  Expanded(
                    child: _statsCard(
                      icon: Icons.pending_actions_rounded,
                      label: "Pending",
                      count: "12",
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _statsCard(
                      icon: Icons.autorenew_rounded,
                      label: "Proses",
                      count: "7",
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ================================
              // STATISTICS ROW 2
              // ================================
              Row(
                children: [
                  Expanded(
                    child: _statsCard(
                      icon: Icons.check_circle_rounded,
                      label: "Selesai",
                      count: "20",
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _statsCard(
                      icon: Icons.archive_outlined,
                      label: "Arsip",
                      count: "54",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // ================================
              // MENU GRID TITLE
              // ================================
              Text(
                "Menu Utama",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade900,
                ),
              ),

              const SizedBox(height: 18),

              // ================================
              // MENU GRID
              // ================================
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 18,
                childAspectRatio: 1,
                children: [
                  _adminMenuCard(
                    icon: Icons.add_circle_outline_rounded,
                    label: "Tambah Promo",
                    onTap: () => Navigator.pushNamed(context, '/add_promo'),
                  ),
                  _adminMenuCard(
                    icon: Icons.update_rounded,
                    label: "Ubah Status",
                    onTap: () => Navigator.pushNamed(context, '/status'),
                  ),
                  _adminMenuCard(
                    icon: Icons.notifications_active_rounded,
                    label: "Beri Notifikasi",
                    onTap: () =>
                        Navigator.pushNamed(context, '/input_notifikasi'),
                  ),
                  _adminMenuCard(
                    icon: Icons.list_alt_rounded,
                    label: "Kelola Promo",
                    onTap: () => Navigator.pushNamed(context, '/manage_promo'),
                  ),
                ],
              ),

              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // STAT CARD
  // =====================================================
  Widget _statsCard({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              fontSize: 30,
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MENU CARD
  // =====================================================
  Widget _adminMenuCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: const Color(0xFF00BCD4)),
              const SizedBox(height: 15),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
