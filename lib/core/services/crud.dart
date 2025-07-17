// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:driving_school/core/constant/app_api.dart';
import 'package:driving_school/core/constant/approuts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Crud extends GetxController {
  final data = GetStorage();

  Future<bool> refreshToken() async {
    String? refreshToken = data.read('refreshToken');
    if (refreshToken == null) {
      print("❌ لا يوجد refresh token مخزن");
      return false;
    }

    var response = await http.post(
      Uri.parse(AppLinks.refreshToken),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Encoding': 'gzip'
      },
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    print("🔄 Refresh Token Response: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      String newToken = jsonResponse['data']['token'];
      data.write('token', newToken);

      print("✅ Token refreshed successfully");
      return true;
    } else {
      print("❌ Failed to refresh token: ${response.body}");

      data.remove('token');
      data.remove('refreshToken');

      Get.offAllNamed(AppRouts.loginScreen);

      return false;
    }
  }

  Future<T?> retryOnUnauthorized<T>(Future<T?> Function() requestFn) async {
    T? response = await requestFn();

    if (response is Map && response['statusCode'] == 401) {
      bool refreshed = await refreshToken();
      if (refreshed) {
        return await requestFn();
      }
    }
    return response;
  }

  Future<dynamic> getRequest(String url) async {
    return await retryOnUnauthorized(() async {
      try {
        String token = data.read('token') ?? '';

        var response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Encoding': 'gzip'
          },
        );

        print("🔵 [GET] URL: $url");
        print("🟡 Status Code: ${response.statusCode}");
        print("📦 Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 404) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          print("🔴 Unauthorized (401)");
          return {'statusCode': 401};
        } else {
          print("❗Unhandled Status Code: ${response.statusCode}");
          return {
            'statusCode': response.statusCode,
            'body': response.body,
          };
        }
      } catch (e) {
        print('❌ Exception in getRequest: $e');
        return {'error': e.toString()};
      }
    });
  }

  Future<dynamic> postRequest(String url, Map<String, dynamic> dataMap) async {
    return await retryOnUnauthorized(() async {
      try {
        String token = data.read('token') ?? '';

        var response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Encoding': 'gzip'
          },
          body: jsonEncode(dataMap),
        );

        print("🔗 POST to: $url");
        print("📦 Data: $dataMap");
        print("📬 Status Code: ${response.statusCode}");
        print("📬 Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          return {'statusCode': 401};
        } else if (response.statusCode == 422) {
          return {
            'status': false,
            'message':
                jsonDecode(response.body)['message'] ?? 'بيانات غير صالحة',
            'errors': jsonDecode(response.body)['errors'] ?? {}
          };
        } else {
          return {
            'status': false,
            'message': 'Unexpected error',
            'statusCode': response.statusCode,
            'body': response.body
          };
        }
      } catch (e) {
        print('⚠️ Exception in postRequest: $e');
        return {
          'status': false,
          'message': 'Exception',
          'error': e.toString(),
        };
      }
    });
  }

  fileRequestPOST(String url, Map<String, String> dataMap, File? file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      String token = data.read('token') ?? '';

      print(token);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'userLang': 'ar',
      });

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

      request.fields.addAll(dataMap);

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
    return await retryOnUnauthorized(() async {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        String token = data.read('token') ?? '';

        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'userLang': 'ar',
          'Accept-Encoding': 'gzip'
        });

        for (int i = 0; i < files.length; i++) {
          var file = files[i];
          var length = await file.length();
          var stream = http.ByteStream(file.openRead());
          var multipartFile = http.MultipartFile(
            imagePaths[i],
            stream,
            length,
            filename: basename(file.path),
          );
          request.files.add(multipartFile);
        }

        datas.forEach((key, value) {
          request.fields[key] = value;
        });

        var myRequest = await request.send();
        var response = await http.Response.fromStream(myRequest);

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseBody = jsonDecode(response.body);
          return responseBody;
        } else if (response.statusCode == 401) {
          return {'statusCode': 401};
        } else if (response.statusCode == 422) {
          var errorResponse = jsonDecode(response.body);
          return {
            'status': false,
            'message': errorResponse['message'] ?? 'بيانات غير صالحة',
            'errors': errorResponse['errors'] ?? {}
          };
        } else {
          var responseBody = jsonDecode(response.body);
          return {
            'status': false,
            'message': responseBody['message'] ?? 'خطأ غير متوقع',
            'statusCode': response.statusCode,
            'body': response.body,
          };
        }
      } catch (e) {
        print('Exception in multiFileRequestMoreImagePath: $e');
        return {
          'status': false,
          'message': 'فشل الاتصال بالخادم',
          'error': e.toString(),
        };
      }
    });
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

  Future<dynamic> putFileRequest(String url, Map<String, String> fields,
      String filePath, String fieldName) async {
    return await retryOnUnauthorized(() async {
      try {
        String token = data.read('token') ?? '';

        var request = http.MultipartRequest('PUT', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll(fields);
        request.files
            .add(await http.MultipartFile.fromPath(fieldName, filePath));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          return {'statusCode': 401};
        } else {
          return null;
        }
      } catch (e) {
        print('Exception in putFileRequest: $e');
        return null;
      }
    });
  }

  Future<dynamic> deleteRequest(String url) async {
    return await retryOnUnauthorized(() async {
      try {
        String token = data.read('token') ?? '';

        var response = await http.delete(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Encoding': 'gzip'
          },
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          return {'statusCode': 401};
        } else {
          return null;
        }
      } catch (e) {
        print('Exception in deleteRequest: $e');
        return null;
      }
    });
  }

  fileRequest(String url, Map<String, String> datas, File? file, String s) async {
    return await retryOnUnauthorized(() async {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      String token = data.read('token') ?? '';

      print(token);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'userLang': 'ar',
        'Accept-Encoding': 'gzip'
      });

      if (file != null) {
        var length = await file.length();
        var stream = http.ByteStream(file.openRead());
        var multipartFile = http.MultipartFile('image', stream, length,
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
      } else if (response.statusCode == 401) {
        return {'statusCode': 401};
      } else {
        print(response.statusCode.toString());
        print(response.body);
        print(response);
        var responseBody = jsonDecode(response.body);
        print(responseBody['status']);
        print(responseBody['message']);
        return responseBody;
      }
    });
  }

  Future<Map<String, dynamic>?> logout(String token, String url) async {
    return await retryOnUnauthorized(() async {
      try {
        var response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Encoding': 'gzip'
          },
        );

        if (response.statusCode == 200 || response.statusCode == 401) {
          return jsonDecode(response.body);
        } else {
          return null;
        }
      } catch (e) {
        print('Error in logout: $e');
        return null;
      }
    });
  }
}
