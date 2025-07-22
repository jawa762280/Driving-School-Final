class AppLinks {
  static const String init = 'http://192.168.1.107:8000/api';
  // static const String init = 'http://127.0.0.1:8000/api';
  // static const String init = 'http://192.168.194.83:8000/api';

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
  static const String trainerSessionsBySchedule =
      "$init/trainer-sessions/schedule";

  static const String trainerVacation = '$init/schedule-exceptions';
  static const String showVacations = '$init/trainer-exceptions';
  static const String trainers = '$init/trainers';
  static const String booking = '$init/bookings';
  static const String bookingSessionsTrainer = '$init/trainer/bookings';
  static const String bookingSessionsStudent = '$init/student/bookings';
  static const String cancelSession = '$init/bookings';
  static const String startSession = '$init/booking';
  static const String completeSession = '$init/bookings';
  static const String feedbackStudent = '$init/feedback/student';
  static const String trainerReviews = '$init/trainer-reviews';
  static const String createExam = '$init/exams';
  static const String showExamByType = "$init/exam/type";
  static const String trainerFeedbacks = "$init/trainer/feedbacks";
  static const String studentFeedbacks = "$init/feedback-students";
  static const String showTrainerExam = "$init/exam";
  static const String generateExam = "$init/generate";
  static const String startExam = "$init/exams/start";
  static const String submitExam = "$init/exams/submit";
  static const String recommendedSessions = "$init/recommended-sessions";
  static const String autobooksession = "$init/auto-book-session";
  static const String addFault = "$init/add";
  static const String carFaults = "$init/car-faults";
  static const String evaluationStuent = "$init/student/evaluation";
  static const String generateCertificate = "$init/certificate/generate";
  static const String licenses = "$init/licenses";
  static const String licenseRequest = "$init/license-request";
  static const String licenseRequestsMy = "$init/license-requests/my";
  static const String showPosts = "$init/posts";
  static const String likePost = "$init/posts";
  static const String downloadUrl = "$init/certificate/download";
  static const String practicalExamMy = "$init/practical-exams/my";
  static const String notifications = "$init/notifications";
  static const String sendMessages = "$init/chat/send";
  static const String chatMessages = "$init/chat/messages";
  static const String chatConversations = "$init/chat/conversations";
  static const String markMessageRead = "$init/messages/read";
  static const unreadCount = '$init/unread-count';
  static const unreadCountByConversation =
      '$init/unread-count-by-conversation';
        static const defineRoute = '$init/bookings';

}
