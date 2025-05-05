import 'package:get/get.dart';

validInput(val, min, max, type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "اسم المستخدم غير صالح";
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "بريد إلكتروني غير صالح";
    }
  }
  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) {
      return "رقم الهاتف غير صالح";
    }
  }
  if (val.isEmpty) {
    return "لا يمكن أن يكون فارغا";
  }

  if (val.length < min) {
    return "لا يمكن أن يكون أقل من $min";
  }
  if (val.length > max) {
    return "لا يمكن أن يكون أكبر من $max";
  }
}
