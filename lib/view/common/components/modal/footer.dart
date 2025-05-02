import 'package:flutter/cupertino.dart';

class ModalFooter extends StatelessWidget {
  final double total;

  const ModalFooter({required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            "Total",
          ),
          Text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            "${total.toStringAsFixed(2)}€",
          ),
        ],
      ),
    );
  }
}
