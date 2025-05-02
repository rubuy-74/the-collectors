import 'package:usettle/view/common/components/payment_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BillCard extends StatelessWidget {
  final IconData logoIcon;
  final String name;
  final String date;
  final String time;
  final double amount;
  final int paidPercentage;
  final int participantCount;

  const BillCard({
    super.key,
    required this.logoIcon,
    required this.name,
    required this.date,
    required this.time,
    required this.amount,
    required this.paidPercentage,
    required this.participantCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(logoIcon, color: Colors.black54, size: 24),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '$date | $time',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildParticipantAvatars(participantCount),
                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 15),
                PaymentProgressIndicator(percentageValue: paidPercentage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build participant avatars
  Widget _buildParticipantAvatars(int count) {
    List<Color> avatarColors = [
      Colors.blue.shade100,
      Colors.pink.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100,
    ];
    List<IconData> avatarIcons = [
      Icons.person,
      Icons.face,
      Icons.account_circle,
      Icons.person_outline,
      Icons.emoji_emotions,
    ];

    const double avatarRadius = 12.0;
    const double overlap = 8.0;

    List<Widget> avatarWidgets = [];
    for (int i = 0; i < math.min(count, 5); i++) {
      avatarWidgets.add(
        Positioned(
          left: i * (2 * avatarRadius - overlap),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: avatarColors[i % avatarColors.length],
            child: Icon(
              avatarIcons[i % avatarIcons.length],
              size: 16,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    double stackWidth =
        (avatarWidgets.length * (2 * avatarRadius - overlap)) + overlap;
    if (avatarWidgets.isEmpty) {
      stackWidth = 0;
    } else if (avatarWidgets.length == 1) {
      stackWidth = 2 * avatarRadius;
    }

    return SizedBox(
      height: 2 * avatarRadius,
      width: stackWidth,
      child: Stack(children: avatarWidgets),
    );
  }
}
