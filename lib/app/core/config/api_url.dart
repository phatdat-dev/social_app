// ignore_for_file: non_constant_identifier_names

class ApiUrl {
  static String get base_url => 'http://192.168.1.6:8080'; //baseUrl
  //auth
  static String post_auth_login() => '/api/auth/login';
  static String post_auth_forgotPassword() => '/api/auth/forgot-password';
  static String post_auth_register() => '/api/auth/register';
  //
  static String get_fetchPost() => '/api/v1/fetch-post';
  static String post_createPost() => '/api/v1/create-post';
  static String post_deletePost() => '/api/v1/delete-post';
  static String post_updatePost() => '/api/v1/update-post';
  static String get_fetchPostById(int postId) => '/api/v1/fetch-post-by-id/postId=$postId';
  static String get_fetchHistoryEditPost(int postId) => '/api/v1/fetch-history-edit-post/postId=$postId';
  static String post_createReport() => '/api/v1/create-report';
  //
  static String get_fetchFriendByUserId(int userId, [int? limit]) => '/api/v1/fetch-friend-by-user-id/$userId' + (limit != null ? '/$limit' : '');
  static String get_profileUser(int userId) => '/api/v1/profile-user/userId=$userId';
  static String get_fetchFriendsSuggestion() => '/api/v1/fetch-friends-suggestion';
  static String get_fetchFriendRequest(int userId) => '/api/v1/fetch-friend-request-list/userId=$userId';
  static String post_editInformationUser() => '/api/v1/edit-information-user';
  static String post_uploadAvatar() => '/api/v1/upload-avatar';
  static String post_uploadCoverImage() => '/api/v1/upload-cover-image';
  static String post_updatePasswordUser() => '/api/v1/update-password-user';
  //
  static String get_fetchGroupJoined() => '/api/v1/fetch-group-joined';
  static String get_fetchPostGroup() => '/api/v1/fetch-post-group';
  static String get_fetchPostByGroupId(int groupId) => '/api/v1/fetch-post-by-group-id/$groupId';
  static String get_fetchMemberGroup(int groupId) => '/api/v1/fetch-member-group/$groupId';
  static String post_removeMemberFromGroup() => '/api/v1/remove-member-from-group';
  static String post_removeAdminToGroup() => '/api/v1/remove-admin-to-group';
  static String post_addAdminToGroup() => '/api/v1/add-admin-group';
  static String get_searchUsersAndGroups(String input) => '/api/v1/search-users-and-groups/input=$input';
  static String post_createGroup() => '/api/v1/create-group';
  static String get_fetchFriendToInviteGroup(int groupId) => '/api/v1/fetch-friend-to-invite-group/$groupId';
  static String post_sendInviteToGroup() => '/api/v1/send-invite-to-group';
  static String get_fetchInviteToGroup() => '/api/v1/fetch-invite-to-group';
  static String post_acceptInviteToGroup() => '/api/v1/accept-invite-to-group';
  static String post_editInformationGroup() => '/api/v1/edit-information-group';
  //
  static String post_likePost() => '/api/v1/post/like-post';
  static String post_saveDeviceToken() => '/api/v1/save-device-token';
  static String post_sharePostToProfile() => '/api/v1/share-post-to-profile';
  static String get_fetchCommentByPost(int postId) => '/api/v1/fetch-comment-by-post/postId=$postId';
  static String get_fetchReplyComment(int commentId) => '/api/v1/fetch-reply-comment/commentId=$commentId';
  static String post_createCommentPost() => '/api/v1/create-comment-post';
  static String post_replyComment() => '/api/v1/reply-comment';
  static String post_unfriend() => '/api/v1/unfriend';
  static String post_requestAddFriend() => '/api/v1/request-add-friend';
  static String post_acceptFriendRequest() => '/api/v1/accept-friend-request';
  static String post_denyFriendRequest() => '/api/v1/deny-friend-request';
  static String get_fetchFellAndActivityPosts() => '/api/v1/fetch-fell-and-activity-posts';
  //
  static String get_fetchStories() => '/api/v1/stories';
  static String get_createStories() => '/api/v1/stories/create-story';
  //
  static String get_fetchNotification() => '/api/v1/fetch-notifications';
  //Message
  static String post_messageUploadFile() => '/api/v1/message/upload-file'; //bo?
  static String post_createChat() => '/api/v1/chats/create-chat';
  static String get_fetchListChat() => '/api/v1/fetch-list-chats';
  static String get_fetchMessage(int userId) => '/api/v1/fetch-message/userId=$userId';
  static String post_sendMessage() => '/api/v1/chats/sent-message-file';
  static String post_createGroupChat() => '/api/v1/chats/create-group-chat';
  //
  static String get_fetchImageUpload(int userId, [int? limit]) => '/api/v1/fetch-image-uploaded/userId=$userId' + (limit != null ? '/$limit' : '');
  static String get_fetchImageFromPostTag(int userId) => '/api/v1/fetch-image-from-post-tag/userId=$userId';
  static String get_fetchAlbumByUserId(int userId) => '/api/v1/fetch-album-by-userid/userId=$userId';
  static String get_fetchImageAlbum(int userId, int albumId) => '/api/v1/fetch-image-album/$userId/$albumId';
  static String post_createAlbum() => '/api/v1/create-album';
  static String post_editAlbum() => '/api/v1/edit-album';
  static String post_deleteAlbum() => '/api/v1/delete-album';
}
