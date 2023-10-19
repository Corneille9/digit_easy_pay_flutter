import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/ui/views/checkout.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';


class DigitEasyPayVisaPaymentBuilder extends StatefulWidget {
  const DigitEasyPayVisaPaymentBuilder({Key? key, required this.checkout}) : super(key: key);
  final DigitEasyPayCheckout checkout;

  @override
  State<DigitEasyPayVisaPaymentBuilder> createState() => _DigitEasyPayVisaPaymentBuilderState();
}

class _DigitEasyPayVisaPaymentBuilderState extends State<DigitEasyPayVisaPaymentBuilder> with AutomaticKeepAliveClientMixin{

  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _buildingNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  List<Country> countries = [];

  String _phoneNumber = '';

  DigitEasyPayCheckout get _checkout => widget.checkout;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Column(
          children:[
            CustomTextField(
              theme: _checkout.theme,
              controller: _titleController,
              hintText: '',
              label: 'Titre',
              fontSize: 12,
              selectFormField: true,
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white,),
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              items: const [
                {
                  'value': 'Mr',
                  'label': 'Mr',
                },
                {
                  'value': 'Mme',
                  'label': 'Mme',
                },
                {
                  'value': 'Mlle',
                  'label': 'Mlle',
                }
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _lastnameController,
              hintText: '',
              label: 'Nom',
              fontSize: 12,
              contentPadding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
              contentPadding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _middleNameController,
              hintText: '',
              label: 'Second prénom',
              fontSize: 12,
              contentPadding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
              keyboardType: TextInputType.emailAddress,
              contentPadding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _phoneController,
              hintText: '',
              label: 'Numéro de téléphone',
              fontSize: 12,
              intlPhoneField: true,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              onChanged: (value) {
                _phoneNumber = value;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _countryController,
              hintText: '',
              label: 'Pays',
              fontSize: 12,
              selectFormField: true,
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white,),
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              items: countries.map((e) {
                return {
                  'value': e.id,
                  'label': e.name,
                };
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _departmentController,
              hintText: '',
              label: 'Département',
              fontSize: 12,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _cityController,
              hintText: '',
              label: 'Ville',
              fontSize: 12,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _townController,
              hintText: '',
              label: 'Quartier',
              fontSize: 12,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _address2Controller,
              hintText: '',
              label: 'Adresse',
              fontSize: 12,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _buildingNumberController,
              hintText: '',
              label: 'Numéro de carré ou de maison',
              fontSize: 12,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              theme: _checkout.theme,
              controller: _postalCodeController,
              hintText: '',
              label: 'Code postal',
              fontSize: 12,
              contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
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

        Image.asset(PaymentImages.pciDss, height: 52,package: "digit_easy_pay_flutter"),

        const SizedBox(
          height: 200,
        ),
      ],
    );
  }

  // void processPayment(BuildContext context){
  //
  //   var v = [
  //     _phoneController, _firstnameController, _lastnameController,
  //     _townController,_address2Controller,_buildingNumberController,
  //     _departmentController,_emailController,
  //     _postalCodeController, _countryController,_titleController,
  //     _cityController,
  //   ].map((e) => e.text.trim().isEmpty);
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
  //   if(!_emailController.text.isEmail){
  //     FlashMessage.simple(context: context, message: 'Adresse email invalide');
  //     return;
  //   }
  //
  //   CardPayRequest cardPayRequest = CardPayRequest(
  //     phoneNumber: _phoneNumber.asPhoneWithoutPlus,
  //     totalAmount: widget.amount,
  //     firstName: _firstnameController.text.trim(),
  //     lastName: _lastnameController.text.trim(),
  //     middleName: _middleNameController.text.trim(),
  //     currency: Currency.XOF,
  //     title: _titleController.text.trim(),
  //     city: _cityController.text.trim(),
  //     address2: _address2Controller.text.trim(),
  //     town: _townController.text.trim(),
  //     department:_departmentController.text.trim(),
  //     buildingNumber: _buildingNumberController.text.trim(),
  //     email: _emailController.text.trim(),
  //     postalCode: _postalCodeController.text.trim(),
  //     emailDomain: _emailController.text.trim(),
  //     country: countries.firstWhere((element) => element.id.toString()==_countryController.text.trim()),
  //     iso2Code: _countryController.text.trim(),
  //   );
  //
  //   FocusScope.of(context).unfocus();
  //
  //   UIBlock.block(context, customLoaderChild: AppUtils.customLoaderChild());
  //
  //   // onSuccess?.call("");
  //   GetIt.I<AppModule>().paymentBlocSingleton.add(MakeCardPayment(
  //     cardPayRequest: cardPayRequest,
  //     onSuccess: (response) {
  //       UIBlock.unblock(context);
  //       widget.onSuccess?.call(response.reference, DigitEasyPayPaymentMethod.visa.name);
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