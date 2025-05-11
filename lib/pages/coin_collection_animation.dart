import 'dart:math';
import 'package:flutter/material.dart';

// class CoinCollectAnimation extends StatefulWidget {
//   @override
//   _CoinCollectAnimationState createState() => _CoinCollectAnimationState();
// }

// class _CoinCollectAnimationState extends State<CoinCollectAnimation>
//     with TickerProviderStateMixin {
//   final int coinCount = 8;
//   bool showCoins = false;

//   late List<AnimationController> bounceControllers;
//   late List<Animation<double>> bounceAnimations;

//   late List<AnimationController> moveControllers;
//   late List<Animation<Offset>> moveAnimations;

//   final GlobalKey containerKey = GlobalKey();

//   Offset containerBottomCenter = Offset.zero;

//   @override
//   void initState() {
//     super.initState();

//     bounceControllers = List.generate(
//       coinCount,
//       (_) => AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: 400),
//       ),
//     );

//     bounceAnimations = bounceControllers.map((controller) {
//       return Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(parent: controller, curve: Curves.elasticOut),
//       );
//     }).toList();

//     moveControllers = List.generate(
//       coinCount,
//       (_) => AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: 900),
//       ),
//     );

//     moveAnimations = moveControllers.map((controller) {
//       return Tween<Offset>(
//         begin: Offset.zero,
//         end: Offset(3.0, -3.5), // Move top-right
//       ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
//     }).toList();
//   }

//   void triggerAnimation() {
//     final RenderBox box = containerKey.currentContext!.findRenderObject() as RenderBox;
//     final containerPosition = box.localToGlobal(Offset.zero);
//     final size = box.size;

//     setState(() {
//       containerBottomCenter = Offset(
//         containerPosition.dx + size.width / 2 - 15, // center minus half coin
//         containerPosition.dy + size.height - 30,    // bottom minus coin height
//       );
//       showCoins = true;
//     });

//     for (int i = 0; i < coinCount; i++) {
//       Future.delayed(Duration(milliseconds: i * 80), () {
//         bounceControllers[i].forward();
//         Future.delayed(Duration(milliseconds: 500), () {
//           moveControllers[i].forward();
//         });
//       });
//     }
//   }

//   Widget buildCoin(int index) {
//     return AnimatedBuilder(
//       animation: moveControllers[index],
//       builder: (_, __) {
//         return Positioned(
//           left: containerBottomCenter.dx,
//           top: containerBottomCenter.dy,
//           child: Transform.translate(
//             offset: moveAnimations[index].value * 200,
//             child: ScaleTransition(
//               scale: bounceAnimations[index],
//               child: Image.asset('assets/images/coin.png', width: 30, height: 30),
//             ),
//           ),
//         );
//       },
//     );
//   }

// //     Widget buildCoin(int index) {
// //   double spread = (index - coinCount / 2) * 20; // spread - e.g., -60 to +60

// //   return AnimatedBuilder(
// //     animation: moveControllers[index],
// //     builder: (_, __) {
// //       return Positioned(
// //         left: containerBottomCenter.dx + spread,
// //         top: containerBottomCenter.dy,
// //         child: Transform.translate(
// //           offset: moveAnimations[index].value * 200,
// //           child: ScaleTransition(
// //             scale: bounceAnimations[index],
// //             child: Image.asset('assets/images/coin.png', width: 30, height: 30),
// //           ),
// //         ),
// //       );
// //     },
// //   );
// // }

//   @override
//   void dispose() {
//     for (var c in [...bounceControllers, ...moveControllers]) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
          
//           Center(
//             child: Container(
//               key: containerKey,
//               width: 150,
//               height: 150,
//               color: Colors.black54,
//               child: Center(
//                 child: ElevatedButton(
//                   onPressed: triggerAnimation,
//                   child: Text("Collect"),
//                 ),
//               ),
//             ),
//           ),

//           if (showCoins) ...List.generate(coinCount, buildCoin),
//         ],
//       ),
//     );
//   }
// }


class CoinSpawner extends StatefulWidget {
  @override
  _CoinSpawnerState createState() => _CoinSpawnerState();
}

class _CoinSpawnerState extends State<CoinSpawner> {
  final GlobalKey _containerKey = GlobalKey();
  final Random random = Random();
  List<Offset> coinPositions = [];

  void spawnCoins() {
    // Get the position and size of the container
    final RenderBox renderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    final containerPosition = renderBox.localToGlobal(Offset.zero);
    final containerSize = renderBox.size;

    final double baseX = containerPosition.dx + containerSize.width / 2;
    final double baseY = containerPosition.dy + containerSize.height;

    setState(() {
      // Generate 10 coins slightly spread below the container
      coinPositions = List.generate(10, (_) {
        double spread = random.nextDouble() * 100 - 50; // range: -50 to +50
        return Offset(baseX + spread, baseY + random.nextDouble() * 20);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              key: _containerKey,
              width: 150,
              height: 150,
              color: Colors.grey[300],
              child: Center(
                child: ElevatedButton(
                  onPressed: spawnCoins,
                  child: Text("Collect"),
                ),
              ),
            ),
          ),
          ...coinPositions.map((pos) {
            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: Image.asset(
                'assets/images/coin.png',
                width: 32,
                height: 32,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}