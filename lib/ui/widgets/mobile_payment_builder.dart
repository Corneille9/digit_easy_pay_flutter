import 'package:digit_easy_pay_flutter/src/common/inherited_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_provider.dart';
import 'package:digit_easy_pay_flutter/ui/views/digit_easy_pay_checkout.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DigitEasyPayMobilePaymentBuilder extends StatefulWidget {
  const DigitEasyPayMobilePaymentBuilder({Key? key, required this.checkout, this.onProcessPayment}) : super(key: key);
  final DigitEasyPayCheckout checkout;
  final Function(MobilePayRequest charge)? onProcessPayment;


  @override
  State<DigitEasyPayMobilePaymentBuilder> createState() => _DigitEasyPayMobilePaymentBuilderState();
}

class _DigitEasyPayMobilePaymentBuilderState extends State<DigitEasyPayMobilePaymentBuilder> with AutomaticKeepAliveClientMixin{

  final TextEditingController _firstnameController = TextEditingController();

  final TextEditingController _lastnameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  String _phoneNumber = '';

  final _formKey = GlobalKey<FormState>();

  DigitEasyPayCheckout get _checkout => widget.checkout;

  L10n get l10n => InheritedL10n.of(context).l10n;

  PaymentProvider get _paymentProvider => Provider.of<PaymentProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [

          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            theme: _checkout.theme,
            controller: _lastnameController,
            hintText: '',
            label: l10n.lastname,
            fontSize: 12,
            contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
            validator: (value) {
              if(value==null || value.trim().isEmpty)return l10n.invalidField;
              return null;
            },

          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            theme: _checkout.theme,
            controller: _firstnameController,
            hintText: '',
            label: l10n.firstname,
            fontSize: 12,
            contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
            validator: (value) {
              if(value==null || value.trim().isEmpty)return l10n.invalidField;
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            theme: _checkout.theme,
            controller: _emailController,
            hintText: '',
            label: l10n.email,
            fontSize: 12,
            contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
            validator: (value) {
              if(value==null)return l10n.invalidEmail;
              return PaymentUtils.isEmail(value)?null:l10n.invalidEmail;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            theme: _checkout.theme,
            controller: _phoneController,
            hintText: '',
            label: l10n.phoneNumber,
            intlPhoneField: true,
            fontSize: 12,
            contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
            onChanged: (value) {
              _phoneNumber = value;
            },
            validator: (value) {
              if(value==null)return l10n.invalidPhone;

              if(!_checkout.provider.config.environment.isLive)return null;

              return PaymentUtils.isPhoneNumber(value)?null:l10n.invalidPhone;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              if(_paymentProvider.isLoading)return;
              processPayment(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: _checkout.theme.primaryColor,
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(_paymentProvider.isLoading)...[
                  const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white, ),
                  )
                ],
                if(!_paymentProvider.isLoading)Text(
                  "${l10n.pay} ${PaymentUtils.formatAmount(_checkout.amount, _checkout.currency)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          Image.asset(PaymentImages.pciDss, height: 52, package: "digit_easy_pay_flutter"),
          const SizedBox(
            height: 200,
          ),
          // const AddbBanner()
        ],
      ),
    );
  }

  void processPayment(BuildContext context){
    // FocusScope.of(context).unfocus();
    // MobilePayRequest mobilePayRequest = MobilePayRequest(phoneNumber: "dskjhkshkfjds", amount: widget.checkout.amount, firstName: _firstnameController.text.trim(), lastName: _lastnameController.text.trim(), email: _emailController.text.trim());
    // widget.onProcessPayment?.call(mobilePayRequest);
    //

    if(!_formKey.currentState!.validate()){
      return;
    }
    FocusScope.of(context).unfocus();
    MobilePayRequest mobilePayRequest = MobilePayRequest(phoneNumber: PaymentUtils.reformatPhone(_phoneNumber), amount: widget.checkout.amount, firstName: _firstnameController.text.trim(), lastName: _lastnameController.text.trim(), email: _emailController.text.trim());
    widget.onProcessPayment?.call(mobilePayRequest);
  }

  @override
  bool get wantKeepAlive => true;
}
