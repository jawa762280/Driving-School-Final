import 'dart:io';
import 'package:driving_school/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart'; // تأكد إنها مضافة بالأعلى


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
        print('تحميل الملف من: $url');
        final dio = Dio();
        await dio.download(url, filePath);
      } else {
        print('الملف موجود مسبقاً: $filePath');
      }

      localPath = filePath;
      print('تم حفظ الملف في: $filePath');
    } catch (e) {
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
  final String downloadUrl = 'http://192.168.1.107:8000/api/certificate/download';

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
      downloadUrl,
      savePath,
      options: Options(headers: headers),
    );

    print('✅ تم تحميل الشهادة في: $savePath');

    // 🔓 فتح الملف تلقائيًا بعد التحميل
    final result = await OpenFile.open(savePath);
    print('📄 حالة فتح الملف: ${result.message}');

    Get.snackbar('تم', 'تم تحميل الشهادة بنجاح ✅');
  } catch (e) {
    print('❌ خطأ أثناء تحميل الشهادة: $e');
    Get.snackbar('خطأ', 'فشل تحميل الشهادة');
  }
}

}
