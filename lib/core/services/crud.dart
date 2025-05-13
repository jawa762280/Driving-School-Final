// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Crud extends GetxController {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        Get.snackbar('Error', 'Sunucuya Bağlanılamıyor');
      }
    } catch (e) {
      // Get.snackbar('Hata', e.toString());
      print(e.toString());
      debugPrint(e.toString());
    }
    update();
  }

  postRequest(String url, Map<String, String> datas) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var response = await http.post(Uri.parse(url), body: datas, headers: {
      'apiPassword': '',
      'Accept': 'application/json',
      'userLang': 'ar',
      // 'userLang': data.read('lang').toString(),
    });
    try {
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        var responseBody = jsonDecode(response.body);
        print(responseBody['message'] ?? responseBody['status']);
        if (responseBody['message'].toString() == 'User Not Found') {}
        if (response.statusCode == 400) {}
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        print(response.body);
        print(e.toString());
      }
    }
    update();
  }

  fileRequest(String url, Map<String, String> data, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile('image[]', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      // Get.snackbar('Hata', response.toString());
      // Get.snackbar('Hata', response.statusCode.toString());
      // Get.snackbar('Hata', response.body);
      print(response.statusCode.toString());
      print(response.body);
      print(response);
      var responseBody = jsonDecode(response.body);
      print(responseBody['status']);
      print(responseBody['message']);
    }
    update();
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
      // Get.snackbar('Error', response.toString());
      // Get.snackbar('Error', response.statusCode.toString());
      // Get.snackbar('Error', response.body);
      print(response.body);
      print(response);
      var responseBody = jsonDecode(response.body);
      print(responseBody['status'] + responseBody['message']);
      // Get.snackbar(responseBody['status'], responseBody['message']);
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
      // Get.snackbar('Error', response.toString());
      // Get.snackbar('Error', response.statusCode.toString());
      // Get.snackbar('Error', response.body);
      print(response.body);
      print(response);
      var responseBody = jsonDecode(response.body);
      print(responseBody['status'] + responseBody['message']);
      // Get.snackbar(responseBody['status'], responseBody['message']);
    }

    update();
  }
}
