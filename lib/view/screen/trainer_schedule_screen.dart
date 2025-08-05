import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/trainer_schedule_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class TrainerScheduleScreen extends StatelessWidget {
  const TrainerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrainerScheduleController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "إنشاء جدول تدريب",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(() => Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeSlideTransition(
                        delay: 100,
                        child: _title("👋 مرحبًا أيها المدرب!"),
                      ),
                      FadeSlideTransition(
                        delay: 250,
                        child: _subTitle("يرجى تعبئة الجدول الخاص بك بعناية:"),
                      ),
                      20.verticalSpace,
                      FadeSlideTransition(
                        delay: 400,
                        child: _buildCard(
                          title: "📅 اختر اليوم",
                          child: Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: controller.days.map((day) {
                              final isSelected =
                                  controller.selectedDay.value == day;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryColor
                                                .withAlpha((0.4 * 255).toInt()),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : null,
                                ),
                                child: InkWell(
                                  onTap: () => controller.selectDay(day),
                                  borderRadius: BorderRadius.circular(10.r),
                                  splashColor: AppColors.primaryColor
                                      .withAlpha((0.3 * 255).toInt()),
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      FadeSlideTransition(
                        delay: 550,
                        child: _buildCard(
                          title: "⏰ وقت الجلسة",
                          child: Row(
                            children: [
                              _timeSelector(
                                  "البداية",
                                  controller
                                      .formatTime(controller.startTime.value),
                                  () => controller.pickTime(isStartTime: true)),
                              12.horizontalSpace,
                              _timeSelector(
                                  "النهاية",
                                  controller
                                      .formatTime(controller.endTime.value),
                                  () =>
                                      controller.pickTime(isStartTime: false)),
                            ],
                          ),
                        ),
                      ),
                      FadeSlideTransition(
                        delay: 700,
                        child: _buildCard(
                          title: "📆 الفترة الزمنية",
                          child: Row(
                            children: [
                              _timeSelector(
                                  "من",
                                  controller
                                      .formatDate(controller.validFrom.value),
                                  () => controller.pickDate(isFrom: true)),
                              12.horizontalSpace,
                              _timeSelector(
                                  "إلى",
                                  controller
                                      .formatDate(controller.validTo.value),
                                  () => controller.pickDate(isFrom: false)),
                            ],
                          ),
                        ),
                      ),
                      FadeSlideTransition(
                        delay: 850,
                        child: _buildCard(
                          title: "🔁 تكرار الجلسة",
                          child: Row(
                            children: [
                              Switch.adaptive(
                                value: controller.isRecurring.value,
                                onChanged: (val) =>
                                    controller.isRecurring.value = val,
                                activeColor: AppColors.primaryColor,
                              ),
                              const Text("تكرار أسبوعي",
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      Center(
                        child: AnimatedGradientButton(
                          onPressed: controller.submitSchedule,
                          text: "حفظ الجدول",
                          icon: Icons.save,
                        ),
                      )
                    ],
                  ),
                ),
                if (controller.isLoading.value)
                  Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryColor)),
              ],
            )),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.12 * 255).toInt()),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
          12.verticalSpace,
          child,
        ],
      ),
    );
  }

  Widget _timeSelector(String label, String value, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        splashColor: AppColors.primaryColor.withAlpha((0.3 * 255).toInt()),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
              4.verticalSpace,
              Text(value,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87));
  }

  Widget _subTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Text(text,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
    );
  }
}

class FadeSlideTransition extends StatefulWidget {
  final Widget child;
  final int delay;
  const FadeSlideTransition({super.key, required this.child, this.delay = 0});

  @override
  State<FadeSlideTransition> createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

class AnimatedGradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;

  const AnimatedGradientButton(
      {super.key, required this.onPressed, required this.text, this.icon});

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnim1;
  late Animation<Color?> _colorAnim2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _colorAnim1 = ColorTween(
      begin: AppColors.primaryColor,
      end: AppColors.secondColor,
    ).animate(_controller);

    _colorAnim2 = ColorTween(
      begin: AppColors.secondColor,
      end: AppColors.primaryColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ElevatedButton.icon(
            onPressed: widget.onPressed,
            icon: widget.icon != null
                ? Icon(widget.icon, color: Colors.white)
                : const SizedBox(),
            label: Text(
              widget.text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              backgroundColor: _colorAnim1.value,
              shadowColor: _colorAnim2.value,
              elevation: 6,
            ),
          );
        });
  }
}
