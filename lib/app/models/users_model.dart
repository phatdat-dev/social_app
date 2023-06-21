import '../core/base/base_model.dart';

class UsersModel extends BaseModel<UsersModel> with BaseSelectedModel {
  int? id;
  String? displayName;
  String? email;
  String? avatar;
  String? coverImage;
  DateTime? dateOfBirth;
  int? sex;
  String? wentTo;
  String? liveIn;
  int? relationship;
  dynamic phone;
  String? address;
  String? token;
  String? password;
  String? status;

  UsersModel({
    this.id,
    this.displayName,
    this.email,
    this.avatar,
    this.coverImage,
    this.dateOfBirth,
    this.sex,
    this.wentTo,
    this.liveIn,
    this.relationship,
    this.phone,
    this.address,
    this.token,
    this.password,
    this.status,
  });

  @override
  UsersModel fromJson(Map<String, dynamic> json) {
    final String? token = json['access_token'];
    if (json['user'] != null) json = json['user'];
    return UsersModel(
      id: (json['id'] as num?)?.toInt(),
      displayName: json['displayName'],
      email: json['email'],
      avatar: json['avatar'],
      coverImage: json['coverImage'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.tryParse(json['date_of_birth']) : null,
      sex: (json['sex'] as num?)?.toInt(),
      wentTo: json['went_to'],
      liveIn: json['live_in'],
      relationship: (json['relationship'] as num?)?.toInt(),
      phone: json['phone'],
      address: json['address'],
      token: token ?? json['token'],
      password: json['password'],
      status: json['status'].toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (displayName != null) {
      data['displayName'] = displayName;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (avatar != null) {
      data['avatar'] = avatar;
    }
    if (coverImage != null) {
      data['cover_image'] = coverImage;
      data['coverImage'] = coverImage;
    }
    if (dateOfBirth != null) {
      data['date_of_birth'] = dateOfBirth?.toIso8601String();
    }
    if (sex != null) {
      data['sex'] = sex;
    }
    if (wentTo != null) {
      data['went_to'] = wentTo;
    }
    if (liveIn != null) {
      data['live_in'] = liveIn;
    }
    if (relationship != null) {
      data['relationship'] = relationship;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    if (address != null) {
      data['address'] = address;
    }
    if (token != null) {
      data['token'] = token;
    }
    if (password != null) {
      data['password'] = password;
    }
    if (status != null) {
      data['status'] = status;
    }
    return data;
  }

  UsersModel copyWith({
    int? id,
    String? displayName,
    String? email,
    String? avatar,
    String? coverImage,
    DateTime? dateOfBirth,
    int? sex,
    String? wentTo,
    String? liveIn,
    int? relationship,
    dynamic phone,
    String? address,
    String? token,
    String? password,
    String? status,
  }) =>
      UsersModel(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        coverImage: coverImage ?? this.coverImage,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        sex: sex ?? this.sex,
        wentTo: wentTo ?? this.wentTo,
        liveIn: liveIn ?? this.liveIn,
        relationship: relationship ?? this.relationship,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        token: token ?? this.token,
        password: password ?? this.password,
        status: status ?? this.status,
      );
}
