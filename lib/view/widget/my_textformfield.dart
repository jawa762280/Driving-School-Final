import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextformfield extends StatelessWidget {
  const MyTextformfield(
      {super.key,
      required this.mycontroller,
      required this.keyboardType,
      required this.prefixIcon,
      required this.filled,
      this.onTapIcon,
      this.obscureText,
      required this.valid,
      this.iconColor});
  final TextEditingController mycontroller;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final bool filled;
  final void Function()? onTapIcon;
  final bool? obscureText;
  final String? Function(String?) valid;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText == null || obscureText == false ? false : true,
      validator: valid,
      controller: mycontroller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
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
