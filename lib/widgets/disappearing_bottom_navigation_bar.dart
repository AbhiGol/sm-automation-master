import 'package:flutter/material.dart';

import '../animations.dart';
import '../transitions/bottom_bar_transition.dart';

class DisappearingBottomNavigationBar extends StatelessWidget {
  const DisappearingBottomNavigationBar({
    super.key,
    required this.barAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final BarAnimation barAnimation;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BottomBarTransition(
      animation: barAnimation,
      backgroundColor: Colors.white,
      child: NavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.auto_graph), label: 'Output'),
          NavigationDestination(
              icon: Icon(Icons.app_registration), label: 'Job Data'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Recipe'),
          NavigationDestination(icon: Icon(Icons.code), label: 'G Code'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
