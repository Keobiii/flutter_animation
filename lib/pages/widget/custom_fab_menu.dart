import 'package:flutter/material.dart';

class CustomFabMenu extends StatefulWidget {
  const CustomFabMenu({super.key});

  @override
  State<CustomFabMenu> createState() => _CustomFabMenuState();
}

class _CustomFabMenuState extends State<CustomFabMenu> with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Menu Items Row
        Positioned(
          bottom: 90,
          left: 0,
          right: 0,
          child: SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChip('assets/images/chips/chip_5.png'),
                _buildChip('assets/images/chips/chip_10.png'),
                _buildChip('assets/images/chips/chip_25.png'),
                _buildChip('assets/images/chips/chip_50.png'),
                _buildChip('assets/images/chips/chip_100.png'),
              ],
            ),
          ),
        ),

        // FAB Button
        Positioned(
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: isOpen ? Colors.green : Colors.red,
            onPressed: toggleMenu,
            child: Icon(isOpen ? Icons.close : Icons.menu),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String assetPath) {
    return RawMaterialButton(
      onPressed: () => debugPrint('$assetPath pressed'),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 45,
        width: 45,
        child: Image.asset(assetPath, fit: BoxFit.fill),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
