import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';

class MenuAnimation extends StatefulWidget {
  const MenuAnimation({super.key});

  @override
  State<MenuAnimation> createState() => _MenuAnimationState();
}

class _MenuAnimationState extends State<MenuAnimation> {
  final GlobalKey<FabCircularMenuPlusState> fabKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // if (fabKey.currentState!.isOpen) {
              //   fabKey.currentState!.close();
              // } else {
              //   fabKey.currentState!.open();
              // }
            },
            child: Text('Click Me'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder:
            (context) => FabCircularMenuPlus(
              key: fabKey,

              // Modification
              alignment: Alignment.bottomCenter,
              ringColor: Colors.white.withAlpha(25),
              ringDiameter: 400.0,
              ringWidth: 100.0,
              fabSize: 64.0,
              fabElevation: 8.0,
              fabIconBorder: CircleBorder(),
              fabOpenColor: Colors.red,
              fabCloseColor: Colors.green,
              fabColor: Colors.white,
              fabOpenIcon: Icon(Icons.menu, color: Colors.white),
              fabCloseIcon: Icon(Icons.close, color: Colors.white),
              fabMargin: const EdgeInsets.all(16.0),
              animationDuration: const Duration(milliseconds: 800),
              animationCurve: Curves.easeInOutCirc,
              onDisplayChange: (isOPen) {

              },
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {},
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(24.0),
                  child: Icon(Icons.home, color: Colors.white),
                ),
                RawMaterialButton(
                  onPressed: () {},
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(24.0),
                  child: Icon(Icons.people, color: Colors.white),
                ),
              ],
            ),
      ),
    );
  }
}
