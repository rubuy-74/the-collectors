import 'package:usettle/view/home/pending_invoice_card.dart';
import 'package:usettle/view/common/pages/general.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:usettle/view/home/summary_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends GeneralPageViewState<HomePage> {
  @override
  String? getTitle() => null;

  @override
  Widget getBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 15.0),
                    child: Image.asset(
                      'assets/imgs/extended_logo.png',
                      height: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Faturas Pendentes",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/history');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        PendingInvoiceCard(
                          amount: "20 €",
                          date: "1 de maio 2025",
                          avatarUrls: const [
                            'assets/imgs/profile_pics/Andre.png',
                            'assets/imgs/profile_pics/Sofia.png',
                            'assets/imgs/profile_pics/Marcelo.png',
                          ],
                        ),
                        const SizedBox(width: 16.0),
                        PendingInvoiceCard(
                          amount: "15 €",
                          date: "1 de maio 2025",
                          avatarUrls: const [
                            'assets/imgs/profile_pics/Huang.png',
                            'assets/imgs/profile_pics/Tiago.jpg',
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  Text(
                    "Resumo Contas",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SummaryCard(
                    title: "Devem-me",
                    amount: "42,30€",
                    peopleCount: 4,
                    actionText: "PEDIR",
                    iconWidget: Image.asset(
                      'assets/imgs/mb-way-black.png',
                      height: 30,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    isOwedToUser: true,
                  ),
                  const SizedBox(height: 16.0),
                  SummaryCard(
                    title: "Eu Devo",
                    amount: "14,00€",
                    peopleCount: 2,
                    actionText: "LIQUIDAR",
                    iconWidget: PhosphorIcon(
                      PhosphorIconsRegular.fingerprint,
                      size: 30,
                      color: Colors.black87,
                    ),
                    isOwedToUser: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
