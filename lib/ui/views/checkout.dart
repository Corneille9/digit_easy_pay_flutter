import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/src/providers/country_provider.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_provider.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/flexible_bottom_sheet_header_delegate.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/flexible_bottom_sheet_route.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/mobile_payment_builder.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/payment_methods_builder.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/visa_payment_builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DigitEasyPayCheckout{
  final BuildContext context;
  final num amount;
  final PaymentProvider provider;
  final PaymentTheme theme;
  final PageController controller = PageController();
  final VoidCallback? onCancel;
  final Function(String reference, String paymentMethod)? onSuccess;
  ScrollController? scrollController;
  final ValueNotifier<DigitEasyPayPaymentMethod> selectedMethod = ValueNotifier(DigitEasyPayPaymentMethod.momo);

  DigitEasyPayCheckout({required this.context, required this.amount,required this.provider, this.onCancel, this.onSuccess, PaymentTheme? theme}):theme = theme??DefaultPaymentTheme();

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
      bottomSheetBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),
      context: context,
      bottomSheetColor: theme.backgroundColor,
      headerBuilder: (context, bottomSheetOffset) => getHeaders(),
      bodyBuilder: (context, bottomSheetOffset) {
        return SliverChildListDelegate(
          [
            MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => CountryProvider()..getCountries(this),)
                ],
                child: DigitEasyPayPaymentBuilder(checkout: this)
            ),
          ]
        );
      },
      anchors: [0.5, 1],
      // isSafeArea: true,
      // isModal: true
    );
  }

  Widget getHeaders(){
    return Container(
      color: theme.backgroundColor,
      child: Container(
        color: theme.backgroundSubtleColor,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 15,),
                Image.asset(PaymentImages.digitEasyPayAdaptative, package: "digit_easy_pay_flutter",),
                const SizedBox(height: 10,),
                RichText(
                  maxLines: 1,
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Total achat : ",
                            style: TextStyle(fontWeight: FontWeight.w900, color: theme.textColor)
                        ),
                        TextSpan(
                          text: " $amount FCFA",
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
              ) ,
            )
          ],
        ),
      ),
    );
  }
}

class DigitEasyPayPaymentBuilder extends StatefulWidget {
  const DigitEasyPayPaymentBuilder({Key? key, required this.checkout}) : super(key: key);
  final DigitEasyPayCheckout checkout;

  @override
  State<DigitEasyPayPaymentBuilder> createState() => _DigitEasyPayPaymentBuilderState();
}

class _DigitEasyPayPaymentBuilderState extends State<DigitEasyPayPaymentBuilder> with AutomaticKeepAliveClientMixin{

  DigitEasyPayCheckout get _checkout => widget.checkout;

  PaymentTheme get theme => _checkout.theme;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<CountryProvider>(
      builder: (context, countryProvider, child) {
        return ValueListenableBuilder(
          valueListenable: _checkout.selectedMethod,
          builder: (context, value, child) {

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
                    ),
                  ),
                  Visibility(
                    visible: value==DigitEasyPayPaymentMethod.flooz,
                    child: DigitEasyPayMobilePaymentBuilder(
                      checkout: _checkout,
                    ),
                  ),
                  Visibility(
                    visible: value==DigitEasyPayPaymentMethod.visa,
                    child: DigitEasyPayVisaPaymentBuilder(
                      checkout: _checkout,
                      countries: countryProvider.countries,
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
