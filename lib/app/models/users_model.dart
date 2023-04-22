import '../core/base/base_model.dart';

class UsersModel extends BaseModel<UsersModel> {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  dynamic coverImage;
  DateTime? dateOfBirth;
  int? sex;
  String? wentTo;
  String? liveIn;
  int? relationship;
  dynamic phone;
  String? address;
  String? token;
  String? password;

  UsersModel({
    this.id,
    this.firstName,
    this.lastName,
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
  });

  @override
  UsersModel fromJson(Map<String, dynamic> json) {
    final String token = json["access_token"];
    json = json["user"];
    return UsersModel(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      avatar: json['avatar'],
      coverImage: json['cover_image'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.tryParse(json['date_of_birth']) : null,
      sex: (json['sex'] as num?)?.toInt(),
      wentTo: json['went_to'],
      liveIn: json['live_in'],
      relationship: (json['relationship'] as num?)?.toInt(),
      phone: json['phone'],
      address: json['address'],
      token: token,
      password: json['password'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (firstName != null) {
      data['first_name'] = firstName;
    }
    if (lastName != null) {
      data['last_name'] = lastName;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (avatar != null) {
      data['avatar'] = avatar;
    }
    if (coverImage != null) {
      data['cover_image'] = coverImage;
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
    return data;
  }

  UsersModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
    dynamic coverImage,
    DateTime? dateOfBirth,
    int? sex,
    String? wentTo,
    String? liveIn,
    int? relationship,
    dynamic phone,
    String? address,
    String? token,
    String? password,
  }) =>
      UsersModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
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
      );
}
