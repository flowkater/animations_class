import 'package:animations_class/screens/implicit_animations.screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Animations'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _goToPage(
                    context,
                    const ImplicitAnimationsScreen(),
                  );
                },
                child: const Text('Implicit Animations'),
              ),
            ],
          ),
        ));
  }
}
