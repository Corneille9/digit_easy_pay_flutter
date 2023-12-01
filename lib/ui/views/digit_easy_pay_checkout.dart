import 'package:digit_easy_pay_flutter/src/common/inherited_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/providers/country_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_service.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/flexible_bottom_sheet_route.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/mobile_payment_builder.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/payment_methods_builder.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/visa_payment_builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DigitEasyPayCheckout{
  BuildContext context;
  final num amount;
  final DigitEasyPayCurrency currency;
  final PaymentService provider;
  final PaymentTheme theme;
  final L10n? l10n;
  final VoidCallback? onCancel;
  final DigitEasyPayCallback? onSuccess;
  final ValueNotifier<DigitEasyPayPaymentMethod> selectedMethod = ValueNotifier(DigitEasyPayPaymentMethod.momo);

  DigitEasyPayCheckout({required this.context, required this.amount, required this.currency, required this.provider,this.l10n, this.onCancel, this.onSuccess, PaymentTheme? theme}):theme = theme??DefaultPaymentTheme();

  void onMethodChange(DigitEasyPayPaymentMethod method){
    // controller.animateToPage(DigitEasyPayPaymentMethod.values.indexOf(method), duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
  
  void init(){
    showStickyFlexibleBottomSheet(
      maxHeaderHeight: 180,
      minHeaderHeight: 180,
      minHeight: 0.5,
      initHeight: 0.85,
      maxHeight: 1,
      isDismissible: false,
      isCollapsible: false,
      l10n: l10n,
      bottomSheetBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),
      context: context,
      bottomSheetColor: theme.backgroundColor,
      providers: [
        ChangeNotifierProvider(create: (context) => CountryProvider()..getCountries(this),),
        ChangeNotifierProvider(create: (context) => PaymentProvider(theme: theme)),
      ],
      onWillPop: () async{
        return false;
      },
      headerBuilder: (context, bottomSheetOffset) => getHeaders(context),
      bodyBuilder: (context, bottomSheetOffset) {
        return SliverChildListDelegate(
          [
            _DigitEasyPayPaymentBuilder(checkout: this)
          ]
        );
      },
      anchors: [0.5, 1],
    );
  }

  Widget getHeaders(BuildContext context){
    this.context = context;
    return Consumer<CountryProvider>(
      builder: (context, countryProvider, child) {
        return Container(
          color: theme.backgroundColor,
          child: Container(
            color: countryProvider.hasData?theme.backgroundSubtleColor:null,
            child: Stack(
              children: [
                if(countryProvider.hasData)Column(
                  children: [
                    const SizedBox(height: 15,),
                    Image.asset(theme.isLight?PaymentImages.digitEasyPayLight:PaymentImages.digitEasyPayDark, package: "digit_easy_pay_flutter", height: 55,),
                    const SizedBox(height: 10,),
                    RichText(
                      maxLines: 1,
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "${InheritedL10n.of(context).l10n.totalToPay} : ",
                                style: TextStyle(fontWeight: FontWeight.w900, color: theme.textColor)
                            ),
                            TextSpan(
                              text: " ${PaymentUtils.formatAmount(amount, currency)}",
                              style: TextStyle(fontWeight: FontWeight.w900, color: theme.primaryColor),
                            )
                          ]
                      ),
                    ),
                    const SizedBox(height: 15,),
                    //Payment methods
                    DigitEasyPayPaymentMethodBuilder(
                      selectedMethod: selectedMethod,
                      onSelect: onMethodChange,
                      theme: theme,
                    ),
                  ],
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: InkWell(
                    // onTap: () {
                    // },
                    onTap: () => onPayCancel(context),
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
                  ) ,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void onPaySuccess({required String ref}){
    var l10n = InheritedL10n.of(context).l10n;

    var isPop = false;
    Future.delayed(const Duration(seconds: 5), () {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= (isPop?1:2));
      onSuccess?.call(ref, DigitEasyPayPaymentSource.QOSIC, selectedMethod.value.toSnakeCase);
    },);

    showDialog(context: context, barrierDismissible:false, builder: (context) {
      return Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green,),
              const SizedBox(height: 20,),
              Text(l10n.paymentSuccessfully, textAlign: TextAlign.center, style: TextStyle(color: theme.textColor),)
            ],
          ),
        ),
      );
    },).whenComplete(() => isPop = true);
  }

  void onPayError({required String ref}){
    var l10n = InheritedL10n.of(context).l10n;

    var isPop = false;
    Future.delayed(const Duration(seconds: 5), () {
      if(!isPop)Navigator.pop(context);
    },);
    showDialog(context: context, barrierDismissible:false, builder: (context) {
      return Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: theme.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, size: 100, color: Colors.redAccent,),
              const SizedBox(height: 20,),
              Text(l10n.paymentFailed, textAlign: TextAlign.center, style: TextStyle(color: theme.textColor))
            ],
          ),
        ),
      );
    },).whenComplete(() => isPop = true);
  }

  void onPayCancel(BuildContext pcontext){

    var l10n = InheritedL10n.of(pcontext).l10n;

    var paymentProvider  = Provider.of<PaymentProvider>(pcontext, listen: false);

    if(!paymentProvider.isLoading){
      int count = 0;
      Navigator.of(context).pop();
      paymentProvider.cancelStream();
      onCancel?.call();
      return;
    }

    showDialog(context: pcontext, barrierDismissible:true, builder: (context) {
      return Dialog(
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.cancelPayment, textAlign: TextAlign.center, style: TextStyle(color: theme.textColor)),
              const SizedBox(height: 10,),
              Text(l10n.wantToCancel, textAlign: TextAlign.center, style: TextStyle(color: theme.textColor)),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: theme.primaryColor)
                        ),
                        foregroundColor: theme.textColor
                      ),
                      child: Text(l10n.no)
                  ),
                  const SizedBox(width: 15,),
                  OutlinedButton(
                      onPressed: () {
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                        paymentProvider.cancelStream();
                        onCancel?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: theme.primaryColor)
                        ),
                        foregroundColor: theme.textColor
                      ),
                      child: Text(l10n.yes)
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },);
  }
}

