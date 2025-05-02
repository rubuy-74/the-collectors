import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

class CustomTab {
  final String name;
  final Image? imageUrl;
  late double total = 0;
  bool owes = false;
  late final List<Transaction> transactions;

  CustomTab({required this.name, required this.transactions, this.imageUrl}) {
    total = transactions.map((e) => e.quantity).reduce((v, e) => v + e);
    owes = total < 0;
  }

  void updateTransactions(List<Transaction> transactions) {
    this.transactions = transactions;
    total = transactions.map((e) => e.quantity).reduce((v, e) => v + e);
    owes = total < 0;
  }
}

class Transaction {
  final DateTime time;
  final String description;
  final double quantity;

  const Transaction({
    required this.time,
    required this.description,
    required this.quantity,
  });
}

class TabScreen extends StatefulWidget {
  late CustomTab tab;

  TabScreen({super.key});

  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  static const Color _greyColor = Color(0xFF696969);
  static const Color _greenColor = Color(0xFF2A6E55);
  static const Color _redColor = Colors.red;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.tab = ModalRoute.of(context)!.settings.arguments as CustomTab;
  }

  Widget buildRow(Transaction transaction) {
    bool isOwed = transaction.quantity < 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isOwed ? Icons.arrow_downward : Icons.arrow_upward,
              color: isOwed ? Colors.red : _greenColor,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(transaction.time),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(transaction.description),
              ],
            ),
          ],
        ),
        Text(transaction.quantity.toStringAsFixed(2)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIconsRegular.caretLeft,
            color: _greyColor,
            size: 30.0,
            semanticLabel: 'Back',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                  child: Text('B', style: TextStyle(color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Minha Conta com',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        widget.tab.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Add some space after the heading
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.tab.owes ? 'Devo' : 'Deve-me',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.tab.total.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: widget.tab.owes ? _redColor : _greenColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: widget.tab.owes ? _redColor : _greenColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        widget.tab.owes ? 'Enviar' : 'Pedir',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount:
                    widget
                        .tab
                        .transactions
                        .length, // Based on the number of items in the image
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return buildRow(widget.tab.transactions.elementAt(index));
                  // You'll likely want to replace this with your actual transaction data
                },
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: YourExistingBottomNavigationBar(), // Add your existing navbar here
    );
  }
}
