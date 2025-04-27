import 'package:flutter/material.dart';
import 'package:flutter_animation/data/wheel_random_prize.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class WheelAnimation extends StatefulWidget {
  const WheelAnimation({super.key});

  @override
  State<WheelAnimation> createState() => _WheelAnimationState();
}

class _WheelAnimationState extends State<WheelAnimation> {
  final selected = BehaviorSubject<int>();

  List<int> prizes = PrizeManager.prizes;
  int rewards = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fortune Wheel')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                items: [
                  for (int i = 0; i < prizes.length; i++) ...<FortuneItem>{
                    FortuneItem(
                      child: Text(
                        prizes[i].toString(),
                        // style: TextStyle(
                        //   fontSize: 24,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.white,
                        // ),
                      ),
                      // FortuneItemStyle
                      style: FortuneItemStyle(
                        color: i % 2 == 0 ? Colors.blue : Colors.redAccent,
                        borderColor: Colors.white,
                        borderWidth: 2,
                      ),
                    ),
                  },
                ],

                // Customize spin physics
                // physics: CircularPanPhysics(
                //   duration: Duration(seconds: 8),
                //   curve: Curves.decelerate,
                // ),
                // Customize indicator
                // indicators: <FortuneIndicator>[
                //   FortuneIndicator(
                //     alignment: Alignment.topCenter,
                //     child: Icon(
                //       Icons.arrow_drop_down,
                //       size: 40,
                //       color: Colors.red,
                //     ),
                //   ),
                // ],
                onAnimationEnd: () {
                  setState(() {
                    rewards = prizes[selected.value];
                  });

                  print('You won ${rewards}!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You just won ${rewards}')),
                  );
                },
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  int prize = PrizeManager.getRandomPrize();
                  int index = prizes.indexOf(prize);

                  selected.add(index);
                });
              },
              child: Container(
                height: 40,
                width: 120,
                color: Colors.redAccent,
                child: Center(child: Text('Spin')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
