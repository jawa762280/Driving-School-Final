import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  Crud crud = Crud();
  goToUpdateInformation() {
    Get.toNamed(AppRouts.updateInformationScreen);
  }

  void showDeleteAccountDialog() {
    Get.defaultDialog(
      title: '',
      contentPadding: EdgeInsets.zero,
      radius: 15,
      content: Column(
        children: [
          Icon(Icons.warning_amber_rounded, size: 60, color: Colors.redAccent),
          SizedBox(height: 16),
          Text(
            "هل أنت متأكد؟",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "هل تريد بالتأكيد حذف حسابك؟\nلا يمكنك التراجع بعد هذه العملية.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("إلغاء", style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final storage = GetStorage();
                  final studentId = storage.read('student_id');

                  final response = await crud.deleteRequest(
                    '${AppLinks.deleteAccount}/$studentId',
                  );

                  if (response != null && response['status'] == 'success') {
                    await data.erase();

                    Get.offAllNamed('/login');
                  } else {
                    Get.snackbar(
                        "خطأ", response?['message'] ?? 'فشل حذف الحساب');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("حذف", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
