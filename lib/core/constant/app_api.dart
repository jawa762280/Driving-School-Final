class AppLinks {
  static const String init = 'http://192.168.1.105:8000/api';
  // static const String init = 'http://127.0.0.1:8000/api';
  static const String login = '$init/login';
  static const String signUp = '$init/student/register';
  static const String verifyCodeSignUp = '$init/email/verify';
  static const String resendVerifyCodeSignUp = '$init/resend-email-code';
  static const String resetPassword = '$init/reset-password';
  static const String verifyCode = '$init/verify-reset-code';
  static const String forgetPassword = '$init/send-reset-code';
  static const String resendVerifyCode = '$init/resend-reset-code';
  static const String searchTrainers = '$init/trainersApprove';
    static const String updateInformation = '$init/students';


}
