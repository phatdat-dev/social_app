import '../../../../core/base/base_project.dart';
import '../../../../custom/other/search_controller_custom.dart';

class OpenAiModelResponse extends BaseModel<OpenAiModelResponse> implements SearchDelegateQueryName {
  String? id;
  String? object;
  int? created;
  String? ownedBy;
  List<Permission>? permission;
  String? root;
  dynamic parent;

  OpenAiModelResponse({this.id, this.object, this.created, this.ownedBy, this.permission, this.root, this.parent});

  @override
  OpenAiModelResponse fromJson(Map<String, dynamic> json) => OpenAiModelResponse(
        id: json['id'],
        object: json['object'],
        created: (json['created'] as num?)?.toInt(),
        ownedBy: json['owned_by'],
        permission: json['permission'] != null ? List<Permission>.from((json['permission'] as List).map((x) => Permission().fromJson(x))) : null,
        root: json['root'],
        parent: json['parent'],
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    (id != null) ? data['id'] = id : null;
    (object != null) ? data['object'] = object : null;
    (created != null) ? data['created'] = created : null;
    (ownedBy != null) ? data['owned_by'] = ownedBy : null;
    (permission != null) ? data['permission'] = permission!.map((v) => v.toJson()).toList() : null;

    (root != null) ? data['root'] = root : null;
    (parent != null) ? data['parent'] = parent : null;
    return data;
  }

  @override
  String get queryName => id ?? '';

  @override
  set queryName(String value) => queryName = value;

  @override
  Object? objectt;

  // @override
  String? description;
}

class Permission extends BaseModel<Permission> {
  String? id;
  String? object;
  int? created;
  bool? allowCreateEngine;
  bool? allowSampling;
  bool? allowLogprobs;
  bool? allowSearchIndices;
  bool? allowView;
  bool? allowFineTuning;
  String? organization;
  dynamic group;
  bool? isBlocking;

  Permission(
      {this.id,
      this.object,
      this.created,
      this.allowCreateEngine,
      this.allowSampling,
      this.allowLogprobs,
      this.allowSearchIndices,
      this.allowView,
      this.allowFineTuning,
      this.organization,
      this.group,
      this.isBlocking});

  @override
  Permission fromJson(Map<String, dynamic> json) => Permission(
        id: json['id'],
        object: json['object'],
        created: (json['created'] as num?)?.toInt(),
        allowCreateEngine: json['allow_create_engine'],
        allowSampling: json['allow_sampling'],
        allowLogprobs: json['allow_logprobs'],
        allowSearchIndices: json['allow_search_indices'],
        allowView: json['allow_view'],
        allowFineTuning: json['allow_fine_tuning'],
        organization: json['organization'],
        group: json['group'],
        isBlocking: json['is_blocking'],
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    (id != null) ? data['id'] = id : null;
    (object != null) ? data['object'] = object : null;
    (created != null) ? data['created'] = created : null;
    (allowCreateEngine != null) ? data['allow_create_engine'] = allowCreateEngine : null;
    (allowSampling != null) ? data['allow_sampling'] = allowSampling : null;
    (allowLogprobs != null) ? data['allow_logprobs'] = allowLogprobs : null;
    (allowSearchIndices != null) ? data['allow_search_indices'] = allowSearchIndices : null;
    (allowView != null) ? data['allow_view'] = allowView : null;
    (allowFineTuning != null) ? data['allow_fine_tuning'] = allowFineTuning : null;
    (organization != null) ? data['organization'] = organization : null;
    (group != null) ? data['group'] = group : null;
    (isBlocking != null) ? data['is_blocking'] = isBlocking : null;
    return data;
  }

  Permission copyWith({
    String? id,
    String? object,
    int? created,
    bool? allowCreateEngine,
    bool? allowSampling,
    bool? allowLogprobs,
    bool? allowSearchIndices,
    bool? allowView,
    bool? allowFineTuning,
    String? organization,
    dynamic group,
    bool? isBlocking,
  }) =>
      Permission(
        id: id ?? this.id,
        object: object ?? this.object,
        created: created ?? this.created,
        allowCreateEngine: allowCreateEngine ?? this.allowCreateEngine,
        allowSampling: allowSampling ?? this.allowSampling,
        allowLogprobs: allowLogprobs ?? this.allowLogprobs,
        allowSearchIndices: allowSearchIndices ?? this.allowSearchIndices,
        allowView: allowView ?? this.allowView,
        allowFineTuning: allowFineTuning ?? this.allowFineTuning,
        organization: organization ?? this.organization,
        group: group ?? this.group,
        isBlocking: isBlocking ?? this.isBlocking,
      );
}
