// ignore_for_file: overridden_fields
part of 'app_pages.dart';

class AuthenticationMiddleware extends GetMiddleware {
  @override
  int? priority = -1;

  @override
  RouteSettings? redirect(String? route) {
    if (AuthenticationController.userAccount == null) {
      //kiểm tra xem bộ nhớ có lưu thông tin đăng nhập trước hay không
      final userAccountString = Global.sharedPreferences.getString(StorageConstants.userAccount);
      if (userAccountString != null) {
        //nếu có thì lấy thông tin đăng nhập
        AuthenticationController.userAccount = UsersModel().fromJson(jsonDecode(userAccountString));
        return RouteSettings(name: Routes.HOME());
      }
      //nếu chưa đăng nhập thì chuyển về màn hình đăng nhập
      return RouteSettings(name: Routes.AUTHENTICATION());
    }
    return null;
  }
}
