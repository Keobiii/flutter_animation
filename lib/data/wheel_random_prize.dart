import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class PrizeManager {
  static List<int> prizes = [0, 100, 200, 300, 500, 1000];

  static int getRandomPrize() {
    final random = Fortune.randomInt(0, 1000);
    
    if (random < 900) {
      return prizes[0]; // 0
    } else if (random < 940) {
      return prizes[1]; // 100
    } else if (random < 960) {
      return prizes[2]; // 200
    } else if (random < 980) {
      return prizes[3]; // 300
    } else if (random < 995) {
      return prizes[4]; // 500
    } else {
      return prizes[5]; // 1000
    }
  }
}
