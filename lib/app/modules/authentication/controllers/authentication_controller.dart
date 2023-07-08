import 'dart:convert';

import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/core/constants/app_constant.dart';
import 'package:ckc_social_app/app/core/utils/helper_widget.dart';
import 'package:ckc_social_app/app/models/users_model.dart';
import 'package:ckc_social_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';

class AuthenticationController extends BaseController {
  static UsersModel? userAccount;
  final formSignInKey = GlobalKey<FormBuilderState>();
  final formSignUpKey = GlobalKey<FormBuilderState>();
  final formForgotPasswordKey = GlobalKey<FormBuilderState>();
  bool isRememberPassword = true;

  @override
  Future<void> onInitData() async {
    final userAccountString = Global.sharedPreferences.getString(StorageConstants.userAccount);
    if (userAccountString != null) {
      userAccount = UsersModel().fromJson(jsonDecode(userAccountString));
      //set field username, password
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        formSignInKey.currentState?.fields['email']?.didChange(userAccount?.email);
        formSignInKey.currentState?.fields['password']?.didChange(userAccount?.password);
      });
    }
  }

  void onSignIn() {
    if (formSignInKey.currentState?.saveAndValidate() ?? false) {
      apiCall
          .onRequest(
        ApiUrl.post_auth_login(),
        RequestMethod.POST,
        body: formSignInKey.currentState?.value,
        baseModel: UsersModel(),
      )
          .then((result) {
        if (result == null) return;
        userAccount = result as UsersModel;
        //luu lai username, password
        _saveRememberPassword(userAccount!..password = formSignInKey.currentState?.value['password']);

        Get.offAllNamed(Routes.HOME());
        //set trạng thái Online
        final fireBaseService = Get.find<FireBaseService>();
        fireBaseService.call_setStatusUserOnline('Online');

        //save device token
        fireBaseService.getDeviceFirebaseToken().then((token) => saveDeviceToken(token ?? ''));
      });
    }
    // else {
    //   Printt.white(formSignInKey.currentState?.value.toString());
    //   Printt.white('validation failed');
    // }
  }

  void onSignUp() {
    if (formSignUpKey.currentState?.saveAndValidate() ?? false) {
      final name = formSignUpKey.currentState!.value['email'].toString().split('@')[0];
      apiCall.onRequest(
        ApiUrl.post_auth_register(),
        RequestMethod.POST,
        body: {
          'displayName': name,
          ...formSignUpKey.currentState!.value,
        },
      ).then((result) {
        if (result == null) return;
        HelperWidget.showSnackBar(message: result['message'] + ', Please check your mail !');
      });
    }
  }

  static void onSignOut() {
    saveAccount(null);
    Get.offAllNamed(Routes.AUTHENTICATION());
    Get.find<FireBaseService>().call_setStatusUserOnline('Offline');
  }

  void onTryApp() {
    Get.offAllNamed(Routes.HOME());
  }

  static void saveAccount(UsersModel? user) {
    (user == null)
        ? Global.sharedPreferences.remove(StorageConstants.userAccount)
        : Global.sharedPreferences.setString(StorageConstants.userAccount, jsonEncode(user.toJson()));
  }

  void _saveRememberPassword(UsersModel user) {
    isRememberPassword ? saveAccount(user) : saveAccount(null);
  }

  void onForgotPassword() {
    if (formForgotPasswordKey.currentState?.saveAndValidate() ?? false) {
      apiCall
          .onRequest(
        ApiUrl.post_auth_forgotPassword(),
        RequestMethod.POST,
        body: formForgotPasswordKey.currentState?.value,
      )
          .then((result) {
        if (result == null) return;
        HelperWidget.showSnackBar(message: result.toString());
      });
    }
  }

  void saveDeviceToken(String tokenId) {
    apiCall.onRequest(ApiUrl.post_saveDeviceToken(), RequestMethod.POST, body: {
      'deviceToken': tokenId,
    });
  }
}
