import 'package:flutter/material.dart';
import 'package:laundry_app/manage_promo_screen.dart';

import 'splash_screen.dart';
import 'choice_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'forgot_screen.dart';
import 'reset_password_screen.dart';
import 'dashboard_screen.dart';
import 'dashboard_admin_screen.dart';
import 'order_screen.dart';
import 'checkout_screen.dart';
import 'payment_screen.dart';
import 'riwayat_screen.dart';
import 'status_screen.dart';
import 'check_resi_screen.dart';
import 'lihat_status_screen.dart';
import 'ubah_status_screen.dart';
import 'add_promo_screen.dart';
import 'input_notifikasi_screen.dart';
import 'admin_profile_screen.dart';
import 'profile_user_screen.dart';
import 'main_navigation_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF006064),
        brightness: Brightness.light,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/choice': (context) => const ChoiceScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot': (context) => const ForgotScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(
          username: '',
        ), // fallback, biasanya dipanggil via push with param
        '/order': (context) => const OrderScreen(),
        '/riwayat': (context) => const RiwayatScreen(
          fullName: '',
        ), // fallback if needed; prefer passing real arg
        '/status': (context) => const StatusScreen(fullName: ''),
        '/admin': (context) => DashboardAdminScreen(),
        '/lihat_status_screen': (context) {
          final data =
              ModalRoute.of(context)!.settings.arguments as List<String>;
          return LihatStatusScreen(data: data);
        },
        '/manage_promo': (context) => ManagePromoScreen(),
        '/add_promo': (context) => AddPromoScreen(),
        '/ubah_status': (context) => UbahStatusScreen(),
        '/input_notifikasi': (context) => InputNotifikasiScreen(),
        '/user_profile': (context) => ProfileUserScreen(),
        '/profile_admin': (context) => AdminProfileScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },

      onGenerateRoute: (settings) {
        final name = settings.name;
        final args = settings.arguments;

        if (name == '/checkout') {
          if (args is Map<String, String>) {
            return MaterialPageRoute(
              builder: (_) => CheckoutScreen(data: args),
              settings: settings,
            );
          }
        }

        if (name == '/payment') {
          if (args is Map<String, String>) {
            return MaterialPageRoute(
              builder: (_) => PaymentScreen(data: args),
              settings: settings,
            );
          }
        }

        if (name == '/check_resi') {
          if (args is List<String>) {
            return MaterialPageRoute(
              builder: (_) => CheckResiScreen(data: args),
              settings: settings,
            );
          }
        }

        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Route Error")),
            body: Center(child: Text("Route tidak ditemukan: $name")),
          ),
        );
      },
    );
  }
}
