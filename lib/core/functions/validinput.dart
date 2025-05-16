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

  // التحقق من نوع المدخلات بناءً على الـ type
  if (type == "username") {
    // تحقق من أن اسم المستخدم صالح
    if (!GetUtils.isUsername(val)) {
      return "اسم المستخدم غير صالح";
    }
  }
  if (type == "email") {
    // تحقق من أن البريد الإلكتروني صالح
    if (!GetUtils.isEmail(val)) {
      return "بريد إلكتروني غير صالح";
    }
  }
  if (type == "phone") {
    // تحقق من أن رقم الهاتف صالح
    if (!GetUtils.isPhoneNumber(val)) {
      return "رقم الهاتف غير صالح";
    }
  }
  if (type == "password") {
    // تحقق من كلمة المرور بناءً على القواعد
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)').hasMatch(val)) {
      return "يجب أن تحتوي على حرف كبير وحرف صغير ورقم على الأقل.";
    }
  }
  if (type == "address") {
    // تحقق من أن العنوان لا يتجاوز الحد الأقصى
    if (val.length > 255) {
      return "يجب ألا يتجاوز العنوان 255 حرفاً.";
    }
  }
  if (type == "date_of_Birth") {
    // تحقق من أن تاريخ الميلاد هو تاريخ صالح
    DateTime? birthDate = DateTime.tryParse(val);
    if (birthDate == null) {
      return "يجب إدخال تاريخ صحيح.";
    }
    if (birthDate.isAfter(DateTime.now())) {
      return "يجب أن يكون تاريخ الولادة في الماضي أو اليوم.";
    }
  }
  if (type == "role") {
    // تحقق من أن الدور هو أحد القيم المحددة
    if (!["student", "trainer", "employee"].contains(val)) {
      return "يجب أن يكون الدور أحد: trainer أو student أو employee.";
    }
  }
  if (type == "gender") {
    // تحقق من أن الجنس هو أحد القيم المحددة
    if (!["male", "female"].contains(val)) {
      return "يجب أن يكون الجنس أحد: female أو male.";
    }
  }

  return null; // إذا تم اجتياز جميع الفحوصات
}
