import 'dart:math';
import 'package:flutter/material.dart';

class CoinCollectAnimation extends StatefulWidget {
  @override
  _CoinCollectAnimationState createState() => _CoinCollectAnimationState();
}

class _CoinCollectAnimationState extends State<CoinCollectAnimation>
    with TickerProviderStateMixin {
  final int coinCount = 8;
  bool showCoins = false;

  late List<AnimationController> bounceControllers;
  late List<Animation<double>> bounceAnimations;

  late List<AnimationController> moveControllers;
  late List<Animation<Offset>> moveAnimations;

  final GlobalKey containerKey = GlobalKey();

  Offset containerBottomCenter = Offset.zero;

  @override
  void initState() {
    super.initState();

    bounceControllers = List.generate(
      coinCount,
      (_) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );

    bounceAnimations = bounceControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    moveControllers = List.generate(
      coinCount,
      (_) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 900),
      ),
    );

    moveAnimations = moveControllers.map((controller) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(3.0, -5.0), // Move top-right
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();
  }

  void triggerAnimation() {
    final RenderBox box = containerKey.currentContext!.findRenderObject() as RenderBox;
    final containerPosition = box.localToGlobal(Offset.zero);
    final size = box.size;

    setState(() {
      containerBottomCenter = Offset(
        containerPosition.dx + size.width / 2 - 15, // center minus half coin
        containerPosition.dy + size.height - 30,    // bottom minus coin height
      );
      showCoins = true;
    });

    for (int i = 0; i < coinCount; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        bounceControllers[i].forward();
        Future.delayed(Duration(milliseconds: 500), () {
          moveControllers[i].forward();
        });
      });
    }
  }

  Widget buildCoin(int index) {
    return AnimatedBuilder(
      animation: moveControllers[index],
      builder: (_, __) {
        return Positioned(
          left: containerBottomCenter.dx,
          top: containerBottomCenter.dy,
          child: Transform.translate(
            offset: moveAnimations[index].value * 200,
            child: ScaleTransition(
              scale: bounceAnimations[index],
              child: Image.asset('assets/images/coin.png', width: 30, height: 30),
            ),
          ),
        );
      },
    );
  }

//     Widget buildCoin(int index) {
//   double spread = (index - coinCount / 2) * 20; // spread - e.g., -60 to +60

//   return AnimatedBuilder(
//     animation: moveControllers[index],
//     builder: (_, __) {
//       return Positioned(
//         left: containerBottomCenter.dx + spread,
//         top: containerBottomCenter.dy,
//         child: Transform.translate(
//           offset: moveAnimations[index].value * 200,
//           child: ScaleTransition(
//             scale: bounceAnimations[index],
//             child: Image.asset('assets/images/coin.png', width: 30, height: 30),
//           ),
//         ),
//       );
//     },
//   );
// }

  @override
  void dispose() {
    for (var c in [...bounceControllers, ...moveControllers]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (showCoins) ...List.generate(coinCount, buildCoin),
          Center(
            child: Container(
              key: containerKey,
              width: 150,
              height: 150,
              color: Colors.black54,
              child: Center(
                child: ElevatedButton(
                  onPressed: triggerAnimation,
                  child: Text("Collect"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
