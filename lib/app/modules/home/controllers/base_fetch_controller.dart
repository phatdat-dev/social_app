import 'package:get/get.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/utils/utils.dart';

abstract class BaseFetchController extends BaseController with StateMixin<List<Map<String, dynamic>>> {
  String get apiUrl;

  Map<String, dynamic> request = {
    'page': 1,
  };
  bool dataResponseIsMaximum = false;

  @override
  Future<void> onInitData() async {
    resetRequest();
    call_fetchData();
  }

  Future<void> call_fetchData() async {
    apiCall
        .onRequest(
      apiUrl,
      RequestMethod.GET,
      queryParam: request,
      isShowLoading: false,
    )
        .then((value) {
      final data = Helper.convertToListMap(value['data']);
      if (state == null) {
        change(data, status: RxStatus.success());
      } else {
        if (data.isEmpty)
          dataResponseIsMaximum = true;
        else
          change([...state!, ...data], status: RxStatus.loadingMore());
      }
    });
  }

  void loadMoreData() {
    // Khi scroll đến cuối danh sách
    // Thực hiện tải thêm dữ liệu
    request = request.copyWith({'page': request['page'] + 1});
    call_fetchData();
  }

  void resetRequest() {
    request.update('page', (value) => 1);
    change(null, status: RxStatus.loading());
    dataResponseIsMaximum = false;
  }
}
