import 'dart:math';
import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final bound = size.width - 200;
  late final dropZone = size.width + 100;
  int _index = 1;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  late final Tween<double> _buttonScale = Tween(
    begin: 1.0,
    end: 1.2,
  );

  late final ColorTween _overlayRedColor = ColorTween(
    begin: Colors.white,
    end: Colors.red.withOpacity(1.0),
  );

  late final ColorTween _overlayGreenColor = ColorTween(
    begin: Colors.white,
    end: Colors.green.withOpacity(1.0),
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  void _animateCard() {
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(dropZone * factor, curve: Curves.easeOut)
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  void _onPressedPositive() {
    _position.animateTo(size.width + 100).whenComplete(_animateCard);
  }

  void _onPressedNegative() {
    _position.animateTo((size.width + 100) * -1).whenComplete(_animateCard);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _animateCard();
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform(
                (_position.value + size.width / 2) / size.width,
              ) *
              pi /
              180;

          final convertedValue = min(_position.value.abs() / size.width, 1.0);
          final scale = _scale.transform(convertedValue);

          final greenButtonScale = _position.value.isNegative
              ? 1.0
              : _buttonScale.transform(convertedValue);
          final redButtonScale = _position.value.isNegative
              ? _buttonScale.transform(convertedValue)
              : 1.0;

          final redOverlayColor = _position.value.isNegative
              ? _overlayRedColor.transform(convertedValue)
              : Colors.white;
          final greenOverlayColor = _position.value.isNegative
              ? Colors.white
              : _overlayGreenColor.transform(convertedValue);

          final greenIconColor =
              convertedValue > 0.65 && !_position.value.isNegative
                  ? Colors.white
                  : Colors.green;

          final redIconColor =
              convertedValue > 0.65 && _position.value.isNegative
                  ? Colors.white
                  : Colors.red;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 344,
                  height: 670,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 50,
                        child: Transform.scale(
                          scale: min(scale, 1.0),
                          child: Card(index: _index == 5 ? 1 : _index + 1),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        child: GestureDetector(
                          onHorizontalDragUpdate: _onHorizontalDragUpdate,
                          onHorizontalDragEnd: _onHorizontalDragEnd,
                          child: Transform.translate(
                            offset: Offset(_position.value, 0),
                            child: Transform.rotate(
                              angle: angle,
                              child: Card(index: _index),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      buttonScale: redButtonScale,
                      onTap: _onPressedNegative,
                      iconColor: redIconColor,
                      overlayColor: redOverlayColor!,
                      icon: Icons.close,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Button(
                      buttonScale: greenButtonScale,
                      onTap: _onPressedPositive,
                      iconColor: greenIconColor,
                      overlayColor: greenOverlayColor!,
                      icon: Icons.check,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class Button extends StatelessWidget {
  final double buttonScale;
  final VoidCallback onTap;
  final Color iconColor;
  final Color overlayColor;
  final IconData icon;

  const Button({
    super.key,
    required this.buttonScale,
    required this.onTap,
    required this.iconColor,
    required this.overlayColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: buttonScale,
        child: Material(
          elevation: 10.0,
          shape: const CircleBorder(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.white),
                  shape: BoxShape.circle,
                  color: overlayColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Icon(
                icon,
                color: iconColor,
                size: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.65,
        child: Image.asset(
          'assets/covers/$index.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
