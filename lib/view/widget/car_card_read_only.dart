import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:driving_school/data/model/car_model.dart';
import 'package:driving_school/core/constant/appimages.dart';

class CarCardReadonly extends StatelessWidget {
  final CarModel car;

  const CarCardReadonly({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // الصورة بخفض  ارتفاع بسيط لحل overflow
          SizedBox(
            height: 110.h,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: car.image != null
                  ? Image.network(
                      car.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
          ),

          // المحتوى السفلي بمساحة أقل padding رأسي
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // اسم السيارة ورقم اللوحة
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${car.make} ${car.model}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '(${car.year}) - ${car.licensePlate}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // المميزات عمودياً
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _featureItem(Icons.palette, car.color),
                      SizedBox(height: 4.h),
                      _featureItem(Icons.settings, car.transmission),
                    ],
                  ),

                  // نوع السيارة بتقليل البادينج الرأسي
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: car.isForSpecialNeeds
                          ? Colors.pink.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      car.displayType,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: car.isForSpecialNeeds
                            ? Colors.pink
                            : Colors.green.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: Center(
        child: Image.asset(
          car.isForSpecialNeeds ? AppImages.specialneedscar : AppImages.car,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey[600]),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
