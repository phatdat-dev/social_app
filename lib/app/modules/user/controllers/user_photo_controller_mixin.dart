part of 'user_controller.dart';

mixin UserPhotoControllerMixin implements BaseController {
  final listImageUploadOfUser = ListMapDataState([]);
  final listImageFromPostTag = ListMapDataState([]);
  final listAlbum = ListMapDataState([]);
  final currentAlbum = MapDataState({});

  Future<void> call_fetchImageUploadByUserId([int? userId, int? limit]) async {
    listImageUploadOfUser.run(apiCall
        .onRequest(
          ApiUrl.get_fetchImageUpload(userId ?? AuthenticationController.userAccount!.id!, limit),
          RequestMethod.GET,
          isShowLoading: false,
        )
        .then((value) => Helper.convertToListMap(value)));
  }

  Future<void> call_fetchImageFromPostTag([int? userId]) async {
    listImageFromPostTag.run(
      apiCall
          .onRequest(
            ApiUrl.get_fetchImageFromPostTag(userId ?? AuthenticationController.userAccount!.id!),
            RequestMethod.GET,
            isShowLoading: false,
          )
          .then((value) => Helper.convertToListMap(value)),
    );
  }

  Future<void> call_fetchAlbumByUserId([int? userId]) async {
    listAlbum.run(
      apiCall
          .onRequest(
            ApiUrl.get_fetchAlbumByUserId(userId ?? AuthenticationController.userAccount!.id!),
            RequestMethod.GET,
            isShowLoading: false,
          )
          .then((value) => Helper.convertToListMap(value)),
    );
  }

  Future<void> call_fetchImageFromAlbum({required int userId, required int albumId}) async {
    return currentAlbum.run(
      apiCall
          .onRequest(
            ApiUrl.get_fetchImageAlbum(userId, albumId),
            RequestMethod.GET,
          )
          .then((value) => value),
    );
  }

  Future<void> call_createOrUpdateAlBum({
    int? albumId,
    required String name,
    required int privacy,
    required List<String>? filesPath,
  }) async {
    final formData = FormData({
      if (albumId != null) 'albumId': albumId,
      'albumName': name,
      'privacy': privacy,
      'files[]': filesPath?.map((path) => MultipartFile(File(path), filename: path)).toList(),
    });

    await apiCall.onRequest(
      albumId != null ? ApiUrl.post_editAlbum() : ApiUrl.post_createAlbum(),
      RequestMethod.POST,
      body: formData,
    );
  }

  Future<void> call_deleteAlbum(int albumId) async {
    await apiCall.onRequest(ApiUrl.post_deleteAlbum(), RequestMethod.POST, body: {'albumId': albumId});
  }
}
