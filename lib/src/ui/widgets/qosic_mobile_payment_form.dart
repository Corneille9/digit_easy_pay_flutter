import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/models/mobile_pay_request.dart';
import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class QosicMobilePaymentForm extends StatefulWidget {
  const QosicMobilePaymentForm({super.key, required this.paymentRequest});

  final PaymentRequest paymentRequest;

  @override
  State<QosicMobilePaymentForm> createState() => QosicMobilePaymentFormState();
}

class QosicMobilePaymentFormState extends State<QosicMobilePaymentForm>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _firstnameController = TextEditingController();

  final TextEditingController _lastnameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';

  final _formKey = GlobalKey<FormState>();

  PaymentRequest get paymentRequest => widget.paymentRequest;

  PaymentConfig get config => DigitEasyPayFlutter.config;

  PaymentTheme get theme => config.theme;

  L10n get l10n => config.lang;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 200),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              CustomTextField(
                theme: theme,
                controller: _lastnameController,
                hintText: l10n.lastname,
                keyboardType: TextInputType.name,
                label: l10n.lastname,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                theme: theme,
                controller: _firstnameController,
                hintText: l10n.firstname,
                keyboardType: TextInputType.name,
                label: l10n.firstname,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                theme: theme,
                controller: _emailController,
                hintText: l10n.email,
                keyboardType: TextInputType.emailAddress,
                label: l10n.email,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                validator: (value) {
                  if (value == null) return l10n.invalidEmail;
                  return PaymentUtils.isEmail(value) ? null : l10n.invalidEmail;
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                theme: theme,
                controller: _phoneController,
                hintText: l10n.phoneNumber,
                keyboardType: TextInputType.phone,
                label: l10n.phoneNumber,
                intlPhoneField: true,
                fontSize: 12,
                contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                onChanged: (value) {
                  _phoneNumber = value;
                },
                validator: (value) {
                  if (value == null) return l10n.invalidPhone;

                  return PaymentUtils.isPhoneNumber(PaymentUtils.reformatPhone(value))
                      ? null
                      : l10n.invalidPhone;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  MobilePayRequest? validate(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return null;
    }
    FocusScope.of(context).unfocus();
    return MobilePayRequest(
      phoneNumber: PaymentUtils.reformatPhone(_phoneNumber),
      amount: paymentRequest.amount,
      firstName: _firstnameController.text.trim(),
      lastName: _lastnameController.text.trim(),
      email: _emailController.text.trim(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
