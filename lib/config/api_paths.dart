class ApiPaths {
  //baseUrl
  static String baseUrl = "https://etqan.com/api/";
  // static String baseUrl = "http://192.168.1.21:8000/api/";

  //endpoints
  static String addForum(int id) => 'development/panel/webinars/$id/forums';
  static String fetchCourseForum(int id) =>
      'development/panel/webinars/$id/forums';
  static String updateForum(int id) => 'development/panel/webinars/forums/$id';
  static String fetchAnswer(int id) =>
      'development/panel/webinars/forums/$id/answers';
  static String editAnswer(int id) =>
      'development/panel/webinars/forums/answers/$id';
  static String addAnswer(int id) =>
      'development/panel/webinars/forums/$id/answers';

  //************** auth
  static const String signup = 'development/register';
  static const String phoneStudentRegister = 'development/register/step/1';
  static const String login = 'v2/development/login';
  static const String doesEmailExist = 'development/email-existance';
  static const String preSignupData = 'development/pre-signup-data';

  static const String googleLogin = 'development/google/callback';
  static const String facebookLogin = 'development/facebook/callback';
  static const String forgetPassword = 'development/forget-password';
  static const String verifyCode = 'development/register/step/2';
  static const String registerStep3 = 'development/register/step/3';
  static const String validateUser = 'development/validate-user';

  //  **************   events
  static const String fetchPrivacyPolicy = 'development/policy';
  static const String fetchTermsOfUse = 'development/terms';

  //
  //
  // **************    Categories

  static const String fetchCities = 'development/cities';
  static const String fetchCategories = 'development/categories';
  static const String trendCategories = 'development/trend-categories';

  static String categoryWebinarsById(int id) =>
      'development/categories/$id/webinars';

  // **************   user
  static const String fetchUserData = 'development/account';
  static const String updateAccount = 'development/update-account';
  static const String resetPassword = 'development/reset-password';

  //  **************   Miscellaneous
  static const String fetchTrendyQuizTypes = 'development/trendy-quiz-types';

  //
  //
  //  **************   CourseService API Paths

  static const String singleCourseData = 'development/{path}/{id}';
  static const String webinarsNotices =
      'development/panel/webinars/{id}/noticeboards';

  static String courses = 'v2/development/courses';
  static const String bundles = 'development/bundles';
  static const String pakages = 'development/pakages';

  static String fetchcoursequiz(int id) => 'development/panel/quizzes/$id';

  static String startQuiz(int id) => 'development/panel/quizzes/$id/start';
  static String quizResult(int id) => 'development/panel/quizzes/$id/result';

  static const String featuredCourses = 'development/featured-courses';
  static const String courseReportsReasons =
      'development/courses/reports/reasons';
  static String fetchSavedCourses = 'development/panel/favorites';

  static String singleCourseDataById(String path, int id) =>
      'development/$path/$id';

  static String bundleWebinarsById(int bundleId) =>
      'development/bundles/$bundleId/webinars';

  static String webinarsNoticesById(int id) =>
      'development/panel/webinars/$id/noticeboards';

  //
  //
  // **************    GuestService API Paths
  static const String currencyList = 'development/currency/list';
  static const String timezones = 'development/timezones';
  static const String config = 'development/config';

  static String getRegisterConfigByRole(String role) =>
      'development/config/register/$role';

  //
  //
  //  **************   Location service

  static const String regionCountries = 'development/regions/countries';

  static String getProvincesByCountryId(int countryId) =>
      'development/regions/provinces/$countryId';

  static String getCitiesByProvinceId(int provinceId) =>
      'development/regions/cities/$provinceId';

  static String getDistrictsByCityId(int cityId) =>
      'development/regions/districts/$cityId';

  //
  //
  //
  //  **************   ProvidersService
  static const String _instructors = 'development/providers/instructors';

  static String getInstructorsUrl({
    bool discount = false,
    bool downloadable = false,
    bool freeMeetings = false,
    bool availableForMeetings = false,
    String? sort,
    List<int>? categoryIds,
  }) {
    String url = '$_instructors?p=';
    if (discount) url += '&discount=1';
    if (downloadable) url += '&downloadable=1';
    if (freeMeetings) url += '&free_meetings=1';
    if (availableForMeetings) url += '&available_for_meetings=1';
    if (sort != null) url += '&sort=$sort';
    if (categoryIds != null) {
      for (final id in categoryIds) {
        url += '&categories[]=$id';
      }
    }
    return url;
  }

  static const String _organizations = 'development/providers/organizations';

  static String getOrganizationsUrl({
    bool discount = false,
    bool downloadable = false,
    bool freeMeetings = false,
    bool availableForMeetings = false,
    String? sort,
    List<int>? categoryIds,
  }) {
    String url = '$_organizations?p=';
    if (discount) url += '&discount=1';
    if (downloadable) url += '&downloadable=1';
    if (freeMeetings) url += '&free_meetings=1';
    if (availableForMeetings) url += '&available_for_meetings=1';
    if (sort != null) url += '&sort=$sort';
    if (categoryIds != null) {
      for (final id in categoryIds) {
        url += '&categories[]=$id';
      }
    }
    return url;
  }

  static const String _consultations = 'development/providers/consultations';

  static String getConsultationsUrl({
    bool discount = false,
    bool downloadable = false,
    bool freeMeetings = false,
    bool availableForMeetings = false,
    String? sort,
    List<int>? categoryIds,
  }) {
    String url = '$_consultations?p=';
    if (discount) url += '&discount=1';
    if (downloadable) url += '&downloadable=1';
    if (freeMeetings) url += '&free_meetings=1';
    if (availableForMeetings) url += '&available_for_meetings=1';
    if (sort != null) url += '&sort=$sort';
    if (categoryIds != null) {
      for (final id in categoryIds) {
        url += '&categories[]=$id';
      }
    }
    return url;
  }

  static String getUserProfileUrl(int userId) =>
      'development/users/$userId/profile';

  static String followUserUrl(int userId) =>
      'development/panel/users/$userId/follow';

  static String getUserMeetingsUrl(int userId, int date) =>
      'development/users/$userId/meetings?date=$date';
  static const String reserveMeeting = 'development/meetings/reserve';

  static String sendMessageUrl(int userId) =>
      'development/users/$userId/send-message';

  //
  //
  //
  //  **************   HyperPay
  static const String generateCheckoutId =
      'development/panel/payments/generate-checkout-id';
  static const String getPaymentStatus = 'https://jiff.jo/api/client/check_out';

  //
  //
  //
  //  **************   PaymentServiceProvider

  // ***********************************
  //
  //                    User service
  //
  //  **************   BlogService
  static const String blogs = 'development/blogs';

  /// For fetching blogs with offset and optional category
  static String getBlogs({required int offset, int limit = 10, int? category}) {
    String path = '$blogs?offset=$offset&limit=$limit';
    if (category != null) {
      path += '&cat=$category';
    }
    return path;
  }

  static const String saveComment = 'development/panel/comments';

  static const String blogCategories = 'development/blogs/categories';

  //
  //
  //
  //  **************   CartService

  static const String cartList = 'development/panel/cart/list';

  static const String validateCoupon = 'development/panel/cart/coupon/validate';

  static const String storeCart = 'development/panel/cart/store';

  static const String paymentRequest = 'development/panel/payments/request';

  static const String creditPayment = 'development/panel/payments/credit';

  static const String purchaseCourseViaPayment =
      'development/panel/payments/purchase-course';

  static const String subscribeApply = 'development/panel/subscribe/apply';

  static const String cartItem = 'development/panel/cart';

  static const String _deleteCourse = 'development/panel/cart/{id}';

  static String deleteCourse(int id) =>
      _deleteCourse.replaceFirst('{id}', id.toString());

  static const String cartCheckout = 'development/panel/cart/checkout';

  //
  //
  //
  //  **************   CertificateService
  static const String achievementsCertificates =
      'development/panel/certificates/achievements';
  static const String completionCertificates =
      'development/panel/webinars/certificates';
  static const String classCertificates =
      'development/panel/certificates/created';

  //
  //
  //
  //  **************   CommentsService
  static const String allComments = 'development/panel/comments';

  static String instructorReply(int id) =>
      'development/panel/comments/$id/reply';

  static String reportComment(int id) =>
      'development/panel/comments/$id/report';

  static String updateComment(int id) => 'development/panel/comments/$id';

  static String deleteComment(int id) => 'development/panel/comments/$id';

  //
  //
  //
  //  **************   Financial
  static String getBankAccounts =
      'development/panel/financial/platform-bank-accounts';

  static String getOfflinePayments =
      'development/panel/financial/offline-payments';

  static String storeOfflinePayments =
      'development/panel/financial/offline-payments';

  static String getSummaryData = 'development/panel/financial/summary';

  static String webLinkCharge = 'development/panel/financial/web_charge';

  static String getPayoutData = 'development/panel/financial/payout';

  static String getSalesData = 'development/panel/financial/sales';

  static String requestPayout = 'development/panel/financial/payout';

  //
  //
  //
  //  **************   Forum
  static String getForumData(int id, String search) {
    String url = 'development/panel/webinars/$id/forums';
    if (search.isNotEmpty) {
      url += '?search=$search';
    }
    return url;
  }

  static String pinForum(int id) => 'development/panel/webinars/forums/$id/pin';

  static String answerPin(int id) =>
      'development/panel/webinars/forums/answers/$id/pin';

  static String answerResolve(int id) =>
      'development/panel/webinars/forums/answers/$id/resolve';

  static String setAnswer(int id) =>
      'development/panel/webinars/forums/$id/answers';

  static String updateAnswer(int id) =>
      'development/panel/webinars/forums/answers/$id';

  static String getAnswers(int id) =>
      'development/panel/webinars/forums/$id/answers';

  static String newQuestion(int id) => 'development/panel/webinars/$id/forums';

  //
  //
  //
  //  **************   MeetingService

  static String getMeetings = 'development/panel/meetings';

  static String getMeetingDetails(int id) => 'development/panel/meetings/$id';

  static String createMeetingLink =
      'development/instructor/meetings/create-link';

  static String addSession(int id) =>
      'development/instructor/meetings/$id/add-session';

  static String finishMeeting(int id, bool isConsultant) =>
      isConsultant
          ? 'development/instructor/meetings/$id/finish'
          : 'development/panel/meetings/$id/finish';

  //
  //
  //
  //  **************   PersonalNoteService

  static String createNote(int courseId) =>
      'development/panel/webinars/personal-notes/$courseId';

  static String getNoteDetails(int id) =>
      'development/panel/webinars/personal-notes/$id';

  static String deleteNote(int id) =>
      'development/panel/webinars/personal-notes/delete/$id';

  //
  //
  //
  //  **************   PurchaseService
  static String bundlesFree(int courseId) =>
      'development/panel/bundles/$courseId/free';

  static String courseFree(int courseId) =>
      'development/panel/webinars/$courseId/free';

  static String addToCart = 'development/panel/bundles/add-to-cart';

  //
  //
  //
  //  **************   PersonalNoteService

  static String createPersonalNote(int courseId) =>
      'development/panel/webinars/personal-notes/$courseId';

  static String getPersonalNote(int id) =>
      'development/panel/webinars/personal-notes/$id';

  static String deletePersonalNote(int id) =>
      'development/panel/webinars/personal-notes/delete/$id';

  //
  //
  //
  //  **************   QuizService

  static String getQuizzesList = 'development/instructor/quizzes/list';

  static String getMyQuizResults =
      'development/panel/quizzes/results/my-results';

  static String getStudentQuizResults =
      'development/panel/quizzes/results/my-student-result';

  static String getNotParticipatedQuizzes =
      'development/panel/quizzes/not_participated';

  static String reviewQuiz(int quizId, String tab) =>
      tab == 'StudentResults'
          ? 'development/panel/quizzes/results/$quizId'
          : 'development/panel/quizzes/$quizId/result';

  static String storeQuizResult(int quizId) =>
      'development/panel/quizzes/$quizId/store-result';

  static String reviewQuizResult(int quizResultId) =>
      'development/panel/quizzes/results/$quizResultId/review';

  //
  //
  //
  //  **************   Rewards Service

  static String getRewards = 'development/panel/rewards';

  static String buyWithPoint(int id) =>
      'development/panel/rewards/webinar/$id/apply';

  //
  //
  //
  //  **************    Subscription Service

  //
  static String getSubscription = 'development/panel/subscribe';
  static String getSubscriptionLink = 'development/panel/subscribe/web_pay';
  static String getSaasPackages = 'development/panel/registration-packages';
  static String getSaasPackageLink =
      'development/panel/registration-packages/pay';

  //
  //
  //
  //  **************    Support Service

  static String getMyClassSupport =
      'development/panel/support/my_class_support';
  static String getClassSupport = 'development/panel/support/class_support';
  static String getTickets = 'development/panel/support/tickets';
  static String getDepartments = 'development/panel/support/departments';

  static String getOneSupport(int id) => 'development/panel/support/$id';
  static String createMessage = 'development/panel/support';

  static String sendMessage(int chatId) =>
      'development/panel/support/$chatId/conversations';

  //
  //
  //
  //  **************    UserService

  static String userPath(String endpoint, {int? userId}) =>
      userId != null
          ? 'development/panel/users/$userId/$endpoint'
          : 'development/panel/$endpoint';

  static String notifications({int? notificationId}) =>
      notificationId != null
          ? 'development/panel/notifications/$notificationId'
          : 'development/panel/notifications';

  static String favorites({int? favoriteId}) =>
      favoriteId != null
          ? 'development/panel/favorites/$favoriteId'
          : 'development/panel/favorites';

  static String supportConversations(int chatId) =>
      'development/panel/support/$chatId/conversations';

  static String webinarsPurchases = 'v3/development/panel/webinars/purchases';
  static String fetchCourses = 'v2/development/courses';

  static String webinarsOrganization() =>
      'development/panel/webinars/organization';

  static String profile = 'v3/development/panel/profile-setting';

  static String reviews() => 'development/panel/reviews';

  static String quickInfo() => 'development/panel/quick-info';

  static String rewards() => 'development/panel/rewards';

  static String loginHistory() => 'development/panel/users/login/history';

  static String classes() => 'development/panel/classes';

  static String updatePassword = 'development/panel/profile-setting/password';
  static String updateImage = 'development/panel/profile-setting/images';

  static String sendFirebaseToken = 'development/panel/users/fcm';

  static String logout = 'development/logout';

  // **************    Home
  static String pointsOfSale = 'v3/development/point-of-sale';
  static String fetchCountries = 'development/regions/countries';

  static String fetchProvincesByCountryId(id) =>
      'development/regions/provinces/$id';

  static String fetchInstructors = 'v2/development/instructors';

  static String fetchIsReviewing = 'development/is-in-review';
  static String fetchFilesCourse = 'v2/development/courses/course-files';
}
