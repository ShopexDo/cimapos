import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/model/response/profile_model.dart';
import 'package:six_pos/data/model/response/response_model.dart';
import 'package:six_pos/data/repository/auth_repo.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';


class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({@required this.authRepo});

  bool _isLoading = false;
  bool _notification = true;
  bool _isActiveRememberMe = false;
  ProfileModel _profileModel;
  XFile _pickedFile;

  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get isActiveRememberMe => _isActiveRememberMe;

  ProfileModel get profileModel => _profileModel;
  XFile get pickedFile => _pickedFile;

  Future<ResponseModel> login({@required String emailAddress,@required String password}) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(emailAddress, password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token']);
      responseModel = ResponseModel(true, 'successful', response.body['apis']);
      _isLoading = false;
    }else if(response.statusCode == 422){
      Map map = response.body;
      String message = map['message'];
      showCustomSnackBar(message, isError: true);
    } else {
      _isLoading = true;
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
    update();
  }


  Future<void> getProfile() async {
    Response response = await authRepo.getProfileInfo();
    if (response.statusCode == 200) {}
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  void saveUserEmailAndPassword({@required String emailAddress,@required String password}) {
    authRepo.saveUserEmailAndPassword(emailAddress, password);
  }

  String getUserEmail() {
    return authRepo.getUserEmail() ?? "";
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo.clearUserEmailAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }


}