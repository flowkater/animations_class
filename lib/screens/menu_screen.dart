import 'package:animations_class/screens/apple_watch.screen.dart';
import 'package:animations_class/screens/explicit_animations.screen.dart';
import 'package:animations_class/screens/implicit_animations.screen.dart';
import 'package:animations_class/screens/swiping_cards.screen.dart';
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
              ElevatedButton(
                onPressed: () {
                  _goToPage(
                    context,
                    const ExplicitAnimationsScreen(),
                  );
                },
                child: const Text('Explicit Animations'),
              ),
              ElevatedButton(
                onPressed: () {
                  _goToPage(
                    context,
                    const AppleWatchScreen(),
                  );
                },
                child: const Text('AppleWatch'),
              ),
              ElevatedButton(
                onPressed: () {
                  _goToPage(
                    context,
                    const SwipingCardsScreen(),
                  );
                },
                child: const Text('Swiping Cards'),
              ),
            ],
          ),
        ));
  }
}
