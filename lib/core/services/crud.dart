// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Crud extends GetxController {
  getRequest(String url) async {
    try {
      // جلب التوكن من التخزين المحلي
      String token = GetStorage().read('token') ?? '';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📥 رد السيرفر (${response.statusCode}): ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // ⚠️ لا يوجد نتائج - نرجع الجسم كما هو (قد يحتوي على status: fail)
        return jsonDecode(response.body);
      } else {
        // ❌ أخطاء أخرى (500، 403، 401، ...إلخ)
        Get.snackbar(
            'خطأ', 'غير قادر على الاتصال بالخادم: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('🚨 استثناء أثناء الاتصال: $e');
      Get.snackbar('خطأ', 'تعذر الاتصال بالخادم');
      return null;
    }
  }

  postRequest(String url, Map<String, String> datas) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      var response = await http.post(
        Uri.parse(url),
        body: datas,
        headers: {
          'apiPassword': '',
          'Accept': 'application/json',
          'userLang': 'ar',
        },
      );

      var statusCode = response.statusCode;
      // ignore: prefer_typing_uninitialized_variables
      var responseBody;

      try {
        responseBody = jsonDecode(response.body);
      } catch (e) {
        if (kDebugMode) {
          print("فشل في تحويل الرد إلى JSON:");
          print(response.body);
        }
        return {
          'status': 'error',
          'message': 'فشل في تحليل استجابة الخادم',
          'raw': response.body,
          'statusCode': statusCode,
        };
      }

      if (statusCode == 200) {
        return responseBody;
      } else {
        if (kDebugMode) {
          print("فشل الطلب. الكود: $statusCode");
          print("الرد: $responseBody");
        }
        return {
          'status': 'error',
          'message': responseBody['message'] ?? 'حدث خطأ غير متوقع',
          'errors': responseBody['errors'] ?? {},
          'statusCode': statusCode,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("حدث استثناء أثناء الاتصال: $e");
      }
      return {
        'status': 'error',
        'message': 'فشل الاتصال بالخادم',
      };
    } finally {
      update();
    }
  }

  // ✅ الدالة المعدّلة لحل المشكلة
  fileRequest(String url, Map<String, String> data, File? file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // إضافة الهيدرات
      request.headers.addAll({
        'Accept': 'application/json',
        'userLang': 'ar',
      });

      // ✅ إضافة الملف فقط إذا كان موجودًا
      if (file != null) {
        var length = await file.length();
        var stream = http.ByteStream(file.openRead());
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(file.path),
        );
        request.files.add(multipartFile);
      }

      // إضافة البيانات
      request.fields.addAll(data);

      // إرسال الطلب
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${responseBody.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(responseBody.body);
      } else if (response.statusCode == 422) {
        var errorResponse = jsonDecode(responseBody.body);
        return {
          'status': 'error',
          'message': errorResponse['message'] ?? 'بيانات غير صالحة',
          'errors': errorResponse['errors'] ?? {}
        };
      } else {
        return {
          'status': 'error',
          'message': 'خطأ في الخادم (${response.statusCode})',
          'body': responseBody.body
        };
      }
    } catch (e) {
      print('Error in fileRequest: $e');
      return {'status': 'error', 'message': 'فشل الاتصال بالخادم'};
    }
  }

  multiFileRequestMoreImagePath(String url, Map<String, String> datas,
      List<XFile> files, List<String> imagePaths) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'apiPassword': '',
      'Accept': 'application/json',
      'userLang': 'ar',
    });
    for (int i = 0; i < files.length; i++) {
      var file = files[i];
      var length = await file.length();
      var stream = http.ByteStream(file.openRead());
      var multipartFile = http.MultipartFile(imagePaths[i], stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
    }

    datas.forEach((key, value) {
      request.fields[key] = value;
    });

    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      print(response.body);
      var responseBody = jsonDecode(response.body);
      print(responseBody['status'] + responseBody['message']);
    }

    update();
  }

  multiFileRequestOneImagePath(String url, Map<String, String> datas,
      List<XFile> files, String imagePaths) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'apiPassword': '',
      'Accept': 'application/json',
      'userLang': 'ar',
    });
    for (int i = 0; i < files.length; i++) {
      var file = files[i];
      var length = await file.length();
      var stream = http.ByteStream(file.openRead());
      var multipartFile = http.MultipartFile(imagePaths, stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
    }

    datas.forEach((key, value) {
      request.fields[key] = value;
    });

    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      print(response.body);
      var responseBody = jsonDecode(response.body);
      print(responseBody['status'] + responseBody['message']);
    }

    update();
  }

  putFileRequest(String url, Map<String, String> data, File? file) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      // ✅ جلب التوكن من التخزين المحلي
      String token = GetStorage().read('token') ?? '';

      // ✅ إضافة الهيدرز
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'userLang': 'ar',
      });

      // ✅ إضافة الملف إن وُجد
      if (file != null) {
        var length = await file.length();
        var stream = http.ByteStream(file.openRead());
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(file.path),
        );
        request.files.add(multipartFile);
      }

      // ✅ إضافة البيانات
      request.fields.addAll(data);

      // إرسال الطلب
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Status Code (PUT): ${response.statusCode}");
      print("Response Body (PUT): ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 422) {
        var errorResponse = jsonDecode(response.body);
        return {
          'status': 'error',
          'message': errorResponse['message'] ?? 'بيانات غير صالحة',
          'errors': errorResponse['errors'] ?? {},
        };
      } else {
        return {
          'status': 'error',
          'message': 'خطأ في الخادم (${response.statusCode})',
          'body': response.body,
        };
      }
    } catch (e) {
      print('Error in putFileRequest: $e');
      return {'status': 'error', 'message': 'فشل الاتصال بالخادم'};
    }
  }
}
