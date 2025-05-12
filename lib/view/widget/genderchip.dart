import 'package:driving_school/core/constant/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String selectedValue;
  final void Function(String) onSelected;

  const GenderChip({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    return SizedBox(
      width: 120.w,
      child: ChoiceChip(
        label: Row(
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : Colors.grey, size: 18.sp),
            SizedBox(width: 6.w),
            Text(label,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onSelected(value),
        selectedColor: AppColors.primaryColor,
        backgroundColor: Colors.grey.shade200,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
    );
  }
}
