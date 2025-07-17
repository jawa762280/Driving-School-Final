import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextformfield extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();

  MyTextformfield({
    super.key,
    this.mycontroller,
    this.keyboardType,
    this.prefixIcon,
    this.filled,
    this.onTapIcon,
    this.obscureText,
    this.valid,
    this.iconColor,
    this.hintText,
    this.readOnly = false,
    this.onTapTextField,
    this.errorText,
    this.value,
    this.maxLines,
  });
  final TextEditingController? mycontroller;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool? filled;
  final void Function()? onTapIcon;
  final bool? obscureText;
  final String? Function(String?)? valid;
  final Color? iconColor;
  final String? hintText;
  final bool readOnly;
  final String? errorText;
  final void Function()? onTapTextField;
  final String? value;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      focusNode: _focusNode,

      // initialValue: value,
      onTap: onTapTextField,
      obscureText: obscureText == null || obscureText == false ? false : true,
      validator: valid,
      controller: mycontroller,
      onTapOutside: (event) {
        final f = FocusManager.instance.primaryFocus;
        if (f != null && f.context != null) {
          f.unfocus();
        }
      },
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        errorText: errorText,
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
