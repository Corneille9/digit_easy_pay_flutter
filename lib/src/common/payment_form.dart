import 'package:flutter/material.dart';

import 'form_request.dart';

abstract class PaymentForm{
  FormRequest? validate(BuildContext context);
}