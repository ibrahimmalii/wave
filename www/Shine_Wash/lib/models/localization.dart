class LocalizationsModel {
  Content? content;

  LocalizationsModel({this.content});

  LocalizationsModel.fromJson(Map<String, dynamic> json) {
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}

class Content {
  String? signin;
  String? phoneNumber;
  String? password;
  String? forgetPassword;
  String? newUser;
  String? signup;
  String? userName;
  String? alreadyUser;
  String? welcomeMessage;
  String? category;
  String? specialist;
  String? viewAll;
  String? offers;
  String? home;
  String? map;
  String? appointments;
  String? notification;
  String? privacyPolicies;
  String? faq;
  String? logout;
  String? login;
  String? profile;
  String? changePassword;
  String? currentPassword;
  String? newPassword;
  String? confirm;
  String? save;
  String? verify;
  String? all;
  String? pending;
  String? complete;
  String? cancel;
  String? dataNotFound;
  String? loginError;
  String? notificationMessageError;
  String? appointmentError;
  String? phoneError;
  String? passwordError;
  String? connectionTitleError;
  String? connectionBodyError;
  String? ok;
  String? lengthPassword;
  String? usernameError;
  String? registerError;
  String? verifyError;
  String? verification;
  String? codeError;
  String? resend;
  String? submit;
  String? enterNumber;
  String? mobile;
  String? send;

  Content(
      {this.signin,
      this.phoneNumber,
      this.password,
      this.forgetPassword,
      this.newUser,
      this.signup,
      this.userName,
      this.alreadyUser,
      this.welcomeMessage,
      this.category,
      this.specialist,
      this.viewAll,
      this.offers,
      this.home,
      this.map,
      this.appointments,
      this.notification,
      this.privacyPolicies,
      this.faq,
      this.logout,
      this.login,
      this.profile,
      this.changePassword,
      this.currentPassword,
      this.newPassword,
      this.confirm,
      this.save,
      this.verify,
      this.all,
      this.pending,
      this.complete,
      this.cancel,
      this.dataNotFound,
      this.loginError,
      this.notificationMessageError,
      this.appointmentError,
      this.phoneError,
      this.passwordError,
      this.connectionTitleError,
      this.connectionBodyError,
      this.ok,
      this.lengthPassword,
      this.usernameError,
      this.registerError,
      this.verifyError,
      this.verification,
      this.codeError,
      this.resend,
      this.submit,
      this.enterNumber,
      this.mobile,
      this.send});

  Content.fromJson(Map<String, dynamic> json) {
    signin = json['signin'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    forgetPassword = json['forget_password'];
    newUser = json['new_user'];
    signup = json['signup'];
    userName = json['user_name'];
    alreadyUser = json['already_user'];
    welcomeMessage = json['welcome_message'];
    category = json['category'];
    specialist = json['specialist'];
    viewAll = json['view_all'];
    offers = json['offers'];
    home = json['home'];
    map = json['map'];
    appointments = json['appointments'];
    notification = json['notification'];
    privacyPolicies = json['privacy_policies'];
    faq = json['faq'];
    logout = json['logout'];
    login = json['login'];
    profile = json['profile'];
    changePassword = json['change_password'];
    currentPassword = json['current_password'];
    newPassword = json['new_password'];
    confirm = json['confirm'];
    save = json['save'];
    verify = json['verify'];
    all = json['all'];
    pending = json['pending'];
    complete = json['complete'];
    cancel = json['cancel'];
    dataNotFound = json['data_not_found'];
    loginError = json['login_error'];
    notificationMessageError = json['notification_message_error'];
    appointmentError = json['appointment_error'];
    phoneError = json['phone_error'];
    passwordError = json['password_error'];
    connectionTitleError = json['connection_title_error'];
    connectionBodyError = json['connection_body_error'];
    ok = json['ok'];
    lengthPassword = json['length_password'];
    usernameError = json['username_error'];
    registerError = json['register_error'];
    verifyError = json['verify_error'];
    verification = json['verification'];
    codeError = json['code_error'];
    resend = json['resend'];
    submit = json['submit'];
    enterNumber = json['enter_number'];
    mobile = json['mobile'];
    send = json['send'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['signin'] = this.signin;
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    data['forget_password'] = this.forgetPassword;
    data['new_user'] = this.newUser;
    data['signup'] = this.signup;
    data['user_name'] = this.userName;
    data['already_user'] = this.alreadyUser;
    data['welcome_message'] = this.welcomeMessage;
    data['category'] = this.category;
    data['specialist'] = this.specialist;
    data['view_all'] = this.viewAll;
    data['offers'] = this.offers;
    data['home'] = this.home;
    data['map'] = this.map;
    data['appointments'] = this.appointments;
    data['notification'] = this.notification;
    data['privacy_policies'] = this.privacyPolicies;
    data['faq'] = this.faq;
    data['logout'] = this.logout;
    data['login'] = this.login;
    data['profile'] = this.profile;
    data['change_password'] = this.changePassword;
    data['current_password'] = this.currentPassword;
    data['new_password'] = this.newPassword;
    data['confirm'] = this.confirm;
    data['save'] = this.save;
    data['verify'] = this.verify;
    data['all'] = this.all;
    data['pending'] = this.pending;
    data['complete'] = this.complete;
    data['cancel'] = this.cancel;
    data['data_not_found'] = this.dataNotFound;
    data['login_error'] = this.loginError;
    data['notification_message_error'] = this.notificationMessageError;
    data['appointment_error'] = this.appointmentError;
    data['phone_error'] = this.phoneError;
    data['password_error'] = this.passwordError;
    data['connection_title_error'] = this.connectionTitleError;
    data['connection_body_error'] = this.connectionBodyError;
    data['ok'] = this.ok;
    data['length_password'] = this.lengthPassword;
    data['username_error'] = this.usernameError;
    data['register_error'] = this.registerError;
    data['verify_error'] = this.verifyError;
    data['verification'] = this.verification;
    data['code_error'] = this.codeError;
    data['resend'] = this.resend;
    data['submit'] = this.submit;
    data['enter_number'] = this.enterNumber;
    data['mobile'] = this.mobile;
    data['send'] = this.send;
    return data;
  }
}
