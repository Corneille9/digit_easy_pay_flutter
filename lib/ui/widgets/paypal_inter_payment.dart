import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/src/providers/paypal_payment_provider.dart';
import 'package:flutter/material.dart';

class PaypalInternational extends StatefulWidget {
  const PaypalInternational({super.key, required this.provider, required this.theme});
  final PaypalPaymentProvider provider;
  final PaymentTheme theme;

  @override
  State<PaypalInternational> createState() => _PaypalInternationalState();
}

class _PaypalInternationalState extends State<PaypalInternational> {
  final ValueNotifier<int> _notifier = ValueNotifier<int>(0);
  bool isLoading = true;
  bool hasError = false;

  PaypalPaymentProvider get provider => widget.provider;
  PaymentTheme get theme => widget.theme;

  void notify() {
    _notifier.value++;
  }

  void onError() {
    hasError = true;
    isLoading = false;
    notify();
  }

  void processPayment(){
    isLoading = true;
    hasError = false;
    notify();

    provider.makePayment();
  }

  @override
  void initState() {
    processPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(PaymentImages.paypalButtonIcon, package: "digit_easy_pay_flutter", height: 15),
                  // Text(
                  //   'PayPal (${widget.amount} ${Currency.XOF.name})',
                  //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  //       fontWeight: FontWeight.w600, fontSize: 15),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.textColor.withOpacity(0.1)
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: theme.textColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if(isLoading)
                SizedBox(
                  height: size.height * 0.3,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              if(hasError)
                SizedBox(
                  height: size.height * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                      ),
                      const Text('Payment failed', style: TextStyle(), textAlign: TextAlign.center,),
                      const SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: () {
                          processPayment();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFffc439),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Pay ${provider.amount} XOF with", style: const TextStyle(color: Colors.black, fontSize: 12),),
                            const SizedBox(width: 5,),
                            Image.asset(PaymentImages.paypalButtonIcon, height: 15, package: "digit_easy_pay_flutter",),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
