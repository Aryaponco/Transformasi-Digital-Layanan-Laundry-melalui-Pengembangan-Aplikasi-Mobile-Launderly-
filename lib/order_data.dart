class OrderData {
  String service;
  int days;
  int weight;
  String address; // Tambah alamat
  String delivery;
  String payment;
  String voucherCode;
  double discount;

  OrderData({
    required this.service,
    required this.days,
    required this.weight,
    required this.address,
    required this.delivery,
    required this.payment,
    required this.voucherCode,
    required this.discount,
  });

  // Harga sesuai desain (per kg)
  double get servicePrice {
    final prices = {
      'Cuci Kering': 4000.0,
      'Cuci + Lipat': 4500.0,
      'Cuci + Setrika + Lipat': 3500.0,
      'Setrika Saja': 3000.0,
      'Setrika + Lipat': 3500.0,
    };
    return prices[service]!;
  }

  // Biaya hari sesuai desain
  double get dayPrice {
    final prices = {1: 0.0, 2: 5000.0, 3: 3000.0};
    return prices[days]!;
  }

  // Biaya delivery sesuai desain
  double get deliveryPrice {
    final prices = {'Express': 1000.0, 'Reguler': 5000.0};
    return prices[delivery]!;
  }

  double get serviceFee => 2500.0; // Biaya layanan tetap

  // Kalkulasi: harga layanan * berat + biaya hari + delivery + service fee - discount
  double get subtotalService => servicePrice * weight + dayPrice;
  double get subtotalDelivery => deliveryPrice;
  double get total =>
      subtotalService + subtotalDelivery + serviceFee - discount;
}
