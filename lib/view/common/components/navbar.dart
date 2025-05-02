import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  String _getCurrentRoute(BuildContext context) =>
      ModalRoute.of(context)?.settings.name ?? '/home';

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute(context);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavbarItem(
            icon: PhosphorIcons.houseSimple(
              currentRoute == '/home'
                  ? PhosphorIconsStyle.fill
                  : PhosphorIconsStyle.regular,
            ),
            callback: () {
              if (currentRoute != '/home') {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ).toIconButton(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.green[800],
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(12),
            child:
                BottomNavbarItem(
                  icon: PhosphorIcons.scan(
                    currentRoute == '/scan'
                        ? PhosphorIconsStyle.fill
                        : PhosphorIconsStyle.regular,
                  ),
                  color: Colors.white,
                  callback: () {
                    if (currentRoute != '/scan') {
                      Navigator.pushNamed(context, '/scan');
                    }
                  },
                ).toIconButton(),
          ),
          BottomNavbarItem(
            icon: PhosphorIcons.clockCountdown(
              currentRoute == '/tabs'
                  ? PhosphorIconsStyle.fill
                  : PhosphorIconsStyle.regular,
            ),
            callback: () {
              if (currentRoute != '/tabs') {
                Navigator.pushReplacementNamed(context, '/tabs');
              }
            },
          ).toIconButton(),
        ],
      ),
    );
  }
}

class BottomNavbarItem {
  const BottomNavbarItem({
    required this.icon,
    required this.callback,
    this.color = Colors.black,
  });

  final Color color;
  final PhosphorIconData icon;
  final void Function() callback;

  Widget toIconButton() {
    return IconButton(
      icon: PhosphorIcon(icon, size: 30, color: color),
      onPressed: callback,
    );
  }
}
