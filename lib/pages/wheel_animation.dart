import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class WheelAnimation extends StatefulWidget {
  const WheelAnimation({super.key});

  @override
  State<WheelAnimation> createState() => _WheelAnimationState();
}

class _WheelAnimationState extends State<WheelAnimation> {
  final selected = BehaviorSubject<int>();

  List<int> prizes = [100, 200, 300, 500, 1000, 2000, 5000];
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
                    FortuneItem(child: Text(prizes[i].toString())),
                  },
                ],
                onAnimationEnd: () {
                  setState(() {
                    rewards = prizes[selected.value];
                  });

                  print('You won ${rewards}!');
                },
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  selected.add(Fortune.randomInt(0, prizes.length));
                });
              },
              child: Container(
                height: 40,
                width: 120,
                color: Colors.redAccent,
                child: Center(
                  child: Text('Spin'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
