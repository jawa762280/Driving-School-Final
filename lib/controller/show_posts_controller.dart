import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/core/services/crud.dart';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ShowPostsController extends GetxController {
  List posts = [];
  bool isLoading = true;
  final Crud crud = Crud();
  int selectedFilterIndex = 0;
  String filterType = 'all';

  List<String> filterTypes = ['الكل', 'صور', 'PDF'];

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  void setFilterByIndex(int index) {
    selectedFilterIndex = index;
    switch (index) {
      case 0:
        filterType = 'all';
        break;
      case 1:
        filterType = 'image';
        break;
      case 2:
        filterType = 'pdf';
        break;
    }
    update();
  }

  List get filteredPosts {
    if (filterType == 'all') return posts;
    return posts.where((post) {
      if (post['files'].isEmpty) return false;
      final fileType = post['files'][0]['type'];
      return fileType == filterType;
    }).toList();
  }

  Future<void> fetchPosts() async {
    isLoading = true;
    update();
    var response = await crud.getRequest(AppLinks.showPosts);

    if (response['success'] == true) {
      posts = response['data'].map((post) {
        post['liked_users'] ??= [];
        return post;
      }).toList();
    } else {
      posts = [];
    }

    isLoading = false;
    update();
  }

  Future<void> toggleLike(int postId, int index) async {
    var response =
        await crud.postRequest("${AppLinks.likePost}/$postId/like", {});
    if (response['status'] == "success") {
      bool currentLike = posts[index]['liked_by_auth_user'];
      posts[index]['liked_by_auth_user'] = !currentLike;
      posts[index]['likes_count'] += currentLike ? -1 : 1;
      update();
      Get.snackbar(
        "نجاح",
        currentLike ? "تم إلغاء الإعجاب بالمنشور" : "تم الإعجاب بالمنشور",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:
            currentLike ? Colors.red.shade200 : Colors.green.shade200,
        colorText: Colors.white,
      );
    }
  }

  Future<void> openPdfFile(String url, String fileName) async {
    try {
      // إظهار رسالة التحميل
      Get.snackbar(
        "تحميل الملف",
        "📥 يتم تحميل الملف، انتظر بعض الوقت...",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black87,
        duration: const Duration(seconds: 4),
      );

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$fileName';

      // تحميل الملف
      await Dio().download(url, filePath);

      // فتح الملف
      final result = await OpenFile.open(filePath);

      if (result.type == ResultType.done) {
        Get.snackbar(
          "نجاح",
          "✅ تم فتح الملف بنجاح",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black87,
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception("لم يتمكن من فتح الملف");
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "❌ تعذر فتح الملف",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade200,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
