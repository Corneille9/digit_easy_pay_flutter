import 'package:digit_easy_pay_flutter/src/common/payment_constants.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:digit_easy_pay_flutter/ui/views/checkout.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class DigitEasyPayMobilePaymentBuilder extends StatefulWidget {
  const DigitEasyPayMobilePaymentBuilder({Key? key, required this.checkout}) : super(key: key);
  final DigitEasyPayCheckout checkout;


  @override
  State<DigitEasyPayMobilePaymentBuilder> createState() => _DigitEasyPayMobilePaymentBuilderState();
}

class _DigitEasyPayMobilePaymentBuilderState extends State<DigitEasyPayMobilePaymentBuilder> with AutomaticKeepAliveClientMixin{

  final TextEditingController _firstnameController = TextEditingController();

  final TextEditingController _lastnameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  String _phoneNumber = '';

  DigitEasyPayCheckout get _checkout => widget.checkout;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        CustomTextField(
          theme: _checkout.theme,
          controller: _lastnameController,
          hintText: '',
          label: 'Nom',
          fontSize: 12,
          contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextField(
          theme: _checkout.theme,
          controller: _firstnameController,
          hintText: '',
          label: 'Prénoms',
          fontSize: 12,
          contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextField(
          theme: _checkout.theme,
          controller: _emailController,
          hintText: '',
          label: 'Email',
          fontSize: 12,
          contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
        ),
        const SizedBox(
          height: 15,
        ),
        CustomTextField(
          theme: _checkout.theme,
          controller: _phoneController,
          hintText: '',
          label: 'Numéro de téléphone',
          intlPhoneField: true,
          fontSize: 12,
          contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
          onChanged: (value) {
            _phoneNumber = value;
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
            // processPayment(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: _checkout.theme.primaryColor,
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
          ),
          child: Text(
            "Payer ${_checkout.amount} FCFA",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),

        const SizedBox(
          height: 20,
        ),
        Image.asset(PaymentImages.pciDss, height: 52, package: "digit_easy_pay_flutter"),
        const SizedBox(
          height: 200,
        ),
        // //ADDB Banner
        // const AddbBanner()
      ],
    );
  }

  // void processPayment(BuildContext context){
  //
  //   var v = [_phoneController, _firstnameController, _lastnameController].map((e) => e.text.trim().isEmpty);
  //
  //   if(v.contains(true)){
  //     FlashMessage.simple(context: context, message: 'Veuillez remplir tous les champs');
  //     return;
  //   }
  //
  //   if(!_phoneNumber.isPhoneNumber){
  //     FlashMessage.simple(context: context, message: 'Numero de téléphone invalide');
  //     return;
  //   }
  //
  //   if(_emailController.text.trim().isNotEmpty && !_emailController.text.isEmail) {
  //     FlashMessage.simple(context: context, message: 'Adresse email invalide');
  //     return;
  //   }
  //
  //   MobilePayRequest mobilePayRequest = MobilePayRequest(phoneNumber: _phoneNumber.asPhoneWithoutPlus, amount: widget.amount, firstName: _firstnameController.text.trim(), lastName: _lastnameController.text.trim(), email: _emailController.text.trim());
  //
  //
  //   // onSuccess?.call("");
  //   var paymentMethod = widget.method;
  //   GetIt.I<AppModule>().paymentBlocSingleton.add(MakePayment(
  //     mobilePayRequest: mobilePayRequest,
  //     paymentMethod: paymentMethod,
  //     onSuccess: (response) {
  //       UIBlock.unblock(context);
  //       widget.onSuccess?.call(response.transferRef, paymentMethod.name);
  //     },
  //     onError: (message) {
  //       UIBlock.unblock(context);
  //       FlashMessage.simple(context: context, message: message);
  //     },
  //   ),);
  // }

  @override
  bool get wantKeepAlive => true;

}
