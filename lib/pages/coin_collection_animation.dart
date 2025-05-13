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

import 'dart:math';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';

// This class holds all animations and controllers for a single coin
class CoinAnimation {
  final Animation<Offset>
  positionAnimation; // controls movement from container to top
  final Animation<double> scaleAnimation; // controls spawn scale (grow effect)
  final AnimationController positionController; // controller for movement
  final AnimationController scaleController; // controller for scaling

  CoinAnimation({
    required this.positionAnimation,
    required this.scaleAnimation,
    required this.positionController,
    required this.scaleController,
  });
}

class CoinSpawner extends StatefulWidget {
  @override
  _CoinSpawnerState createState() => _CoinSpawnerState();
}

class _CoinSpawnerState extends State<CoinSpawner>
    with TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final Random random = Random();
  List<CoinAnimation> coinAnimations = [];

  final GlobalKey _coinTargetKey = GlobalKey();

  void spawnCoins() {
    final RenderBox targetBox =
        _coinTargetKey.currentContext!.findRenderObject() as RenderBox;
    final Offset targetPosition = targetBox.localToGlobal(Offset.zero);

    // Get the position and size of the container
    final RenderBox renderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;

    // this sets the container position to the top left of the container
    final containerPosition = renderBox.localToGlobal(Offset.zero);

    // this is used to get the size of the container (width/height)
    final containerSize = renderBox.size;

    // Move right half the width
    final double baseX = containerPosition.dx + containerSize.width / 2;
    // Move down the full height
    final double baseY = containerPosition.dy + containerSize.height;

    // dx is how far the box is from the left of the screen
    // dy is how far the box is from the top of the screen

    // dispose old controllers if any
    for (final coin in coinAnimations) {
      coin.positionController.dispose();
      coin.scaleController.dispose();
    }
    coinAnimations.clear();

    final screenSize = MediaQuery.of(context).size;

    setState(() {
      // Generate 10 coins slightly spread below the container
      for (int i = 0; i < 5; i++) {
        // generate random number from -50 to +50
        // double spread = random.nextDouble() * 100 - 50;
        double spread =
            (random.nextDouble() * 100 - 50) * 0.5; // Scaling down the spread

        // then randomly spawn coins based on the spread random numbers inside the container
        Offset start = Offset(baseX + spread, baseY + random.nextDouble() * 20);

        // animate to the top of the screen (top-right area)
        // Offset end = Offset(screenSize.width - 50.0, 40.0 + i * 2);
        Offset end = Offset(
          targetPosition.dx + targetBox.size.width / 2 - 16, // center the coin
          targetPosition.dy + targetBox.size.height / 2 - 16,
        );

        // controller for moving the coin to the top
        final positionController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 800 + random.nextInt(300)),
        );

        // animation that moves the coin from start to end
        final positionAnimation = Tween<Offset>(begin: start, end: end).animate(
          CurvedAnimation(parent: positionController, curve: Curves.easeInOut),
        );

        // controller for scaling the coin when it spawns
        final scaleController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 300), // quick grow animation
        );

        // animation that grows the coin from 0% to 100%
        final scaleAnimation = CurvedAnimation(
          parent: scaleController,
          curve: Curves.easeOutBack, // adds bounce effect
        );

        // play the scale animation immediately (spawn effect)
        scaleController.forward();

        // Add delay when going to the top right
        Future.delayed(Duration(seconds: 2), () {
          positionController.forward(); // start fly-up after delay
        });

        // Remove the coin when animation completes
        positionController.addStatusListener((status) {
          /*
            Types of Animation Listener
            AnimationStatus.forward → animation is running forward
            AnimationStatus.completed → animation has finished
            AnimationStatus.dismissed → animation is reset to start
            AnimationStatus.reverse → animation is running in reverse
          */
          if (status == AnimationStatus.completed) {
            setState(() {
              // check the index of each coin in the list
              // if they’re done animating then remove it
              // making them disappear
              coinAnimations.removeWhere(
                (coin) => coin.positionController == positionController,
              );
            });
            positionController.dispose();
            scaleController.dispose();
          }
        });

        // add the coin to the animation list
        coinAnimations.add(
          CoinAnimation(
            positionAnimation: positionAnimation,
            scaleAnimation: scaleAnimation,
            positionController: positionController,
            scaleController: scaleController,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    for (final coin in coinAnimations) {
      coin.positionController.dispose();
      coin.scaleController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Collect Coins'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              key: _coinTargetKey,
              child: Image.asset(
                'assets/images/coin.png',
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
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
          // Render each coin with scale and position animations
          ...coinAnimations.map((coin) {
            return AnimatedBuilder(
              animation: coin.positionAnimation,
              builder: (context, child) {
                return Positioned(
                  left: coin.positionAnimation.value.dx,
                  top: coin.positionAnimation.value.dy,
                  child: ScaleTransition(
                    scale: coin.scaleAnimation,
                    child: Image.asset(
                      'assets/images/coin.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
