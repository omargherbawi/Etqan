// create model for these  'user_id': res['user_id'],
//             'email': email,
//             'password': password,
//             'retypePassword': password,

class SignupDataModel {
  final String userId;
  final String? email;
  final String? countryCode;
  final String? phone;
  final String password;
  final String retypePassword;
  final bool newUser;

  SignupDataModel({
    required this.userId,
    this.email,
    this.countryCode,
    this.phone,
    required this.password,
    required this.retypePassword,
    required this.newUser,
  });
}
