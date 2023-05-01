import 'package:flutter/material.dart';
import 'package:social_app/app/core/base/base_project.dart';

class PrivacyModel extends BaseModel<PrivacyModel> {
  int? privacyId;
  String? privacyName;
  String? privacyDescription;
  IconData? privacyIcon;

  PrivacyModel({this.privacyId, this.privacyName, this.privacyDescription, this.privacyIcon});

  @override
  PrivacyModel fromJson(Map<String, dynamic> json) => PrivacyModel(
        privacyId: (json['privacyId'] as num?)?.toInt(),
        privacyName: json['privacyName'],
        privacyDescription: json['privacyDescription'],
        privacyIcon: json['privacyIcon'],
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (privacyId != null) {
      data['privacyId'] = privacyId;
    }
    if (privacyName != null) {
      data['privacyName'] = privacyName;
    }
    if (privacyDescription != null) {
      data['privacyDescription'] = privacyDescription;
    }
    if (privacyIcon != null) {
      data['privacyIcon'] = privacyIcon;
    }
    return data;
  }

  PrivacyModel copyWith({
    int? privacy,
    String? privacyName,
    String? privacyDescription,
    IconData? privacyIcon,
  }) =>
      PrivacyModel(
        privacyId: privacy ?? this.privacyId,
        privacyName: privacyName ?? this.privacyName,
        privacyDescription: privacyDescription ?? this.privacyDescription,
        privacyIcon: privacyIcon ?? this.privacyIcon,
      );

  //get privacy id not index
  factory PrivacyModel.from(int privacy) => listPrivacy.firstWhere((e) => e.privacyId == privacy);

  static List<PrivacyModel> get listPrivacy => [
        PrivacyModel(
          privacyId: 0,
          privacyName: 'Private',
          privacyDescription: 'Only you can see your post',
          privacyIcon: Icons.lock,
        ),
        PrivacyModel(
          privacyId: 1,
          privacyName: 'Public',
          privacyDescription: 'Anyone can see your post',
          privacyIcon: Icons.public,
        ),
        PrivacyModel(
          privacyId: 2,
          privacyName: 'Friend',
          privacyDescription: 'Only your friend can see your post',
          privacyIcon: Icons.people,
        ),
      ];
}
