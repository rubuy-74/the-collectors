import 'package:flutter/material.dart';

class ModalAccountHeader extends StatelessWidget {
  const ModalAccountHeader({super.key, required this.name, this.phoneNumber});

  final String name;
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // TODO: needs to not be hardcoded
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage("https://picsum.photos/200/300"),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                  "Conta",
                ),
                Text(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  name,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
