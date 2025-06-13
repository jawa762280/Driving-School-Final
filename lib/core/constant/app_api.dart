class AppLinks {
  static const String init = 'http://192.168.1.107:8000/api';
  // static const String init = 'http://127.0.0.1:8000/api';
  // static const String init = 'http://192.168.80.83:8000/api';

  static const String login = '$init/login';
  static const String signUpStudent = '$init/student/register';
  static const String signUpTrainer = '$init/trainer/register';

  static const String verifyCodeSignUp = '$init/email/verify';
  static const String resendVerifyCodeSignUp = '$init/resend-email-code';
  static const String resetPassword = '$init/reset-password';
  static const String verifyCode = '$init/verify-reset-code';
  static const String forgetPassword = '$init/send-reset-code';
  static const String resendVerifyCode = '$init/resend-reset-code';
  static const String searchTrainers = '$init/trainersApprove';
  static const String updateInformation = '$init/students';
  static const String deleteAccount = '$init/students';
  static const String refreshToken = '$init/refresh';
  static const String cars = '$init/cars';
  static const String logout = '$init/logout';
  static const String createSchedule = '$init/training-schedules';
  static const String showTRainingSchedules = '$init/trainer';
  static const String trainingSessions = '$init/trainer-sessions';
  static const String trainerVacation = '$init/schedule-exceptions';
  static const String showVacations = '$init/trainer-exceptions';
  static const String trainers = '$init/trainers';
  static const String booking = '$init/bookings';
  static const String bookingSessionsTrainer = '$init/trainer/bookings';
  static const String bookingSessionsStudent = '$init/student/bookings';
  static const String cancelSession = '$init/bookings';
  static const String startSession = '$init/booking';
  static const String completeSession = '$init/bookings';
}
