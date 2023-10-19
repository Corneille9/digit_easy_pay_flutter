import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DigitEasyPayPaymentMethodBuilder extends StatelessWidget {
  DigitEasyPayPaymentMethodBuilder({Key? key, this.onSelect, required this.selectedMethod, required this.theme}) : super(key: key);
  ValueNotifier<DigitEasyPayPaymentMethod> selectedMethod;
  final Function(DigitEasyPayPaymentMethod method)? onSelect;
  final PaymentTheme theme;

  Widget _methodBuilder({required DigitEasyPayPaymentMethod method}) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(5),
          // splashColor: Colors.white,
          onTap: () {
            if(selectedMethod.value == method) return;
            selectedMethod.value = method;
            onSelect?.call(method);
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            width: 63,
            height: 39,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: method==selectedMethod.value?theme.primaryColor.withOpacity(0.5):theme.unSelectedMethodColor),
              color: theme.backgroundColor,
              boxShadow: method==selectedMethod.value?[
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 1
                )
              ]:null
            ),
            child: Image.asset(method.icon, package: "digit_easy_pay_flutter"),
          ),
        ),
        const SizedBox(height: 5,),
        Text(method.toIntl(), style: TextStyle(fontSize: 10, color: method==selectedMethod.value?theme.primaryColor:theme.unSelectedMethodTextColor),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedMethod,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            ...DigitEasyPayPaymentMethod.values.map((e) => _methodBuilder(method: e)).toList(),
            const SizedBox(),
          ],
        );
      },
    );
  }
}
