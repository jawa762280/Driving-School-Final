import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  var userData = <String, dynamic>{}.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }

  // تحميل البيانات من التخزين المحلي عند بدء التشغيل
  void loadUserFromStorage() {
    userData.value = {
      'first_name': storage.read('firstName') ?? '',
      'last_name': storage.read('lastName') ?? '',
      'phone_number': storage.read('phone_number') ?? '',
      'image': storage.read('userImage') ?? '',
      'address': storage.read('address') ?? '',
      'date_of_Birth': storage.read('dateOfBirth') ?? '',
      'gender': storage.read('gender') ?? '',
    };
  }

  String sanitizeImageUrl(String url) {
    if (url.isEmpty) return '';

    // إزالة التكرار إذا وُجد
    final parts = url.split('/storage/');
    if (parts.length > 2) {
      return '${parts.first}/storage/${parts.last}';
    }

    return url;
  }

  // تحديث البيانات في الذاكرة والتخزين المحلي
  void updateUserData(Map<String, dynamic> updatedData) {
    // تحديث userData محليًا
    // ignore: invalid_use_of_protected_member
    userData.assignAll({...userData.value, ...updatedData});

    // تحديث التخزين المحلي لكل قيمة جديدة
    updatedData.forEach((key, value) {
      // تحويل مفاتيح userData إلى مفاتيح التخزين المحلي
      String storageKey;
      switch (key) {
        case 'first_name':
          storageKey = 'firstName';
          break;

        case 'last_name':
          storageKey = 'lastName';
          break;
        case 'phone_number':
          storageKey = 'phone_number';
          break;
        case 'email':
          storageKey = 'email';
          break;
        case 'image':
          storageKey = 'userImage';
          break;
        case 'address':
          storageKey = 'address';
          break;
        case 'date_of_Birth':
          storageKey = 'dateOfBirth';
          break;
        case 'gender':
          storageKey = 'gender';
          break;
        default:
          storageKey = key;
      }
      if (key == 'image' && value is String) {
        value = sanitizeImageUrl(value);
      }
      storage.write(storageKey, value);
    });
  }

  String get fullName =>
      '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'.trim();
}
