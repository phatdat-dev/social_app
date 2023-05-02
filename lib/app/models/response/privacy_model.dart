import 'package:flutter/material.dart';
import 'package:social_app/app/core/base/base_project.dart';

class PrivacyModel extends BaseModel<PrivacyModel> {
  int? privacyId;
  String? privacyPostName;
  String? privacyPostDescription;
  String? privacyGroupName;
  String? privacyGroupDescription;
  IconData? privacyIcon;

  PrivacyModel({
    this.privacyId,
    this.privacyPostName,
    this.privacyPostDescription,
    this.privacyGroupName,
    this.privacyGroupDescription,
    this.privacyIcon,
  });

  @override
  PrivacyModel fromJson(Map<String, dynamic> json) => PrivacyModel(
        privacyId: (json['privacyId'] as num?)?.toInt(),
        privacyPostName: json['privacyPostName'],
        privacyPostDescription: json['privacyPostDescription'],
        privacyGroupName: json['privacyGroupName'],
        privacyGroupDescription: json['privacyGroupDescription'],
        privacyIcon: json['privacyIcon'],
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (privacyId != null) {
      data['privacyId'] = privacyId;
    }
    if (privacyPostName != null) {
      data['privacyPostName'] = privacyPostName;
    }
    if (privacyPostDescription != null) {
      data['privacyPostDescription'] = privacyPostDescription;
    }
    if (privacyPostName != null) {
      data['privacyGroupName'] = privacyGroupName;
    }
    if (privacyGroupDescription != null) {
      data['privacyGroupDescription'] = privacyGroupDescription;
    }
    if (privacyIcon != null) {
      data['privacyIcon'] = privacyIcon;
    }
    return data;
  }

  PrivacyModel copyWith({
    int? privacy,
    String? privacyPostName,
    String? privacyPostDescription,
    String? privacyGroupName,
    String? privacyGroupDescription,
    IconData? privacyIcon,
  }) =>
      PrivacyModel(
        privacyId: privacy ?? this.privacyId,
        privacyPostName: privacyPostName ?? this.privacyPostName,
        privacyPostDescription: privacyPostDescription ?? this.privacyPostDescription,
        privacyGroupName: privacyGroupName ?? this.privacyGroupName,
        privacyGroupDescription: privacyGroupDescription ?? this.privacyGroupDescription,
        privacyIcon: privacyIcon ?? this.privacyIcon,
      );

  //get privacy id not index
  factory PrivacyModel.from(int privacy) => listPrivacy.firstWhere((e) => e.privacyId == privacy);

  static List<PrivacyModel> get listPrivacy => [
        PrivacyModel(
          privacyId: 0,
          privacyPostName: 'Private',
          privacyPostDescription: 'Only you can see your post',
          privacyGroupName: 'Private Group',
          privacyGroupDescription: 'Only members can see everyone in the group and what they post.',
          privacyIcon: Icons.lock,
        ),
        PrivacyModel(
          privacyId: 1,
          privacyPostName: 'Public',
          privacyPostDescription: 'Anyone can see your post',
          privacyGroupName: 'Public Group',
          privacyGroupDescription: 'Anyone can see everyone in the group and what they post.',
          privacyIcon: Icons.public,
        ),
        PrivacyModel(
          privacyId: 2,
          privacyPostName: 'Friend',
          privacyPostDescription: 'Only your friend can see your post',
          privacyGroupName: 'Friend Group',
          privacyGroupDescription: 'Only members can see everyone in the group and what they post.',
          privacyIcon: Icons.people,
        ),
      ];
}
