import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Crud crud = Crud();
  var isLoading = false.obs;

  goToUpdateInformation() {
    Get.toNamed(AppRouts.updateInformationScreen);
  }

  goToCarsScreen() {
    Get.toNamed(AppRouts.carsScreen, arguments: {'mode': 'view'});
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
                  final studentId =
                      data.read('user')[data.read('role').toString()]['id'];

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

  void logout() async {
    isLoading.value = true;
    try {
      String token = data.read('token') ?? '';

      // if (token.isEmpty) {
      //   await data.erase();
      //   Get.offAllNamed('/login');
      //   return;
      // }

      var response = await crud.logout(token, AppLinks.logout);

      if (response != null &&
          (response['status'] == 'success' || response['message'] != null)) {
        Get.snackbar('نجاح', response['message'] ?? 'تم تسجيل الخروج بنجاح');
        await data.erase();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('خطأ', 'فشل تسجيل الخروج، حاول مرة أخرى');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showLogoutDialog() {
    isLoading.value = false;

    // Get.dialog(
    //   Obx(() => AlertDialog(
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //         title: const Text(
    //           'تأكيد تسجيل الخروج',
    //           style: TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //         content: const Text(
    //           'هل أنت متأكد أنك تريد تسجيل الخروج من الحساب؟',
    //           textAlign: TextAlign.center,
    //         ),
    //         actionsAlignment: MainAxisAlignment.spaceBetween,
    //         actions: [
    //           ElevatedButton(
    //             onPressed: isLoading.value ? null : () => Get.back(),
    //             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    //             child: isLoading.value
    //                 ? const SizedBox(
    //                     width: 20,
    //                     height: 20,
    //                     child: CircularProgressIndicator(
    //                       color: Colors.white,
    //                       strokeWidth: 2,
    //                     ),
    //                   )
    //                 : const Text(
    //                     'إلغاء',
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //           ),
    //           ElevatedButton(
    //             onPressed: () {
    //               logout();
    //             },
    //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    //             child: isLoading.value
    //                 ? const SizedBox(
    //                     width: 20,
    //                     height: 20,
    //                     child: CircularProgressIndicator(
    //                       color: Colors.white,
    //                       strokeWidth: 2,
    //                     ),
    //                   )
    //                 : const Text(
    //                     'تأكيد',
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //           ),
    //         ],
    //       )),
    //   barrierDismissible: false,
    // );
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
            'هل أنت متأكد أنك تريد\nالخروج من الحساب؟',
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
                  logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("تأكيد", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
