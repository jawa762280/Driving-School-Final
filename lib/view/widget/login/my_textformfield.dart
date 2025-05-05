import 'package:flutter/material.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield(
      {super.key,
      required this.mycontroller,
      required this.keyboardType,
      required this.prefixIcon,
      required this.filled,
      this.onTapIcon,
      this.obscureText,
      required this.valid});
  final TextEditingController mycontroller;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final bool filled;
  final void Function()? onTapIcon;
  final bool? obscureText;
  final String? Function(String?) valid;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText == null || obscureText == false ? false : true,
      validator: valid,
      controller: mycontroller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: filled,
        fillColor: const Color(0xFFF2F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        prefixIcon: InkWell(
          onTap: onTapIcon,
          child: Icon(
            prefixIcon,
          ),
        ),
      ),
    );
  }
}
