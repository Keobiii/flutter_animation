import 'package:flutter/material.dart';

class CoinBouncePage extends StatefulWidget {
  @override
  _CoinBouncePageState createState() => _CoinBouncePageState();
}

class _CoinBouncePageState extends State<CoinBouncePage>
    with TickerProviderStateMixin {
  final int coinCount = 8;

  late List<AnimationController> bounceControllers;
  late List<Animation<double>> bounceAnimations;

  late List<AnimationController> moveControllers;
  late List<Animation<Offset>> moveAnimations;

  bool coinsVisible = false;

  @override
  void initState() {
    super.initState();

    // Bounce animation setup
    bounceControllers = List.generate(
      coinCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600),
      ),
    );
    bounceAnimations = bounceControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Movement animation setup
    moveControllers = List.generate(
      coinCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800),
      ),
    );
    moveAnimations = moveControllers.map((controller) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(1.5, -3.0), // Moves to top-right
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    }).toList();
  }

  void showAndCollectCoins() {
    setState(() {
      coinsVisible = true;
    });

    for (int i = 0; i < coinCount; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        bounceControllers[i].forward();

        // Start move animation after bounce
        Future.delayed(Duration(milliseconds: 800), () {
          moveControllers[i].forward();
        });
      });
    }
  }

  @override
  void dispose() {
    for (var c in [...bounceControllers, ...moveControllers]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget buildCoin(int index) {
    return SlideTransition(
      position: moveAnimations[index],
      child: ScaleTransition(
        scale: bounceAnimations[index],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/coin.png', width: 40, height: 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Coin Collect Animation")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: showAndCollectCoins,
            child: Text("Show & Collect Coins"),
          ),
          SizedBox(height: 30),
          if (coinsVisible)
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: List.generate(
                  coinCount,
                  (index) => Positioned(
                    left: 30.0 * index,
                    bottom: 0,
                    child: buildCoin(index),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
