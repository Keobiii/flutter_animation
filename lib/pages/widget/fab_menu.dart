import 'package:flutter/material.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';

class FabMenu extends StatelessWidget {
  const FabMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return FabCircularMenuPlus(
      alignment: const Alignment(0.0, 1.2), // move menu ring lower
      ringColor: Colors.white,
      ringDiameter: 500.0,
      ringWidth: 90.0,
      fabSize: 60.0,
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
        _chip('assets/images/chips/chip_5.png'),
        _chip('assets/images/chips/chip_10.png'),
        _chip('assets/images/chips/chip_25.png'),
        _chip('assets/images/chips/chip_50.png'),
        _chip('assets/images/chips/chip_100.png'),
        _chip('assets/images/chips/chip_500.png'),
        _chip('assets/images/chips/chip_1000.png'),
      ],
    );
  }

  Widget _chip(String assetPath) {
    return RawMaterialButton(
      onPressed: () {},
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 40,
        width: 40,
        child: Image.asset(assetPath, fit: BoxFit.fill),
      ),
    );
  }
}
