import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../prov/navigation.dart';
import '../ui/home.dart';
import '../ui/statistics.dart';
import '../ui/profile.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color:
                        provider.currentIndex == 0
                            ? Colors.purple
                            : Colors.grey,
                  ),
                  onPressed: () => provider.setCurrentIndex(0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.bar_chart,
                    color:
                        provider.currentIndex == 1
                            ? Colors.purple
                            : Colors.grey,
                  ),
                  onPressed: () => provider.setCurrentIndex(1),
                ),
                const SizedBox(width: 40), // Space for FAB
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color:
                        provider.currentIndex == 2
                            ? Colors.purple
                            : Colors.grey,
                  ),
                  onPressed: () => provider.setCurrentIndex(2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
