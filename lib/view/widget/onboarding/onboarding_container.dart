import 'package:flutter/material.dart';

class OnboardingContainer extends StatelessWidget {
  const OnboardingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha((0.3 * 255).toInt()),
                      Colors.black.withAlpha((0.9 * 255).toInt()),
                    ],
                  ),
                ),
              );
  }
}