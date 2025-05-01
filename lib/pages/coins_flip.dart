import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation/pages/widget/coin_flip.dart';
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
                  AnimatedAlign( // for alignment
                    alignment: position1,
                    duration: Duration(milliseconds: 700),
                    child: AnimatedRotation( // for rotation
                      duration: Duration(milliseconds: 900),
                      alignment: Alignment.center,
                      turns: spinTurns,
                      child: CoinFlip( // for coin flip
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
                ElevatedButton(onPressed: (){
                  _alignCoinsThenReveal();
                }, child: Text('Game'))
              ],
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const FabMenu(),
    );
  }
}
