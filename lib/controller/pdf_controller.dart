import 'dart:io';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

class PdfController extends GetxController {
  var isLoading = false.obs;
  String? localPath;

  Future<void> downloadPdf(String url, String fileName) async {
    try {
      isLoading.value = true;
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);

      if (!await file.exists()) {
        // ignore: avoid_print
        print('تحميل الملف من: $url');
        final dio = Dio();
        await dio.download(url, filePath);
      } else {
        // ignore: avoid_print
        print('الملف موجود مسبقاً: $filePath');
      }

      localPath = filePath;
      // ignore: avoid_print
      print('تم حفظ الملف في: $filePath');
    } catch (e) {
      // ignore: avoid_print
      print('خطأ أثناء تحميل الملف: $e');
      Get.snackbar('خطأ', 'فشل تحميل الشهادة');
      localPath = null;
    } finally {
      isLoading.value = false;
    }
  }

  void downloadCertificate(BuildContext context, String fileName) async {
    final Dio dio = Dio();
    final String token = data.read("token");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/pdf',
      'Accept-Encoding': 'gzip',
      'Authorization': 'Bearer $token',
    };

    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$fileName';

      await dio.download(
        AppLinks.downloadUrl,
        savePath,
        options: Options(headers: headers),
      );

      // ignore: avoid_print
      print('✅ تم تحميل الشهادة في: $savePath');

      final result = await OpenFile.open(savePath);
      // ignore: avoid_print
      print('📄 حالة فتح الملف: ${result.message}');

      Get.snackbar('تم', 'تم تحميل الشهادة بنجاح ✅');
    } catch (e) {
      // ignore: avoid_print
      print('❌ خطأ أثناء تحميل الشهادة: $e');
      Get.snackbar('خطأ', 'فشل تحميل الشهادة');
    }
  }
}
