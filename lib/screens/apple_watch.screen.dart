import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    // lowerBound: 0.005,
    // upperBound: 2.0,
  )..forward();

  late final CurvedAnimation _curveAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  // late final Animation<double> _progress = Tween(
  //   begin: 0.005,
  //   end: 1.5,
  // ).animate(_curveAnimation);

  late List<Animation<double>> _progressList = [
    Tween(
      begin: 0.005,
      end: Random().nextDouble() * 2.0,
    ).animate(_curveAnimation),
    Tween(
      begin: 0.005,
      end: Random().nextDouble() * 2.0,
    ).animate(_curveAnimation),
    Tween(
      begin: 0.005,
      end: Random().nextDouble() * 2.0,
    ).animate(_curveAnimation),
  ];

  void _animateValues() {
    _progressList = _progressList
        .map((e) => Tween(
              begin: e.value,
              end: Random().nextDouble() * 2.0,
            ).animate(_curveAnimation))
        .toList();

    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Apple Watch'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                progressList: _progressList,
              ),
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

/*
_animateValues() 함수에서 _progressList를 업데이트하고, _animationController를 다시 시작합니다. 이로 인해 _animationController가 다시 시작되면서 _curveAnimation도 다시 시작됩니다. _curveAnimation은 _animationController의 상태에 따라서 자동으로 업데이트되는 CurvedAnimation 인스턴스입니다.
AnimatedBuilder 위젯은 _animationController가 변경될 때마다 자동으로 다시 빌드됩니다. 이로 인해 CustomPaint 위젯도 다시 빌드되고, AppleWatchPainter의 paint 메서드가 호출됩니다. paint 메서드에서는 _progressList의 값을 사용하여 UI를 그리기 때문에, _progressList가 변경되면 UI도 자동으로 업데이트됩니다.
따라서, _animateValues() 함수를 호출하면 _progressList가 업데이트되고, _animationController가 다시 시작되면서 _curveAnimation도 다시 시작됩니다. 이로 인해 CustomPaint 위젯이 다시 빌드되고, AppleWatchPainter의 paint 메서드가 호출되어 UI가 자동으로 업데이트됩니다. 따라서, setState를 호출하지 않아도 UI가 자동으로 업데이트되는 것입니다.
*/

class AppleWatchPainter extends CustomPainter {
  final List<Animation<double>> progressList;

  const AppleWatchPainter({
    required this.progressList,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final [redProgress, greenProgress, blueProgress] =
        progressList.map((e) => e.value).toList();

    // final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const startingAngle = -0.5 * pi;

    // final paint = Paint()..color = Colors.blue;

    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    // canvas.drawRect(rect, paint);
    final redCircleRadius = (size.width / 2) * 0.9;

    canvas.drawCircle(
      center,
      redCircleRadius,
      redCirclePaint,
    );

    final greenCirclePaint = Paint()
      ..color = Colors.green.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final greenCircleRadius = (size.width / 2) * 0.76;

    canvas.drawCircle(
      center,
      greenCircleRadius,
      greenCirclePaint,
    );

    final blueCirclePaint = Paint()
      ..color = Colors.cyan.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final blueCircleRadius = (size.width / 2) * 0.62;

    canvas.drawCircle(
      center,
      blueCircleRadius,
      blueCirclePaint,
    );

    final redArcRect = Rect.fromCircle(
      center: center,
      radius: redCircleRadius,
    );

    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      redProgress * pi,
      false,
      redArcPaint,
    );

    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: greenCircleRadius,
    );

    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      greenProgress * pi,
      false,
      greenArcPaint,
    );

    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: blueCircleRadius,
    );

    final blueArcPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      blueProgress * pi,
      false,
      blueArcPaint,
    );

    // final circlePaint = Paint()
    //   ..color = Colors.red
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 20;

    // canvas.drawCircle(
    //   Offset(size.width / 2, size.width / 2),
    //   size.width / 2,
    //   circlePaint,
    // );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progressList
        .every((element) => progressList.contains(element));
  }
}
