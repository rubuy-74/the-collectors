import 'package:usettle/view/components/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIconsRegular.caretLeft,
            color: Color(0xFF696969),
            size: 30.0,
            semanticLabel: 'Back',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Fatura',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                '1 de maio 2025',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  // Changed from Column to Row
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center items horizontally
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center items vertically
                  children: [
                    // Column for the text elements
                    const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        Text(
                          'Quase lá...', // Changed text
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey, // Changed color
                            // fontWeight: FontWeight.bold, // Removed bold
                          ),
                        ),
                        Text(
                          'Confirma!',
                          style: TextStyle(
                            fontSize: 30, // Increased font size
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF008069),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ), // Add space between text and image
                    // Image on the right
                    Image.asset(
                      'assets/imgs/confirm_illustration.png',
                      height: 100, // Adjusted height
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return const UserInfoCard(
                      userName: 'Adriano',
                      amount: 2.30,
                    );
                  },
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            print('Confirm button pressed');
          },
          backgroundColor: Colors.green[800],
          elevation: 4.0,
          child: PhosphorIcon(
            PhosphorIcons.check(PhosphorIconsStyle.bold),
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
