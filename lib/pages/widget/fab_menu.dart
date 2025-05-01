import 'package:flutter/material.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';

class FabMenu extends StatelessWidget {
  const FabMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return FabCircularMenuPlus(
      alignment: Alignment.bottomCenter,
      ringColor: Colors.white,
      ringDiameter: 400.0,
      ringWidth: 100.0,
      fabSize: 64.0,
      fabElevation: 8.0,
      fabIconBorder: const CircleBorder(),
      fabOpenColor: Colors.red,
      fabCloseColor: Colors.green,
      fabColor: Colors.white,
      fabOpenIcon: const Icon(Icons.menu, color: Colors.white),
      fabCloseIcon: const Icon(Icons.close, color: Colors.white),
      fabMargin: const EdgeInsets.all(16.0),
      animationDuration: const Duration(milliseconds: 800),
      animationCurve: Curves.easeInOutCirc,
      onDisplayChange: (isOpen) {
        debugPrint('FAB menu is ${isOpen ? "open" : "closed"}');
      },
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {
            debugPrint('Home pressed');
          },
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(24.0),
          child: const Icon(Icons.home, color: Colors.black),
        ),
        RawMaterialButton(
          onPressed: () {
            debugPrint('People pressed');
          },
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(24.0),
          child: const Icon(Icons.people, color: Colors.black),
        ),
      ],
    );
  }
}
