import '../../core/base/base_model.dart';

class PostResponseModel extends BaseModel<PostResponseModel> {
  int? id;
  String? postContent;
  int? userId;
  int? privacy;
  int? parentPost;
  int? groupId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? status;
  String? displayName;
  String? avatarUser;
  int? totalMediaFile;
  int? totalComment;
  int? totalLike;
  int? totalShare;
  bool? isLike;
  List<Mediafile>? mediafile;
  List<Like>? like;

  PostResponseModel(
      {this.id,
      this.postContent,
      this.userId,
      this.privacy,
      this.parentPost,
      this.groupId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.status,
      this.displayName,
      this.avatarUser,
      this.totalMediaFile,
      this.totalComment,
      this.totalLike,
      this.totalShare,
      this.isLike,
      this.mediafile,
      this.like});

  @override
  PostResponseModel fromJson(Map<String, dynamic> json) => PostResponseModel(
        id: (json['id'] as num?)?.toInt(),
        postContent: json['post_content'],
        userId: (json['user_id'] as num?)?.toInt(),
        privacy: (json['privacy'] as num?)?.toInt(),
        parentPost: (json['parent_post'] as num?)?.toInt(),
        groupId: (json['group_id'] as num?)?.toInt(),
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at'],
        status: (json['status'] as num?)?.toInt(),
        displayName: json['displayName'],
        avatarUser: json['avatarUser'],
        totalMediaFile: (json['totalMediaFile'] as num?)?.toInt(),
        totalComment: (json['totalComment'] as num?)?.toInt(),
        totalLike: (json['totalLike'] as num?)?.toInt(),
        totalShare: (json['totalShare'] as num?)?.toInt(),
        isLike: json['isLike'],
        mediafile: json['mediafile'] != null ? List<Mediafile>.from((json['mediafile'] as List).map((x) => Mediafile().fromJson(x))) : null,
        like: json['like'] != null ? List<Like>.from((json['like'] as List).map((x) => Like().fromJson(x))) : null,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (postContent != null) {
      data['post_content'] = postContent;
    }
    if (userId != null) {
      data['user_id'] = userId;
    }
    if (privacy != null) {
      data['privacy'] = privacy;
    }
    if (parentPost != null) {
      data['parent_post'] = parentPost;
    }
    if (groupId != null) {
      data['group_id'] = groupId;
    }
    if (createdAt != null) {
      data['created_at'] = createdAt;
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt;
    }
    if (deletedAt != null) {
      data['deleted_at'] = deletedAt;
    }
    if (status != null) {
      data['status'] = status;
    }
    if (displayName != null) {
      data['displayName'] = displayName;
    }
    if (avatarUser != null) {
      data['avatarUser'] = avatarUser;
    }
    if (totalMediaFile != null) {
      data['totalMediaFile'] = totalMediaFile;
    }
    if (totalComment != null) {
      data['totalComment'] = totalComment;
    }
    if (totalLike != null) {
      data['totalLike'] = totalLike;
    }
    if (totalShare != null) {
      data['totalShare'] = totalShare;
    }
    if (isLike != null) {
      data['isLike'] = isLike;
    }
    if (mediafile != null) {
      data['mediafile'] = mediafile!.map((v) => v.toJson()).toList();
    }
    if (like != null) {
      data['like'] = like!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  PostResponseModel copyWith({
    int? id,
    String? postContent,
    int? userId,
    int? privacy,
    int? parentPost,
    int? groupId,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    int? status,
    String? displayName,
    String? avatarUser,
    int? totalMediaFile,
    int? totalComment,
    int? totalLike,
    int? totalShare,
    bool? isLike,
    List<Mediafile>? mediafile,
    List<Like>? like,
  }) =>
      PostResponseModel(
        id: id ?? this.id,
        postContent: postContent ?? this.postContent,
        userId: userId ?? this.userId,
        privacy: privacy ?? this.privacy,
        parentPost: parentPost ?? this.parentPost,
        groupId: groupId ?? this.groupId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        status: status ?? this.status,
        displayName: displayName ?? this.displayName,
        avatarUser: avatarUser ?? this.avatarUser,
        totalMediaFile: totalMediaFile ?? this.totalMediaFile,
        totalComment: totalComment ?? this.totalComment,
        totalLike: totalLike ?? this.totalLike,
        totalShare: totalShare ?? this.totalShare,
        isLike: isLike ?? this.isLike,
        mediafile: mediafile ?? this.mediafile,
        like: like ?? this.like,
      );
}

class Mediafile extends BaseModel<Mediafile> {
  int? id;
  String? mediaFileName;
  String? mediaType;
  int? postId;
  int? userId;
  bool? isAvatar;
  bool? isCover;
  int? albumId;
  int? status;
  DateTime? createdAt;
  String? updatedAt;

  Mediafile(
      {this.id,
      this.mediaFileName,
      this.mediaType,
      this.postId,
      this.userId,
      this.isAvatar,
      this.isCover,
      this.albumId,
      this.status,
      this.createdAt,
      this.updatedAt});

  @override
  Mediafile fromJson(Map<String, dynamic> json) => Mediafile(
        id: (json['id'] as num?)?.toInt(),
        mediaFileName: json['media_file_name'],
        mediaType: json['media_type'],
        postId: (json['post_id'] as num?)?.toInt(),
        userId: (json['user_id'] as num?)?.toInt(),
        isAvatar: json['isAvatar'],
        isCover: json['isCover'],
        albumId: (json['album_id'] as num?)?.toInt(),
        status: (json['status'] as num?)?.toInt(),
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
        updatedAt: json['updated_at'],
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (mediaFileName != null) {
      data['media_file_name'] = mediaFileName;
    }
    if (mediaType != null) {
      data['media_type'] = mediaType;
    }
    if (postId != null) {
      data['post_id'] = postId;
    }
    if (userId != null) {
      data['user_id'] = userId;
    }
    if (isAvatar != null) {
      data['isAvatar'] = isAvatar;
    }
    if (isCover != null) {
      data['isCover'] = isCover;
    }
    if (albumId != null) {
      data['album_id'] = albumId;
    }
    if (status != null) {
      data['status'] = status;
    }
    if (createdAt != null) {
      data['created_at'] = createdAt?.toIso8601String();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt;
    }
    return data;
  }

  Mediafile copyWith({
    int? id,
    String? mediaFileName,
    String? mediaType,
    int? postId,
    int? userId,
    bool? isAvatar,
    bool? isCover,
    int? albumId,
    int? status,
    DateTime? createdAt,
    String? updatedAt,
  }) =>
      Mediafile(
        id: id ?? this.id,
        mediaFileName: mediaFileName ?? this.mediaFileName,
        mediaType: mediaType ?? this.mediaType,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        isAvatar: isAvatar ?? this.isAvatar,
        isCover: isCover ?? this.isCover,
        albumId: albumId ?? this.albumId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

class Like extends BaseModel<Like> {
  int? id;
  int? userId;
  int? postId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  Like({this.id, this.userId, this.postId, this.createdAt, this.updatedAt, this.deletedAt});

  @override
  Like fromJson(Map<String, dynamic> json) => Like(
        id: (json['id'] as num?)?.toInt(),
        userId: (json['user_id'] as num?)?.toInt(),
        postId: (json['post_id'] as num?)?.toInt(),
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
        updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
        deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (userId != null) {
      data['user_id'] = userId;
    }
    if (postId != null) {
      data['post_id'] = postId;
    }
    if (createdAt != null) {
      data['created_at'] = createdAt?.toIso8601String();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt?.toIso8601String();
    }
    if (deletedAt != null) {
      data['deleted_at'] = deletedAt?.toIso8601String();
    }
    return data;
  }

  Like copyWith({
    int? id,
    int? userId,
    int? postId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      Like(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
}
