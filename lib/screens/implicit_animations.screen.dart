import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _toggleVisibility() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _buildAnimatedAlign(_visible, size),
            // _buildAnimatedContainer(_visible, size),
            TweenAnimationBuilder(
              tween: ColorTween(
                begin: Colors.yellow,
                end: Colors.red,
              ),
              curve: Curves.bounceInOut,
              duration: const Duration(seconds: 5),
              builder: ((context, value, child) {
                return Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png",
                  color: value,
                  colorBlendMode: BlendMode.colorBurn,
                );
              }),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _toggleVisibility,
              child: const Text('Go!'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildAnimatedContainer(bool visible, Size size) {
  return AnimatedContainer(
    curve: Curves.elasticOut,
    duration: const Duration(seconds: 1),
    height: size.width * 0.8,
    width: size.width * 0.8,
    transform: Matrix4.rotationZ(visible ? 1 : 0),
    transformAlignment: Alignment.center,
    decoration: BoxDecoration(
      color: visible ? Colors.red : Colors.amber,
      borderRadius: BorderRadius.circular(visible ? 100 : 0),
    ),
  );
}

Widget _buildAnimatedAlign(bool visible, Size size) {
  return AnimatedAlign(
    duration: const Duration(milliseconds: 500),
    alignment: visible ? Alignment.topLeft : Alignment.topRight,
    child: AnimatedOpacity(
      opacity: visible ? 1.0 : 0.2,
      duration: const Duration(seconds: 2),
      child: Container(
        width: size.width * 0.8,
        height: size.width * 0.8,
        color: Colors.amber,
      ),
    ),
  );
}
