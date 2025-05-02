import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:usettle/models/item.dart';
import 'package:usettle/models/participant.dart';
import 'package:usettle/models/profile.dart';
import 'package:usettle/models/receipt.dart';
import 'package:usettle/view/assignment/assignment.dart';
import 'package:usettle/view/history/invoices_history.dart';
import 'package:usettle/view/home/home.dart';
import 'package:usettle/view/invoice_confirm/confirmation_page.dart';
import 'package:usettle/view/scan/scanner.dart';
import 'package:usettle/view/contacts/contacts_selection.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:usettle/view/tabs/tab_screen.dart';
import 'package:usettle/view/tabs/tabs.dart';

Future<void> main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    print('Error: GEMINI_API_KEY not found in .env file');
    return;
  }
  Gemini.init(apiKey: apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _greenColor = Color(0xFF2A6E55);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'uSettle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _greenColor),
        //fontFamily: 'Monteserrat' TODO: change to the correct name
      ),
      home: HomePage(),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return _createRoute(const HomePage(), settings);
          case '/history':
            return _createRoute(const InvoicesHistoryPage(), settings);
          case '/scan':
            return _createRoute(const Scanner(), settings);
          case '/contacts':
            return _createRoute(ContactsSelectionPage(), settings);
          case '/confirmation':
            return _createRoute(const ConfirmationPage(), settings);
          case '/tabs':
            return _createRoute(TabsPage(), settings);
          case '/single-tab':
            return _createRoute(TabScreen(), settings);
          default:
            return null;
        }
      },
    );
  }
}

PageRouteBuilder _createRoute(Widget page, RouteSettings settings) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    settings: settings,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
