import 'package:driving_school/core/constant/appimages.dart';
import 'package:driving_school/view/widget/containersearch.dart';
import 'package:driving_school/view/widget/customsearchbar.dart';
import 'package:driving_school/view/widget/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyAppBar(
                          image: Image.asset(AppImages.appPhoto),
                          widget: Text(
                            "البحث",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomSearchBar(),
                        SizedBox(height: 50),
                        ContainerSearch(
                            image: 'image',
                            name: 'جوى اسعد',
                            email: "jawaasaad@gmail.com",
                            adressText: "العنوان",
                            adress: "المزة ,الشام",
                            phone: "0991817817",
                            phoneText: "رقم العاتف",
                            birthdayText: "تاريخ الولادة",
                            birthday: "22.06.2001"),
                        SizedBox(
                          height: 15,
                        ),
                        ContainerSearch(
                            image: 'image',
                            name: 'احمد حافظ',
                            email: "ahmad@gmail.com",
                            adressText: "العنوان",
                            adress: "المزة ,الشام",
                            phone: "854452489",
                            phoneText: "رقم العاتف",
                            birthdayText: "تاريخ الولادة",
                            birthday: "22.06.2001"),
                        SizedBox(
                          height: 15,
                        ),
                        ContainerSearch(
                            image: 'image',
                            name: 'جوى اسعد',
                            email: "jawaasaad@gmail.com",
                            adressText: "العنوان",
                            adress: "المزة ,الشام",
                            phone: "0991817817",
                            phoneText: "رقم العاتف",
                            birthdayText: "تاريخ الولادة",
                            birthday: "22.06.2001"),
                      ])),
            ))));
  }
}
