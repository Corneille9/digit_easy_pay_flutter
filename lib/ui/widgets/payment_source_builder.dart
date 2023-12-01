import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:flutter/material.dart';

class PaymentSourceBuilder extends StatelessWidget {
   const PaymentSourceBuilder({Key? key, required this.imagePath, required this.padding, required this.onTap, required this.theme}) : super(key: key);
  final String imagePath;
  final EdgeInsets padding;
  final PaymentTheme theme;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                spreadRadius: 5,
                color: theme.paymentSourceShadowColor,
              )
            ],
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: padding,
            child: Image.asset(imagePath, fit: BoxFit.cover, package: "digit_easy_pay_flutter"),
          )
      ),
    );
  }
}