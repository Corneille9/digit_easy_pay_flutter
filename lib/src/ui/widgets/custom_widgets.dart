import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed, this.icon = Icons.close});

  final IconData icon;

  final VoidCallback? onPressed;

  PaymentConfig get config => DigitEasyPayFlutter.config;

  PaymentTheme get theme => config.theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed:
            onPressed ??
            () {
              Navigator.of(context).pop();
            },
        style: IconButton.styleFrom(
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.all(5),
          minimumSize: Size.zero,
        ),
        icon: Icon(icon, color: theme.backgroundColor),
      ),
    );
  }
}
