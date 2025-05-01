import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation/pages/widget/coin_flip.dart';
import 'package:flutter_animation/pages/widget/custom_fab_menu.dart';
import 'package:flutter_animation/pages/widget/fab_menu.dart';

class CoinsFlip extends StatefulWidget {
  const CoinsFlip({super.key});

  @override
  State<CoinsFlip> createState() => _CoinsFlipState();
}

class _CoinsFlipState extends State<CoinsFlip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  Alignment position1 = Alignment.bottomCenter;
  Alignment position2 = Alignment.bottomCenter;
  Alignment position3 = Alignment.bottomCenter;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    position1 = Alignment.bottomCenter;
    position2 = Alignment.bottomCenter;
    position3 = Alignment.bottomCenter;
  }

  void _flipAllCoins() {
    if (_isFront) {
      _controller.forward();
    }
    print("Coin Faced Front: ${_isFront}");
    // setState(() {
    //   _isFront = !_isFront;
    // });
  }

  double spinTurns = 0;

  void _rotateCoins() {
    setState(() {
      spinTurns = 3;
    });
  }

  void _alignCoins() {
    setState(() {
      position1 = Alignment.topLeft;
      position2 = Alignment.topCenter;
      position3 = Alignment.topRight;
      _rotateCoins();
    });
  }

  void _alignCoinsThenReveal() async {
    _alignCoins();
    await Future.delayed(Duration(milliseconds: 2000));
    _flipAllCoins();
  }

  void _resetCoins() {
    setState(() {
      _controller.reverse();
      position1 = Alignment.bottomCenter;
      position2 = Alignment.bottomCenter;
      position3 = Alignment.bottomCenter;
      spinTurns = 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<String> chipImages = [
    'assets/images/chips/chip_5.png',
    'assets/images/chips/chip_10.png',
    'assets/images/chips/chip_25.png',
    'assets/images/chips/chip_50.png',
    'assets/images/chips/chip_100.png',
    'assets/images/chips/chip_500.png',
    'assets/images/chips/chip_1000.png',
    'assets/images/chips/chip_all_in.png',
  ];

  // Callback function when a chip is selected
  void onChipSelected(String chipValue) {
    print('Chip selected: $chipValue');
    // You can do additional logic here, like adding the chip to the betting amount
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double coinSize = screenWidth / 6;

    return Scaffold(
      appBar: AppBar(title: const Text('Flip All Coins')),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.red,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedAlign(
                    // for alignment
                    alignment: position1,
                    duration: Duration(milliseconds: 700),
                    child: AnimatedRotation(
                      // for rotation
                      duration: Duration(milliseconds: 900),
                      alignment: Alignment.center,
                      turns: spinTurns,
                      child: CoinFlip(
                        // for coin flip
                        animation: _animation,
                        coinSize: coinSize,
                      ),
                    ),
                  ),
                  AnimatedAlign(
                    alignment: position2,
                    duration: Duration(milliseconds: 800),
                    child: AnimatedRotation(
                      duration: Duration(milliseconds: 900),
                      alignment: Alignment.center,
                      turns: spinTurns,
                      child: CoinFlip(
                        animation: _animation,
                        coinSize: coinSize,
                      ),
                    ),
                  ),
                  AnimatedAlign(
                    alignment: position3,
                    duration: Duration(milliseconds: 900),
                    child: AnimatedRotation(
                      duration: Duration(milliseconds: 900),
                      alignment: Alignment.center,
                      turns: spinTurns,
                      child: CoinFlip(
                        animation: _animation,
                        coinSize: coinSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _flipAllCoins();
                  },
                  child: Text('Reveal'),
                ),

                // ElevatedButton(
                //   onPressed: () {
                //     _rotateCoins();
                //   },
                //   child: Text('Rotate'),
                // ),

                // ElevatedButton(
                //   onPressed: () {
                //     _alignCoins();
                //   },
                //   child: Text('Align'),
                // ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _resetCoins();
                  },
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _alignCoinsThenReveal();
                  },
                  child: Text('Game'),
                ),
              ],
            ),

            // Container(
            //   padding: EdgeInsets.all(16.0),
            //   height: 100, // Adjust the height for your chip container
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children:
            //           chipImages.map((imagePath) {
            //             return GestureDetector(
            //               onTap:
            //                   () => onChipSelected(
            //                     imagePath,
            //                   ), // Trigger callback on tap
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 8),
            //                 child: Container(
            //                   width: 60,
            //                   height: 60,
            //                   decoration: BoxDecoration(
            //                     shape: BoxShape.circle,
            //                     image: DecorationImage(
            //                       image: AssetImage(imagePath),
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             );
            //           }).toList(),
            //     ),
            //   ),
            // ),
            Container(
              height: 150,
              color: Colors.amberAccent,
              width: double.infinity,
              alignment: Alignment.center,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 12.0, 
                  childAspectRatio: 1.2
                ),
                itemCount: chipImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onChipSelected(chipImages[index]); 
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 6.0,
                            offset: Offset(4, 4)
                          )
                        ]
                      ),
                        child: ClipOval(
                            child: Image.asset(
                              chipImages[index],
                            ),
                          
                        ),
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: const FabMenu(),
    );
  }
}
