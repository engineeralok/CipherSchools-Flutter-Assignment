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
