import 'package:get/get.dart';

validInput(val, min, max, type) {
  if (val.isEmpty) {
    return "لا يمكن أن يكون فارغا";
  }

  if (val.length < min) {
    return "لا يمكن أن يكون أقل من $min";
  }

  if (val.length > max) {
    return "لا يمكن أن يكون أكبر من $max";
  }

  if (type == "username") {
    if (!RegExp(r"^[\u0621-\u064Aa-zA-Z\s]+$").hasMatch(val)) {
      return "اسم المستخدم يجب أن يحتوي على أحرف فقط (عربية أو إنجليزية)";
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
  if (type == "password") {
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(val)) {
      return "يجب أن تحتوي على حرف كبير وحرف صغير ورقم على الأقل.";
    }
  }
  if (type == "address") {
    if (val.length > 255) {
      return "يجب ألا يتجاوز العنوان 255 حرفاً.";
    }
  }
  if (type == "date_of_Birth") {
    DateTime? birthDate = DateTime.tryParse(val);
    if (birthDate == null) {
      return "يجب إدخال تاريخ صحيح.";
    }
    if (birthDate.isAfter(DateTime.now())) {
      return "يجب أن يكون تاريخ الولادة في الماضي أو اليوم.";
    }
  }
  if (type == "role") {
    if (!["student", "trainer", "employee"].contains(val)) {
      return "يجب أن يكون الدور أحد: trainer أو student أو employee.";
    }
  }
  if (type == "gender") {
    if (!["male", "female"].contains(val)) {
      return "يجب أن يكون الجنس أحد: female أو male.";
    }
  }

  return null; 
}
