import 'package:driving_school/main.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyServices extends GetxService {
  Future<MyServices> init() async {
    await GetStorage.init();
    return this;
  }

  Future<void> saveToken(String token) async {
    data.write('token', token);
  }

  String? get token => data.read('token');

  Future<void> clearToken() async {
    data.remove('token');
  }

  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
