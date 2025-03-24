import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/prov/auth.dart';
import 'package:cipherschools_flutter_assignment/prov/navigation.dart';
import 'package:cipherschools_flutter_assignment/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon_widget/svg_icon_widget.dart';

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

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({super.key});

  static final _navigationItems = [
    NavigationItem(image: Assets.homeIcon.path, index: 0, label: "Home"),
    NavigationItem(
      image: Assets.transactionIcon.path,
      index: 1,
      label: "Transactions",
    ),
    NavigationItem(image: Assets.pieChartIcon.path, index: 2, label: "Budget"),
    NavigationItem(image: Assets.userIcon.path, index: 3, label: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Container(
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ..._navigationItems.map(
                  (item) => NavigationBarItem(
                    item: item,
                    currentIndex: provider.currentIndex,
                    onTap: provider.setCurrentIndex,
                    label: item.label,
                  ),
                ),
                // ..._navigationItems
                //     .take(2)
                //     .map(
                //       (item) => NavigationBarItem(
                //         item: item,
                //         currentIndex: provider.currentIndex,
                //         onTap: provider.setCurrentIndex,
                //         label: item.label,
                //       ),
                //     ),
                // SizedBox(width: 50),
                // ..._navigationItems
                //     .skip(2)
                //     .map(
                //       (item) => NavigationBarItem(
                //         item: item,
                //         currentIndex: provider.currentIndex,
                //         onTap: provider.setCurrentIndex,
                //         label: item.label,
                //       ),
                //     ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NavigationItem {
  final String image;
  final int index;
  final String label;

  const NavigationItem({
    required this.image,
    required this.index,
    required this.label,
  });
}

class NavigationBarItem extends StatelessWidget {
  final NavigationItem item;
  final int currentIndex;
  final Function(int) onTap;
  final String label;

  const NavigationBarItem({
    super.key,
    required this.item,
    required this.currentIndex,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: SvgIcon(
            SvgIconData(item.image),
            color:
                currentIndex == item.index
                    ? const Color(0xFF7E3DFF)
                    : const Color(0xFFC5C5C5),
          ),
          onPressed: () => onTap(item.index),
        ),
        Text(
          label,
          style: TextStyle(
            color:
                currentIndex == item.index
                    ? const Color(0xFF7E3DFF)
                    : const Color(0xFFC5C5C5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
