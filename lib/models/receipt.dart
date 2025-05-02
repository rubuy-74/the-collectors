import 'package:usettle/models/item.dart';

class Receipt {
  const Receipt({required this.total, required this.date, required this.items});

  final double total;
  final DateTime date;
  // qr code info
  final List<Item> items;
}
