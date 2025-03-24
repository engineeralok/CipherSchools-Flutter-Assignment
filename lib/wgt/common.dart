import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/prov/auth.dart';
import 'package:cipherschools_flutter_assignment/prov/navigation.dart';
import 'package:cipherschools_flutter_assignment/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  final AuthProvider provider;
  const GoogleSignInButton({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      icon:
          provider.isGoogleSignInLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.purple,
                  strokeWidth: 2,
                ),
              )
              : Image.asset(Assets.googleIcon.path),
      label:
          provider.isGoogleSignInLoading
              ? const Text("Signing in...")
              : const Text("Sign Up with Google"),
      onPressed:
          provider.isGoogleSignInLoading
              ? null
              : () async {
                final success = await provider.signInWithGoogle();
                if (success && context.mounted) {
                  provider.nameController.clear();
                  provider.emailController.clear();
                  provider.passwordController.clear();
                  provider.isChecked = false;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signed in successfully!")),
                  );
                } else if (context.mounted && provider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.errorMessage ?? "Error!")),
                  );
                }
              },
    );
  }
}

class NavigationItem {
  final IconData icon;
  final int index;

  const NavigationItem({required this.icon, required this.index});
}

class NavigationBarItem extends StatelessWidget {
  final NavigationItem item;
  final int currentIndex;
  final Function(int) onTap;

  const NavigationBarItem({
    super.key,
    required this.item,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        item.icon,
        color: currentIndex == item.index ? Colors.purple : Colors.grey,
      ),
      onPressed: () => onTap(item.index),
    );
  }
}

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({super.key});

  static const _navigationItems = [
    NavigationItem(icon: Icons.home, index: 0),
    NavigationItem(icon: Icons.bar_chart, index: 1),
    NavigationItem(icon: Icons.person, index: 2),
  ];

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
                ..._navigationItems
                    .take(2)
                    .map(
                      (item) => NavigationBarItem(
                        item: item,
                        currentIndex: provider.currentIndex,
                        onTap: provider.setCurrentIndex,
                      ),
                    ),
                const SizedBox(width: 40), // Space for FAB
                NavigationBarItem(
                  item: _navigationItems.last,
                  currentIndex: provider.currentIndex,
                  onTap: provider.setCurrentIndex,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
