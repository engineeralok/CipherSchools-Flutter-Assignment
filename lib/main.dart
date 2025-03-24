import 'package:cipherschools_flutter_assignment/core/assets.dart';
import 'package:cipherschools_flutter_assignment/prov/auth.dart';
import 'package:cipherschools_flutter_assignment/prov/onboarding.dart';
import 'package:cipherschools_flutter_assignment/prov/transaction.dart';
import 'package:cipherschools_flutter_assignment/ui/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appTheme = ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: const Color(0xFF212224),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder:
            (context) =>
                Image.asset(Assets.backIcon.path, height: 32, width: 32),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 17),
          fixedSize: Size.copy(const Size(double.maxFinite, 56)),
          surfaceTintColor: Colors.deepPurpleAccent.shade700,
          disabledBackgroundColor: Colors.deepPurple.shade200,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.purple.withAlpha(60), width: 1),
          ),
          shadowColor: Colors.deepPurpleAccent,
          elevation: 0,
          textStyle: TextStyle(
            color: const Color(0xFF212224),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(
          color: Colors.purple,
          width: 2,
          style: BorderStyle.solid,
        ),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(12.0),
        labelStyle: TextStyle(
          color: const Color(0xFF90909F),
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.purple,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.purple,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.purple.withAlpha(60),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashScreenProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MaterialApp(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        title: 'CipherX',
        home: SplashScreen(),
      ),
    );
  }
}
