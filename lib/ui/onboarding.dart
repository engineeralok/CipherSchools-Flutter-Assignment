import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/prov/navigation.dart';
import 'package:cipherschools_flutter_assignment/ui/auth.dart';
import 'package:cipherschools_flutter_assignment/ui/home.dart';
import 'package:cipherschools_flutter_assignment/ui/home_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final navigationProvider = Provider.of<NavigationProvider>(
          context,
          listen: false,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) =>
                    navigationProvider.isUserLoggedIn
                        ? const HomeScreenWrapper()
                        : const WalkthroughScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(Assets.bg.path, fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 34.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Image.asset(Assets.logo.path, height: 100, width: 100),
                  const SizedBox(height: 10),
                  const Text(
                    'CipherX',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: mainFont,
                    ),
                  ),
                  const Spacer(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'By\n ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: thirdFont,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: 'Open Source ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: thirdFont,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: 'Community',
                          style: TextStyle(
                            color: const Color(0xFFF7A301),
                            fontFamily: thirdFont,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalkthroughScreen extends StatelessWidget {
  const WalkthroughScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(Assets.bg.path, fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(Assets.logo.path, height: 58, width: 58),
                  const SizedBox(height: 10),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Welcome to',
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: secondryFont,
                                  ),
                                ),
                                Text(
                                  'CipherX.',
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: mainFont,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xBFECE1E1),
                                  shape: BoxShape.circle,
                                ),

                                child: Image.asset(
                                  Assets.next.path,
                                  height: 58,
                                  width: 58,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'The best way to track your expenses.',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: secondryFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
