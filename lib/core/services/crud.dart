// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Crud extends GetxController {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        Get.snackbar('خطأ', 'غير قادر على الاتصال بالخادم');
      }
    } catch (e) {
      print(e.toString());
    }
    update();
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
}
