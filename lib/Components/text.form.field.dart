import 'package:flutter/material.dart';

class TextEnterArea extends StatelessWidget {
  final bool? enabled;
  final String? hintText;
  final String? labelText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onFiledSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const TextEnterArea(
      {super.key,
      this.hintText,
      this.enabled,
      this.labelText,
      required this.controller,
      this.prefixIcon,
      this.onChanged,
      this.obscureText = false,
      this.keyboardType,
      this.onFiledSubmitted,
      this.validator,
      this.focusNode,
      this.suffixIcon,
      this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 55,
          maxHeight: 65,
        ),
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          color: const Color.fromARGB(87, 134, 134, 134),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          //error text in center
          textAlignVertical: TextAlignVertical.center,

          onChanged: onChanged,
          focusNode: focusNode, //it is used to focus on the text field
          textInputAction:
              textInputAction, //it is used to change the keyboard action button
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          enabled: enabled,
          onFieldSubmitted: onFiledSubmitted,
          controller: controller,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            border: InputBorder.none,
            hintText: hintText,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
