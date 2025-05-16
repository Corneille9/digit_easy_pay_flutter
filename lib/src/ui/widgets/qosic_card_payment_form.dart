import 'package:digit_easy_pay_flutter/digit_easy_pay_flutter.dart';
import 'package:digit_easy_pay_flutter/src/common/payment_validator.dart';
import 'package:digit_easy_pay_flutter/src/models/card_pay_request.dart';
import 'package:digit_easy_pay_flutter/src/models/country.dart';
import 'package:digit_easy_pay_flutter/src/providers/country_provider.dart';
import 'package:flutter/material.dart';

import '../../http/payment_service.dart';
import 'custom_text_field.dart';

class QosicCardPaymentForm extends StatefulWidget {
  const QosicCardPaymentForm({
    super.key,
    required this.paymentRequest,
    required this.paymentService,
  });

  final PaymentRequest paymentRequest;

  final PaymentService paymentService;

  @override
  State<QosicCardPaymentForm> createState() => QosicCardPaymentFormState();
}

class QosicCardPaymentFormState extends State<QosicCardPaymentForm>
    with AutomaticKeepAliveClientMixin {
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

  final _formKey = GlobalKey<FormState>();

  late final CountryProvider countryProvider = CountryProvider(service: paymentService);

  List<Country> get countries => countryProvider.countries;

  String _phoneNumber = '';

  PaymentRequest get paymentRequest => widget.paymentRequest;

  PaymentService get paymentService => widget.paymentService;

  PaymentConfig get config => DigitEasyPayFlutter.config;

  PaymentTheme get theme => config.theme;

  L10n get l10n => config.lang;

  @override
  void initState() {
    countryProvider.init();
    super.initState();
  }

  @override
  void dispose() {
    countryProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ValueListenableBuilder(
        valueListenable: countryProvider,
        builder: (context, value, child) {
          if (countryProvider.isError) {
            return Center(
              child: Container(
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
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        countryProvider.init();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                        backgroundColor: theme.primaryColor,
                      ),
                      child: Text(l10n.retry, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (countryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 200),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  CustomTextField(
                    theme: theme,
                    controller: _titleController,
                    hintText: l10n.title,
                    label: l10n.title,
                    fontSize: 12,
                    selectFormField: true,
                    suffixIcon: Icon(Icons.arrow_drop_down, color: theme.textColor),
                    contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    items: const [
                      {'value': 'Mr', 'label': 'Mr'},
                      {'value': 'Mme', 'label': 'Mme'},
                      {'value': 'Mlle', 'label': 'Mlle'},
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return l10n.invalidField;
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    theme: theme,
                    controller: _lastnameController,
                    hintText: l10n.lastname,
                    label: l10n.lastname,
                    fontSize: 12,
                    contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return l10n.invalidField;
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    theme: theme,
                    controller: _firstnameController,
                    hintText: l10n.firstname,
                    label: l10n.firstname,
                    fontSize: 12,
                    contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return l10n.invalidField;
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  // CustomTextField(
                  //   theme: theme,
                  //   controller: _middleNameController,
                  //   hintText: l10n.middleName,
                  //   label: l10n.middleName,
                  //   fontSize: 12,
                  //   contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 5),
                  CustomTextField(
                    theme: theme,
                    controller: _emailController,
                    hintText: l10n.email,
                    label: l10n.email,
                    fontSize: 12,
                    keyboardType: TextInputType.emailAddress,
                    contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    validator: (value) {
                      if (value == null) return l10n.invalidEmail;
                      return PaymentUtils.isEmail(value) ? null : l10n.invalidEmail;
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    theme: theme,
                    controller: _phoneController,
                    hintText: l10n.phoneNumber,
                    label: l10n.phoneNumber,
                    fontSize: 12,
                    intlPhoneField: true,
                    contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    onChanged: (value) {
                      _phoneNumber = value;
                    },
                    validator: (value) {
                      if (value == null) return l10n.invalidPhone;
                      return PaymentUtils.isPhoneNumber(value) ? null : l10n.invalidPhone;
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    theme: theme,
                    controller: _countryController,
                    hintText: l10n.country,
                    label: l10n.country,
                    fontSize: 12,
                    selectFormField: true,
                    suffixIcon: Icon(Icons.arrow_drop_down, color: theme.textColor),
                    contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    items:
                        countries.map((e) {
                          return {'value': e.id, 'label': e.name};
                        }).toList(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return l10n.invalidField;
                      return null;
                    },
                  ),
                  // const SizedBox(height: 5),
                  // CustomTextField(
                  //   theme: theme,
                  //   controller: _departmentController,
                  //   hintText:  l10n.department,
                  //   label: l10n.department,
                  //   fontSize: 12,
                  //   contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 5),
                  // CustomTextField(
                  //   theme: theme,
                  //   controller: _cityController,
                  //   hintText: l10n.city,
                  //   label: l10n.city,
                  //   fontSize: 12,
                  //   contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 5),
                  // CustomTextField(
                  //   theme: theme,
                  //   controller: _townController,
                  //   hintText: l10n.neighborhood,
                  //   label: l10n.neighborhood,
                  //   fontSize: 12,
                  //   contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 5),
                  // CustomTextField(
                  //   theme: theme,
                  //   controller: _address2Controller,
                  //   hintText: l10n.address,
                  //   label: l10n.address,
                  //   fontSize: 12,
                  //   contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 5),
                  // CustomTextField(
                  //   theme: theme,
                  //   controller: _buildingNumberController,
                  //   hintText: l10n.buildingNumber,
                  //   label: l10n.buildingNumber,
                  //   fontSize: 12,
                  //   contentPadding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  //   validator: (value) {
                  //     // if (value == null || value.trim().isEmpty) return l10n.invalidField;
                  //     return null;
                  //   },
                  // ),
                  // CustomTextField(
                  //   theme: theme,
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
          );
        },
      ),
    );
  }

  CardPayRequest? validate(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return null;
    }

    FocusScope.of(context).unfocus();

    return CardPayRequest(
      phoneNumber: PaymentUtils.reformatPhone(_phoneNumber),
      totalAmount: paymentRequest.amount,
      firstName: _firstnameController.text.trim(),
      lastName: _lastnameController.text.trim(),
      middleName: "DEFAULT",
      // middleName: _middleNameController.text.trim(),
      currency: Currency.XOF,
      title: _titleController.text.trim(),
      city: "DEFAULT",
      // city: _cityController.text.trim(),
      address2: "DEFAULT",
      // address2: _address2Controller.text.trim(),
      town: "DEFAULT",
      // town: _townController.text.trim(),
      department: "DEFAULT",
      // department: _departmentController.text.trim(),
      buildingNumber: "DEFAULT",
      // buildingNumber: _buildingNumberController.text.trim(),
      email: _emailController.text.trim(),
      // postalCode: _postalCodeController.text.trim(),
      // emailDomain: _emailController.text.trim(),
      country: countries.firstWhere(
        (element) => element.id.toString() == _countryController.text.trim(),
        orElse: () => countries.firstWhere((element) => element.code == "BJ"),
      ),
      // iso2Code: _countryController.text.trim(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
