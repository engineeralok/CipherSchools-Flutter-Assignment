import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/prov/auth.dart';
import 'package:cipherschools_flutter_assignment/ui/home.dart';
import 'package:flutter/material.dart';

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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
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
