import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/core/base/base_project.dart';
import 'package:social_app/app/core/config/api_url.dart';
import 'package:social_app/app/core/constants/app_constant.dart';
import 'package:social_app/app/core/utils/utils.dart';
import 'package:social_app/app/models/users_model.dart';

class AuthenticationController extends BaseController {
  static UsersModel? userAccount;
  final formSignInKey = GlobalKey<FormBuilderState>();
  final formSignUpKey = GlobalKey<FormBuilderState>();
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
        Global.navigatorKey.currentContext!.go('/');
      });
    }
    // else {
    //   Printt.white(formSignInKey.currentState?.value.toString());
    //   Printt.white('validation failed');
    // }
  }

  void onSignUp() {
    if (formSignUpKey.currentState?.saveAndValidate() ?? false) {
      Printt.white(formSignUpKey.currentState?.value.toString());
    }
    // else {
    //   Printt.white(formSignUpKey.currentState?.value.toString());
    //   Printt.white('validation failed');
    // }
  }

  void onSignOut() {
    saveAccount(userAccount?..token = '');
    Global.navigatorKey.currentContext!.go('/authentication');
  }

  void onTryApp() {
    Global.navigatorKey.currentContext!.go('/');
  }

  void saveAccount(UsersModel? user) {
    (user == null)
        ? Global.sharedPreferences.remove(StorageConstants.userAccount)
        : Global.sharedPreferences.setString(StorageConstants.userAccount, jsonEncode(user.toJson()));
  }

  void _saveRememberPassword(UsersModel user) {
    isRememberPassword ? saveAccount(user) : saveAccount(null);
  }

  void onForgotPassword(String value){
    
  }
}
