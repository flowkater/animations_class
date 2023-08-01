import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 1),
  )..addListener(() {
      _range.value = _animationController.value;
    });

  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceOut,
  );

  // late final Animation<Color?> _colorAnimation = ColorTween(
  //   begin: Colors.amber,
  //   end: Colors.red,
  // ).animate(_animationController);

  late final Animation<Decoration> _decorationAnimation = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_curvedAnimation);

  late final Animation<double> _rotationAnimation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_curvedAnimation);

  late final Animation<double> _scaleAnimation = Tween(
    begin: 0.6,
    end: 1.0,
  ).animate(_curvedAnimation);

  late final Animation<Offset> _offsetAnimation = Tween(
    begin: Offset.zero,
    end: const Offset(0, -0.2),
  ).animate(_curvedAnimation);

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();

    // Timer.periodic(
    //   const Duration(milliseconds: 500),
    //   (timer) {
    //     print(_animationController.value);
    //   },
    // );

    // Ticker(
    //   (elapsed) => print(elapsed),
    // ).start();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChanged(double value) {
    _range.value = 0;
    _animationController.value = value;
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat(reverse: true);
    }

    setState(() {
      _looping = !_looping;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offsetAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: RotationTransition(
                  turns: _rotationAnimation,
                  child: DecoratedBoxTransition(
                    decoration: _decorationAnimation,
                    child: const SizedBox(
                      height: 400,
                      width: 400,
                    ),
                  ),
                ),
              ),
            ),
            // Text(
            //   "${_animationController.value}",
            //   style: const TextStyle(fontSize: 58),
            // ),
            // AnimatedBuilder(
            //   animation: _colorAnimation,
            //   builder: (context, child) {
            //     return Container(
            //       color: _colorAnimation.value,
            //       width: 400,
            //       height: 400,
            //     );
            //     // return Opacity(
            //     //   opacity: _animationController.value,
            //     //   child:
            //     //       Container(color: Colors.amber, width: 400, height: 400),
            //     // );
            //   },
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text("Play"),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text("Pause"),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text("Rewind"),
                ),
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(
                    _looping ? "Stop Looping" : "Start Looping",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(
                  value: value,
                  onChanged: _onChanged,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
