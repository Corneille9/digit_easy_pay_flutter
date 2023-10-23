import 'package:digit_easy_pay_flutter/src/common/payment_theme.dart';
import 'package:digit_easy_pay_flutter/ui/widgets/select_form_field.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key,required this.theme,  this.controller, this.hintText, this.prefixIcon, this.obscureText=false, this.suffixIcon, this.keyboardType, this.maxLines=1, this.readOnly = false, this.elevate = false, this.onChanged, this.textAlign=TextAlign.start, this.minLines, this.label, this.required = false, this.fillColor, this.onTap, this.border, this.intlPhoneField = false, this.autofocus, this.labelFontSize, this.onCreate, this.selectFormField = false, this.items, this.borderColor, this.fontSize, this.contentPadding, this.initialValue, this.focusNode, this.isPasswordField, this.isDense, this.borderRadius, this.validator}) : super(key: key);
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? isPasswordField;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final bool elevate;
  final Function(String value)? onChanged;
  final TextAlign textAlign;
  final String? label;
  final bool required;
  final Color? fillColor;
  final VoidCallback? onTap;
  final InputBorder? border;
  final bool intlPhoneField;
  final bool selectFormField ;
  final List<Map<String, dynamic>>? items;
  final bool? autofocus;
  final double? labelFontSize;
  final Function(CustomTextField customTextField)? onCreate;
  final Color? borderColor;
  final double? fontSize;
  final EdgeInsets? contentPadding;
  final String? initialValue;
  final FocusNode? focusNode;
  final bool? isDense;
  final BorderRadius? borderRadius;
  final String? Function(String?)? validator;

  final PaymentTheme theme;

  Widget? get _prefixIcon => (prefixIcon==null)?null:Padding(
    padding: const EdgeInsets.all(15.0),
    child: prefixIcon,
  );

  Widget? get _suffixIcon {
    if(suffixIcon!=null)return suffixIcon;

    if(isPasswordField==true){
      return obscureText? const Icon(Icons.visibility_off_outlined) :const Icon(Icons.visibility_off_outlined);
    }

    return null;
  }

  InputBorder get _border => border??theme.inputBorder;

  Widget _textFormField(BuildContext context){

    if(selectFormField){
      return SelectFormField(
        controller: controller,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: fontSize),
        type: SelectFormFieldType.dropdown, // or can be dialog
        initialValue: initialValue,
        hintText: hintText,
        readOnly: readOnly,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autofocus: autofocus??false,
        theme: theme,
        // menuBackgroundColor: theme.backgroundColor,
        onChanged: (value) {
          onChanged?.call(value);
        },
        textAlign: textAlign,
        onSaved: (value) {},
        cursorColor: theme.inputTextCursorColor,
        decoration: InputDecoration(
          filled: true,
          isDense: isDense,
          fillColor: theme.inputBackgroundColor,
          hintText: hintText,
          contentPadding: contentPadding, // <-- SEE HERE
          hintStyle: TextStyle(overflow: TextOverflow.visible, color: theme.inputTextColor.withOpacity(0.5), fontSize: fontSize),
          suffixIcon: _suffixIcon,
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
          errorBorder: _border.copyWith(borderSide: _border.borderSide.copyWith(color: theme.errorColor)),
          focusedErrorBorder: _border.copyWith(borderSide: _border.borderSide.copyWith(color: theme.errorColor)),
          prefixIcon: _prefixIcon,
          hintMaxLines: minLines,
        ),
        items: items,
        validator: validator,
      );
    }

    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      autofocus: autofocus??false,
      maxLines: maxLines,
      onChanged: (value) {
        onChanged?.call(value);
      },
      textAlign: textAlign,
      onSaved: (value) {},
      cursorColor: theme.inputTextCursorColor,
      style: TextStyle(fontWeight: FontWeight.bold, color: theme.inputTextColor, fontSize: fontSize),
      decoration: InputDecoration(
        filled: true,
        isDense: isDense,
        contentPadding: contentPadding, // <-- SEE HERE
        fillColor: theme.inputBackgroundColor,
        hintText: hintText,
        hintStyle: TextStyle(overflow: TextOverflow.visible, color: theme.inputTextColor.withOpacity(0.5), fontSize: fontSize),
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _suffixIcon??SizedBox()
          ],
        ),
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
        errorBorder: _border.copyWith(borderSide: _border.borderSide.copyWith(color: theme.errorColor)),
        focusedErrorBorder: _border.copyWith(borderSide: _border.borderSide.copyWith(color: theme.errorColor)),
        prefixIcon: _prefixIcon,
        hintMaxLines: minLines,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { onCreate?.call(this);});

    return _build(context);
  }

  Widget _build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label!=null)...[
          Wrap(
            children: [
              Text(label!, style: TextStyle(fontWeight: FontWeight.w400, color: theme.inputTextColor, fontSize: labelFontSize??14),),              // const SizedBox(width: 5,),
              if(required)
                Text("*", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: labelFontSize),)            ],
          ),
          const SizedBox(height: 10,),
        ],
        _textFormField(context),
      ],
    );
  }
}
