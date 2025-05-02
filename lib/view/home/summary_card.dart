import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final int peopleCount;
  final String actionText;
  final Widget iconWidget;
  final bool isOwedToUser;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.peopleCount,
    required this.actionText,
    required this.iconWidget,
    required this.isOwedToUser,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4.0),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.userCircle(PhosphorIconsStyle.duotone),
                      size: 16.0,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      isOwedToUser
                          ? "$peopleCount pessoas"
                          : "a $peopleCount pessoas",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 10.0),
            Column(
              children: [
                iconWidget,
                const SizedBox(height: 8.0),
                Text(
                  actionText,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
