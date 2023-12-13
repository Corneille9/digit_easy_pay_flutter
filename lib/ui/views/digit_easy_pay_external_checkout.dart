import 'package:digit_easy_pay_flutter/src/common/digit_easy_pay_config.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/src/providers/digit_easy_pay_payment_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/fedapay_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/paypal_payment_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/stripe_payment_provider.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/flexible_bottom_sheet_route.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/payment_source_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DigitEasyPayExternalCheckout{
  final BuildContext context;
  final List<DigitEasyPayPaymentSource> paymentSources;
  final PaymentConfig config;
  final num amount;
  final DigitEasyPayCurrency currency;
  final PaymentTheme theme;
  final L10n l10n;
  final VoidCallback? onCancel;
  final DigitEasyPayCallback? onSuccess;
  final ValueNotifier<DigitEasyPayPaymentMethod> selectedMethod = ValueNotifier(DigitEasyPayPaymentMethod.momo);
  ValueNotifier<bool> isInitializing = ValueNotifier(false);
  bool canPop = true;
  BuildContext? _context;

  DigitEasyPayExternalCheckout({required this.context,required this.paymentSources, required this.config,required this.amount, required this.currency,required this.l10n, this.onCancel, this.onSuccess, PaymentTheme? theme}):theme = theme??DefaultPaymentTheme();

  bool _hasSource(DigitEasyPayPaymentSource source){
    return paymentSources.contains(source);
  }
  
  void init(){
    showFlexibleBottomSheet(
      // maxHeaderHeight: 180,
      // minHeaderHeight: 180,
      minHeight: 0.8,
      initHeight: 0.9,
      maxHeight: 1,
      isDismissible: false,
      isCollapsible: false,
      // l10n: l10n,
      isSafeArea: true,
      bottomSheetBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),
      context: context,
      bottomSheetColor: theme.backgroundColor,
      onWillPop: () async{
        return canPop;
      },
      providers: [
        if(_hasSource(DigitEasyPayPaymentSource.QOSIC))ChangeNotifierProvider(create: (context) => DigitEasyPayPaymentProvider(
          amount: amount,
          currency: currency,
          config: config.digitEasyPayConfig!,
          theme: theme,
          l10n: l10n,
          onError: onPayError,
            onSuccess: onPaySuccess,
            onCancel: onPayCancel
        )),

        if(_hasSource(DigitEasyPayPaymentSource.STRIPE))ChangeNotifierProvider(create: (context) => StripePaymentProvider(
            amount: amount,
            currency: currency,
            config: config.stripeConfig!,
            theme: theme,
          onError: onPayError,
            onSuccess: onPaySuccess,
            onCancel: onPayCancel
        )),

        if(_hasSource(DigitEasyPayPaymentSource.PAYPAL))ChangeNotifierProvider(create: (context) => PaypalPaymentProvider(
            amount: amount,
            currency: currency,
            config: config.payPalConfig!,
          onError: onPayError,
            onSuccess: onPaySuccess,
            onCancel: onPayCancel
        )),

        if(_hasSource(DigitEasyPayPaymentSource.FEDAPAY))ChangeNotifierProvider(create: (context) => FedapayPaymentProvider(
            amount: amount,
            currency: currency,
            config: config.fedapayConfig!,
            theme: theme,
            l10n: l10n,
            onError: onPayError,
          onSuccess: onPaySuccess,
          onCancel: onPayCancel
        )),
      ],
      anchors: [.8, 1],
      builder: (context, scrollController, bottomSheetOffset) {
        _context = context;
        return Container(
          height: double.infinity,
          width: double.infinity,
          color: theme.backgroundSubtleColor,
          child: SingleChildScrollView(
            controller: scrollController,
            child: _PaymentsBuilder(checkout: this),
          ),
        );
      },
    );
  }

  void onPaySuccess(String reference, DigitEasyPayPaymentSource source, String paymentMethod){
    debugPrint("DigitEasyPayExternalCheckout payment successfully");
    canPop = true;
    Fluttertoast.showToast(msg: l10n.paymentSuccessfully);
    Future(() => Navigator.pop(_context??context),);
    onSuccess?.call(reference, source, paymentMethod);
  }

  void onPayError(){
    debugPrint("DigitEasyPayExternalCheckout payment failed");
    canPop = true;
    Fluttertoast.showToast(msg: l10n.paymentFailed);
  }

  void onPayCancel(){
    debugPrint("DigitEasyPayExternalCheckout payment canceled");
    canPop = true;
    Fluttertoast.showToast(msg: l10n.paymentFailed);
    onCancel?.call();
  }
}

class _PaymentsBuilder extends StatelessWidget {
  _PaymentsBuilder({Key? key, required this.checkout}) : super(key: key);
  final DigitEasyPayExternalCheckout checkout;

  bool hasSource(DigitEasyPayPaymentSource source){
    return checkout.paymentSources.contains(source);
  }

  void onInitialized(){
    checkout.isInitializing.value = false;
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      checkout.onCancel?.call();
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: checkout.theme.textColor.withOpacity(0.1)
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: checkout.theme.textColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50,),
            Text(
              "Methodes de paiements",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: checkout.theme.textColor
              ),
            ),
            const SizedBox(height: 100,),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceAround,
              spacing: 30,
              runSpacing: 30,
              children: [
                if(hasSource(DigitEasyPayPaymentSource.QOSIC))
                PaymentSourceBuilder(
                  theme: checkout.theme,
                  padding: const EdgeInsets.all(0),
                  imagePath: PaymentImages.digitEasyPay,
                  onTap: () {
                    Provider.of<DigitEasyPayPaymentProvider>(context, listen: false).makePayment(context: context);
                  },
                ),
                if(hasSource(DigitEasyPayPaymentSource.PAYPAL))
                  PaymentSourceBuilder(
                    theme: checkout.theme,
                  padding: const EdgeInsets.all(25),
                  imagePath: PaymentImages.paypal,
                  onTap: () {
                    if(checkout.isInitializing.value)return;
                    checkout.isInitializing.value = true;
                    Provider.of<PaypalPaymentProvider>(context, listen: false).makePayment(onInitialized: onInitialized);
                  },),
                if(hasSource(DigitEasyPayPaymentSource.STRIPE))
                  PaymentSourceBuilder(
                    theme: checkout.theme,
                    padding: const EdgeInsets.all(25),
                    imagePath: PaymentImages.stripe,
                    onTap: () {
                      if(checkout.isInitializing.value)return;
                      checkout.isInitializing.value = true;
                      Provider.of<StripePaymentProvider>(context, listen: false).makePayment(onInitialized: onInitialized);
                    }
                ),
                if(hasSource(DigitEasyPayPaymentSource.FEDAPAY) && checkout.currency==DigitEasyPayCurrency.XOF)
                  PaymentSourceBuilder(
                    theme: checkout.theme,
                  padding: const EdgeInsets.all(25),
                  imagePath: PaymentImages.fedapay,
                  onTap: () {
                    if(checkout.isInitializing.value)return;
                    checkout.isInitializing.value = true;
                    Provider.of<FedapayPaymentProvider>(context, listen: false).makePayment(context: context, onInitialized: onInitialized);
                  },
                ),
              ],
            ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: checkout.isInitializing,
          builder: (context, value, child) {
            if(!value)return const SizedBox();
            return Container(
              color: checkout.theme.textColor.withOpacity(.4),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: checkout.theme.primaryColor,)
                ],
              ),
            );
          },
        )
      ],
    );
  }
}