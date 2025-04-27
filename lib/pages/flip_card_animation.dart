import 'package:flutter/material.dart';

class FlipCardAnimation extends StatefulWidget {
  const FlipCardAnimation({super.key});

  @override
  State<FlipCardAnimation> createState() => _FlipCardAnimationState();
}

class _FlipCardAnimationState extends State<FlipCardAnimation> with SingleTickerProviderStateMixin{
 // "SingleTickerProviderStateMixin" provides way to create single animation controller

  // declare controller and animation
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    // Initializing the animation controller
    _controller = AnimationController(
      // duration of card to flip
      duration: const Duration(seconds: 1),
      // synchronize the animation with flutter framework
      vsync: this,
    );

    // Initialize animation
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    // "begin: 0, end: 1" progress indicator for flip
    // 0 means card fully visible
    // 1 means represent the back card

    // second animation
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut
      )
    );
  }

  // function that responsible for handling flipping action
  // checking the state of the card and provide the animation
  void _toggleCard() {
    if (_isFront) {
      // transitioning the card from 0 - 1
      _controller.forward();
    } else {
      // transitioning the card from 1 - 0
      _controller.reverse();
    }

    // update the state to rebuild the widget and update UI accordingly
    setState(() {
      _isFront = !_isFront;
    });
  }

  // disposing the controller to avoid memory leaks when app is not using
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flip Card Animation')),
      body: Center(
        child: GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            // "AnimatedBuilder" allow to rebuild parts of UI based on the changes in animation
            animation: _animation,
            builder: (context, child) {
              return Transform(
                // "Transform" allows to apply transformation to its child based on provided matrix
                transform: Matrix4.identity()
                // 3D transformation, without this the transformation will look like 2D flat
                ..setEntry(3, 2, 0.001) // (setEntry(row, column, value) method allows you to manually tweak specific elements inside that 4x4 transformation matrix
                // Rotates widget around Y-axis (horizontal flip) 0 - front view 3.14159 back view
                ..rotateY(_animation.value * 3.14159),
                // rotate child along with Y-axis
                alignment: Alignment.center,
                // card display based the animation value
                child:
                    _animation.value < 0.5
                        ? _builFronCard()
                        : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0), // Transform.scale(x: -1.0) to avoid the back side would be flipped backward and the text would look mirrored.
                          child: _buildBackCard(), 
                        ),
                  // The flip animation goes from 0 to 1.
                  // When value < 0.5, card in the first half → show the front card.
                  // When value >= 0.5, card in the second half → show the back card.
                
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _builFronCard() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Front',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }


  Widget _buildBackCard() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Back',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}


// Using Pi value for rotation here why
// rotation angles in Flutter and most grahics porgramming are measure in radians not degree

// Degree to Radians
// 180° - π (3.14159...)
// 360° -	2π (6.28318...)
// 90° -	π/2 (≈1.5708)
// 45° -	π/4 (≈0.7854)

// Why Pi value is using, 
// because we want the card rotate its halfway around Y-axis to show the back and front vice verse
// Half circle is 180° and, 180° degrees = π radians

// so animation value will look like this
// _animation.value	 - Angle (Rotation)   -	Result
// 0.0	-            0° (0 radians)       -	Card facing front.
// 0.5	-            90° (π/2 radians)    -	Card sideways (edge view).
// 1.0  -	           180° (π radians)     - Card showing back side.