class _DigitEasyPayPaymentBuilder extends StatefulWidget {
  const _DigitEasyPayPaymentBuilder({Key? key, required this.checkout}) : super(key: key);
  final DigitEasyPayCheckout checkout;

  @override
  State<_DigitEasyPayPaymentBuilder> createState() => _DigitEasyPayPaymentBuilderState();
}

class _DigitEasyPayPaymentBuilderState extends State<_DigitEasyPayPaymentBuilder> with AutomaticKeepAliveClientMixin{

  DigitEasyPayCheckout get _checkout => widget.checkout;

  PaymentTheme get theme => _checkout.theme;

  L10n get l10n => InheritedL10n.of(context).l10n;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer2<CountryProvider, PaymentProvider>(
      builder: (context, countryProvider, paymentProvider, child) {
        return ValueListenableBuilder(
          valueListenable: _checkout.selectedMethod,
          builder: (context, value, child) {

            if(countryProvider.hasError){
              return Container(
                height: 200,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.anErrorOccurCheckConnection,
                      style: TextStyle(color: theme.textColor, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15,),
                    ElevatedButton(
                      onPressed: () {
                        countryProvider.getCountries(_checkout);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        backgroundColor: _checkout.theme.primaryColor,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                      ),
                      child: Text(
                        l10n.retry,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            if(!countryProvider.hasData){
              return SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(color: theme.primaryColor),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: theme.backgroundSubtleColor
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: value==DigitEasyPayPaymentMethod.momo,
                    child: DigitEasyPayMobilePaymentBuilder(
                      checkout: _checkout,
                      onProcessPayment: (charge) => paymentProvider.makeMobilePayment(checkout: _checkout, charge: charge),
                    ),
                  ),
                  Visibility(
                    visible: value==DigitEasyPayPaymentMethod.flooz,
                    child: DigitEasyPayMobilePaymentBuilder(
                      checkout: _checkout,
                      onProcessPayment: (charge) => paymentProvider.makeMobilePayment(checkout: _checkout, charge: charge),
                    ),
                  ),
                  Visibility(
                    visible: value==DigitEasyPayPaymentMethod.visa,
                    child: DigitEasyPayVisaPaymentBuilder(
                      checkout: _checkout,
                      countries: countryProvider.countries,
                      onProcessPayment: (charge) => paymentProvider.makeCardPayment(checkout: _checkout, charge: charge),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}