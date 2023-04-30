import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/utils/utils.dart';

abstract class BaseFetchController implements BaseController {
  String get apiUrl;

  Map<String, dynamic> request = {
    'page': 1,
  };
  List<Map<String, dynamic>>? dataResponse = null;
  bool dataResponseIsMaximum = false;

  Future<void> call_fetchData() async {
    apiCall
        .onRequest(
      apiUrl,
      RequestMethod.GET,
      queryParam: request,
      // isShowLoading: false,
    )
        .then((value) {
      final data = Helper.convertToListMap(value['data']);
      if (dataResponse == null) {
        dataResponse = data;
      } else {
        if (data.isEmpty)
          dataResponseIsMaximum = true;
        else
          dataResponse = [...dataResponse!, ...data]; //ko xai` .addAll vi` notifyListeners se k rebuild
      }
      notifyListeners();
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
    dataResponse = null;
    dataResponseIsMaximum = false;
  }
}
