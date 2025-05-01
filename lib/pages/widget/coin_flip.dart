import 'dart:math';

import 'package:flutter/material.dart';

class CoinFlip extends StatelessWidget {
  final Animation<double> animation;
  final double coinSize;

  const CoinFlip({
    super.key,
    required this.animation,
    required this.coinSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double angle = animation.value * pi;
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
    );
  }

  Widget _buildCoinImage(String assetPath) {
    return Container(
      width: coinSize,
      height: coinSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
      ),
      child: ClipOval(
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
  }
}
