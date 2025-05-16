import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeWidget extends StatelessWidget {
  const ThemeWidget({super.key, required this.child, required this.theme});

  final Widget child;

  final PaymentTheme theme;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: theme.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: theme.primaryColor),
        scaffoldBackgroundColor: theme.backgroundColor,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: theme.isLight ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: theme.backgroundColor,
          ),
          backgroundColor: theme.backgroundColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.backgroundColor,
            elevation: 0,
          ),
        ),
      ),
      child: child,
    );
  }
}
