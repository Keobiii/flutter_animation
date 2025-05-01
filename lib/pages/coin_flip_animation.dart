import 'dart:math';

import 'package:flutter/material.dart';

class CoinFlipAnimation extends StatefulWidget {
  const CoinFlipAnimation({super.key});

  @override
  State<CoinFlipAnimation> createState() => _CoinFlipAnimationState();
}

class _CoinFlipAnimationState extends State<CoinFlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realistic Coin Flip')),
      body: Center(
        child: GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double angle = _animation.value * pi; // 0 to π (180°)
              bool isFrontVisible = angle <= pi / 2;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(angle),
                child: isFrontVisible
                    ? _buildCoinImage('assets/images/front.png')
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(1.0, -1.0),
                        child: _buildCoinImage('assets/images/pog1.png'),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCoinImage(String assetPath) {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
