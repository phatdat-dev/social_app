import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/models/request/base_search_request_model.dart';

class HomeController extends BaseController {
  final BaseSearchRequestModel searchRequestModel = BaseSearchRequestModel(pageSize: 10);

  @override
  Future<void> onInitData() async {
    
  }
}
