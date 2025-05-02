import 'package:usettle/view/components/account_mbway_selector.dart';
import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key, required this.userName, required this.amount});

  final String userName;
  final double amount;

  @override
  Widget build(BuildContext context) {
    const Color lightGrey = Color(0xFFF0F0F0);
    const double borderRadius = 30.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: lightGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/imgs/placeholder_avatar.png'),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: const TextStyle(fontSize: 16)),
              Text(
                '${amount.toStringAsFixed(2)} \€',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 20.0),

          const AccountMbwaySelector(),
        ],
      ),
    );
  }
}
