import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A2511),
            Color(0xFF8B4513),
            Color(0xFFDAA520),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 24,
            bottom: 24,
            child: Icon(
              Icons.landscape,
              size: 112,
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          const Positioned(
            left: 16,
            right: 16,
            bottom: 64,
            child: Text(
              'Discover, Connect, Grow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
