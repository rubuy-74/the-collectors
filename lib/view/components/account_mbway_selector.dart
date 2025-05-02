import 'package:flutter/material.dart';

enum AccountType { conta, mbway }

class AccountMbwaySelector extends StatefulWidget {
  const AccountMbwaySelector({super.key});

  @override
  State<AccountMbwaySelector> createState() => _AccountMbwaySelectorState();
}

class _AccountMbwaySelectorState extends State<AccountMbwaySelector> {
  Set<AccountType> selection = {AccountType.mbway};

  @override
  Widget build(BuildContext context) {
    final String mbwayImagePath =
        selection.contains(AccountType.mbway)
            ? 'assets/imgs/mb-way-white.png'
            : 'assets/imgs/mb-way-black.png';

    return SegmentedButton<AccountType>(
      segments: <ButtonSegment<AccountType>>[
        ButtonSegment<AccountType>(
          value: AccountType.conta,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person_add_alt_1_outlined),
              SizedBox(width: 8),
              Text('Conta'),
            ],
          ),
        ),
        ButtonSegment<AccountType>(
          value: AccountType.mbway,
          label: Image.asset(mbwayImagePath, height: 20),
        ),
      ],
      selected: selection,
      onSelectionChanged: (Set<AccountType> newSelection) {
        if (newSelection.isNotEmpty) {
          setState(() {
            selection = {newSelection.first};
          });
        }
      },
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Colors.green[700],
        selectedForegroundColor: Colors.white,
      ),
      showSelectedIcon: false,
      multiSelectionEnabled: false,
      emptySelectionAllowed: false,
    );
  }
}
