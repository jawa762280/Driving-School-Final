import 'package:driving_school/main.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyServices extends GetxService {
  /// تهيئة SharedPreferences
  Future<MyServices> init() async {
    await GetStorage.init();
    return this;
  }

  /// حفظ التوكن
  Future<void> saveToken(String token) async {
    data.write('token', token);
  }

  /// الحصول على التوكن
  String? get token => data.read('token');

  /// حذف التوكن (تسجيل الخروج مثلاً)
  Future<void> clearToken() async {
    data.remove('token');
  }

  /// تحقق مما إذا كان المستخدم مسجل دخول
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
