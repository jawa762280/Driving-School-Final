import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield({
    super.key,
    required this.mycontroller,
    this.keyboardType,
    this.prefixIcon,
    required this.filled,
    this.onTapIcon,
    this.obscureText,
    this.valid,
    this.iconColor,
    this.hintText,
    this.readOnly = false,
    this.onTapTextField,
  });
  final TextEditingController mycontroller;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool filled;
  final void Function()? onTapIcon;
  final bool? obscureText;
  final String? Function(String?)? valid;
  final Color? iconColor;
  final String? hintText;
  final bool readOnly;
  final void Function()? onTapTextField;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTapTextField,
      obscureText: obscureText == null || obscureText == false ? false : true,
      validator: valid,
      controller: mycontroller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        filled: filled,
        fillColor: const Color(0xFFF2F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        prefixIcon: InkWell(
          onTap: onTapIcon,
          child: Icon(
            prefixIcon,
            color: iconColor,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
