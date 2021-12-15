// class UserModel {
//   Data? data;
//
//   UserModel({this.data});
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? accessToken;
//   User? user;
//
//   Data({this.accessToken, this.user});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     accessToken = json['access_token'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['access_token'] = this.accessToken;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     return data;
//   }
// }
//
// class User {
//   int? id;
//   int? roleId;
//   String? name;
//   Null? email;
//   String? avatar;
//   String? phoneNumber;
//   int? isVerified;
//   Settings? settings;
//   String? createdAt;
//   String? updatedAt;
//
//   User(
//       {this.id,
//         this.roleId,
//         this.name,
//         this.email,
//         this.avatar,
//         this.phoneNumber,
//         this.isVerified,
//         this.settings,
//         this.createdAt,
//         this.updatedAt});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     roleId = json['role_id'];
//     name = json['name'];
//     email = json['email'];
//     avatar = json['avatar'];
//     phoneNumber = json['phone_number'];
//     isVerified = json['isVerified'];
//     settings = json['settings'] != null
//         ? new Settings.fromJson(json['settings'])
//         : null;
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['role_id'] = this.roleId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['avatar'] = this.avatar;
//     data['phone_number'] = this.phoneNumber;
//     data['isVerified'] = this.isVerified;
//     if (this.settings != null) {
//       data['settings'] = this.settings!.toJson();
//     }
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
//
// class Settings {
//   String ?locale;
//
//   Settings({this.locale});
//
//   Settings.fromJson(Map<String, dynamic> json) {
//     locale = json['locale'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['locale'] = this.locale;
//     return data;
//   }
// }


class UserModel {
  Data? data;

  UserModel({this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? accessToken;
  User? user;

  Data({this.accessToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? roleId;
  String? name;
  String? avatar;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;

  User(
      {this.roleId,
        this.name,
        this.avatar,
        this.phoneNumber,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    name = json['name'];
    avatar = json['avatar'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_id'] = this.roleId;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
