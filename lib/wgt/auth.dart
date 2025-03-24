import 'package:cipherschools_flutter_assignment/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cipherschools_flutter_assignment/prov/auth.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: provider.nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: provider.emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: provider.passwordController,
              obscureText: !provider.isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    provider.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: provider.togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 17),

            Row(
              children: [
                Checkbox(
                  value: provider.isChecked,
                  onChanged: provider.toggleCheckbox,
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      const Text(
                        "By signing up, you agree to the ",
                        style: TextStyle(fontFamily: "Inter"),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Terms of Service",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Text(
                        " and ",
                        style: TextStyle(fontFamily: "Inter"),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed:
                  provider.isButtonEnabled && !provider.isSignUpLoading
                      ? () async {
                        final success =
                            await provider.signUpWithEmailAndPassword();
                        if (success && context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        } else if (context.mounted &&
                            provider.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(provider.errorMessage!)),
                          );
                        }
                      }
                      : null,
              child:
                  provider.isSignUpLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
            ),

            const SizedBox(height: 17),
          ],
        );
      },
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: provider.emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: provider.passwordController,
              obscureText: !provider.isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    provider.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: provider.togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed:
                  provider.emailController.text.trim().isNotEmpty &&
                          provider.passwordController.text.trim().isNotEmpty &&
                          !provider.isLoginLoading
                      ? () async {
                        final success =
                            await provider.signInWithEmailAndPassword();
                        if (success && context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        } else if (context.mounted &&
                            provider.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(provider.errorMessage!)),
                          );
                        }
                      }
                      : null,
              child:
                  provider.isLoginLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        "Login",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
            ),
            const SizedBox(height: 17),
          ],
        );
      },
    );
  }
}
