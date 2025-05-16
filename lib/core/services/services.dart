import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  /// تهيئة SharedPreferences
  Future<MyServices> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  /// حفظ التوكن
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString("token", token);
  }

  /// الحصول على التوكن
  String? get token => sharedPreferences.getString("token");

  /// حذف التوكن (تسجيل الخروج مثلاً)
  Future<void> clearToken() async {
    await sharedPreferences.remove("token");
  }

  /// تحقق مما إذا كان المستخدم مسجل دخول
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
