import 'package:flutter/material.dart';

/// Dark
const dark = Color(0xff1d1c21);

/// Error
const error = Color(0xffff6767);

/// N0
const neutral0 = Color(0xff1c1c1d);

const neutral0Subtle = Color(0x0d1d1c21);

const neutral1 = Color(0xBEB7B7B7);

/// N2
const neutral2 = Color(0xff9e9cab);

/// N7
const neutral7 = Color(0xffffffff);

/// N7 with opacity
const neutral7WithOpacity = Color(0x80ffffff);

/// Primary
const primary = Color(0xFF22A36B);

/// Secondary
const secondary = Color(0xfff5f5f7);

/// Secondary dark
const secondaryDark = Color(0xff2b2250);

/// Base chat theme containing all required properties to make a theme.
/// Extend this class if you want to create a custom theme.
@immutable
abstract class PaymentTheme {
  /// Creates a new chat theme based on provided colors and text styles.
  const PaymentTheme({
    this.isLight = true,
    required this.backgroundColor,
    required this.backgroundSubtleColor,
    required this.errorColor,
    required this.inputBackgroundColor,
    required this.inputBorderRadius,
    required this.unSelectedMethodColor,
    required this.unSelectedMethodTextColor,
    required this.inputBorder,
    required this.inputPadding,
    required this.inputTextColor,
    this.inputTextCursorColor,
    required this.inputTextDecoration,
    required this.inputTextStyle,
    required this.textColor,
    required this.primaryColor,
    required this.dialogBackgroundColor,
    required this.paymentSourceShadowColor,
  });

  final bool isLight;

  /// Used as a background color of a chat widget
  final Color backgroundColor;

  final Color backgroundSubtleColor;

  /// Color to indicate something bad happened (usually - shades of red)
  final Color errorColor;

  /// Color of the bottom bar where text field is
  final Color inputBackgroundColor;

  /// Top border radius of the bottom bar where text field is
  final BorderRadius inputBorderRadius;

  /// Inner insets of the bottom bar where text field is
  final EdgeInsets inputPadding;

  /// Color of the text field's text and attachment/send buttons
  final Color inputTextColor;

  /// Color of the text field's cursor
  final Color? inputTextCursorColor;

  /// Decoration of the input text field
  final InputDecoration inputTextDecoration;

  /// Text style of the message input. To change the color use [inputTextColor].
  final TextStyle inputTextStyle;

  final Color unSelectedMethodColor;

  final Color unSelectedMethodTextColor;

  final InputBorder inputBorder;

  final Color textColor;

  final Color dialogBackgroundColor;

  /// Primary color of the chat used as a background of sent messages
  /// and statuses
  final Color primaryColor;

  final Color paymentSourceShadowColor;
}

/// Default chat theme which extends [PaymentTheme]
@immutable
class DefaultPaymentTheme extends PaymentTheme {
  /// Creates a default chat theme. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [PaymentTheme]
  DefaultPaymentTheme({
    super.isLight,
    super.backgroundColor = neutral7,
    super.backgroundSubtleColor = neutral0Subtle,
    super.errorColor = error,
    super.inputBackgroundColor = neutral7,
    super.inputBorderRadius = const BorderRadius.vertical(top: Radius.circular(20)),
    Decoration? inputContainerDecoration,
    EdgeInsets inputMargin = EdgeInsets.zero,
    super.inputPadding = const EdgeInsets.fromLTRB(24, 20, 24, 20),
    super.inputTextColor = neutral0,
    super.inputTextCursorColor = primary,
    super.inputTextDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      isCollapsed: true,
    ),
    super.inputTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
    super.unSelectedMethodColor = neutral1,
    super.unSelectedMethodTextColor = neutral0,
    InputBorder? inputBorder,
    super.textColor = neutral0,
    super.primaryColor = primary,
    super.dialogBackgroundColor = neutral7,
  }) : super(
         inputBorder:
             inputBorder ??
             OutlineInputBorder(
               borderRadius: BorderRadius.circular(12),
               borderSide: BorderSide(color: neutral0.withOpacity(0.1), width: 1),
             ),
         paymentSourceShadowColor: const Color(0xFFECECEC),
       );
}

/// Dark chat theme which extends [PaymentTheme]
@immutable
class DarkPaymentTheme extends PaymentTheme {
  /// Creates a dark chat theme. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [PaymentTheme]

  DarkPaymentTheme({
    super.isLight = false,
    super.backgroundColor = Colors.black,
    super.backgroundSubtleColor = neutral0Subtle,
    super.errorColor = error,
    super.inputBackgroundColor = dark,
    super.inputBorderRadius = const BorderRadius.vertical(top: Radius.circular(20)),
    Decoration? inputContainerDecoration,
    EdgeInsets inputMargin = EdgeInsets.zero,
    super.inputPadding = const EdgeInsets.fromLTRB(24, 20, 24, 20),
    super.inputTextColor = neutral7,
    super.inputTextCursorColor = primary,
    super.inputTextDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      isCollapsed: true,
    ),
    super.inputTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
    super.unSelectedMethodColor = neutral7,
    super.unSelectedMethodTextColor = neutral7,
    super.textColor = neutral7,
    InputBorder? inputBorder,
    super.primaryColor = primary,
    super.dialogBackgroundColor = dark,
    super.paymentSourceShadowColor = const Color(0xff1d1c21),
  }) : super(
         inputBorder:
             inputBorder ??
             OutlineInputBorder(
               borderRadius: BorderRadius.circular(12),
               borderSide: BorderSide(color: neutral7.withOpacity(0.1), width: 1),
             ),
       );
}
