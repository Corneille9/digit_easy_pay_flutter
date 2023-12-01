import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/common/inherited_l10n.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_images.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/src/providers/payment_provider.dart';
import 'package:digit_easy_pay_flutter/ui/views/digit_easy_pay_checkout.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DigitEasyPayVisaPaymentBuilder extends StatefulWidget {
  const DigitEasyPayVisaPaymentBuilder({Key? key, required this.checkout, required this.countries, this.onProcessPayment}) : super(key: key);
  final DigitEasyPayCheckout checkout;
  final List<Country> countries;
  final Function(CardPayRequest charge)? onProcessPayment;

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
  List<Country> get countries => widget.countries;

  String _phoneNumber = '';

  final _formKey = GlobalKey<FormState>();

  DigitEasyPayCheckout get _checkout => widget.checkout;

  L10n get l10n => InheritedL10n.of(context).l10n;

  PaymentProvider get _paymentProvider => Provider.of<PaymentProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Column(
            children:[
              CustomTextField(
                theme: _checkout.theme,
                controller: _titleController,
                hintText: '',
                label: l10n.title,
                fontSize: 12,
                selectFormField: true,
                suffixIcon: Icon(Icons.arrow_drop_down, color: _checkout.theme.textColor,),
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
                controller: _lastnameController,
                hintText: '',
                label: l10n.lastname,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                controller: _middleNameController,
                hintText: '',
                label: l10n.middleName,
                fontSize: 12,
                contentPadding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                keyboardType: TextInputType.emailAddress,
                contentPadding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                fontSize: 12,
                intlPhoneField: true,
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                onChanged: (value) {
                  _phoneNumber = value;
                },
                validator: (value) {
                  if(value==null)return l10n.invalidPhone;
                  return PaymentUtils.isPhoneNumber(value)?null:l10n.invalidPhone;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                theme: _checkout.theme,
                controller: _countryController,
                hintText: '',
                label: l10n.country,
                fontSize: 12,
                selectFormField: true,
                suffixIcon: Icon(Icons.arrow_drop_down, color: _checkout.theme.textColor,),
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                items: countries.map((e) {
                  return {
                    'value': e.id,
                    'label': e.name,
                  };
                }).toList(),
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
                controller: _departmentController,
                hintText: '',
                label: l10n.department,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                controller: _cityController,
                hintText: '',
                label: l10n.city,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                controller: _townController,
                hintText: '',
                label: l10n.neighborhood,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                controller: _address2Controller,
                hintText: '',
                label: l10n.address,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                controller: _buildingNumberController,
                hintText: '',
                label: l10n.buildingNumber,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                validator: (value) {
                  if(value==null || value.trim().isEmpty)return l10n.invalidField;
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              // CustomTextField(
              //   theme: _checkout.theme,
              //   controller: _postalCodeController,
              //   hintText: '',
              //   label: l10n.postalCode,
              //   fontSize: 12,
              //   contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              //   validator: (value) {
              //     if(value==null || value.trim().isEmpty)return l10n.invalidField;
              //     return null;
              //   },
              // ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
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

        Image.asset(PaymentImages.pciDss, height: 52,package: "digit_easy_pay_flutter"),

        const SizedBox(
          height: 200,
        ),
      ],
    );
  }

  void processPayment(BuildContext context){
    if(!_formKey.currentState!.validate()){
      return;
    }

    FocusScope.of(context).unfocus();

    CardPayRequest cardPayRequest = CardPayRequest(
      phoneNumber: PaymentUtils.reformatPhone(_phoneNumber),
      totalAmount: widget.checkout.amount,
      firstName: _firstnameController.text.trim(),
      lastName: _lastnameController.text.trim(),
      middleName: _middleNameController.text.trim(),
      currency: DigitEasyPayCurrency.XOF,
      title: _titleController.text.trim(),
      city: _cityController.text.trim(),
      address2: _address2Controller.text.trim(),
      town: _townController.text.trim(),
      department:_departmentController.text.trim(),
      buildingNumber: _buildingNumberController.text.trim(),
      email: _emailController.text.trim(),
      // postalCode: _postalCodeController.text.trim(),
      // emailDomain: _emailController.text.trim(),
      country: countries.firstWhere((element) => element.id.toString()==_countryController.text.trim(), orElse: () => countries.firstWhere((element) => element.code=="BJ"),),
      // iso2Code: _countryController.text.trim(),
    );

    widget.onProcessPayment?.call(cardPayRequest);
  }

  @override
  bool get wantKeepAlive => true;
}