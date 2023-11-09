import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/auth_controller.dart';
import 'package:six_pos/helper/email_checker.dart';
import 'package:six_pos/helper/gradient_color_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/dashboard/nav_bar_screen.dart';
import 'package:six_pos/view/screens/store/api_selection.dart';

class LogInScreen extends StatefulWidget {
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('soy login');

    _emailController.text = Get.find<AuthController>().getUserEmail() ?? null;
    _passwordController.text = Get.find<AuthController>().getUserPassword() ?? null;

    if(_passwordController.text != ''){
      Get.find<AuthController>().setRememberMe();
    }


  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          decoration: BoxDecoration(
            gradient: GradientColorHelper.gradientColor(),
          ),
          child: Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: GetBuilder<AuthController>(builder: (authController) {
              return Column( mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                Flexible(child: SingleChildScrollView(
                  child: Column(children: [
                    Image.asset(Images.logo_with_name, width: 100),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                    Text('log_in'.tr, style: fontSizeBlack.copyWith(fontSize: Dimensions.FONT_SIZE_OVER_OVER_LARGE)),
                    SizedBox(height: 50),

                    CustomFieldWithTitle(
                      customTextField: CustomTextField(
                        fillColor: Colors.transparent,
                        hintText: 'enter_email_address'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                      ),
                      title: 'email'.tr,
                    ),

                    CustomFieldWithTitle(
                      customTextField: CustomTextField(
                        fillColor: Colors.transparent,
                        hintText: 'password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                      ),
                      title: 'password'.tr,
                    ),

                    Row(children: [
                      Expanded(
                        child: ListTile(
                          onTap: () => authController.toggleRememberMe(),
                          leading: Checkbox(
                            activeColor: Theme.of(context).secondaryHeaderColor,
                            value: authController.isActiveRememberMe,
                            onChanged: (bool isChecked) =>
                                authController.toggleRememberMe(),
                          ),
                          title: Text('remember_me'.tr),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 0,
                        ),
                      ),
                    ]),
                  ],
                  ),
                ),
                ),

                !authController.isLoading ? CustomButton(
                  buttonText: 'log_in'.tr,
                  onPressed: () => _login(authController, _emailController, _passwordController, context),
                ) : Center(child: CircularProgressIndicator()),


                // demo login credential
                AppConstants.demo?
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE):SizedBox(),
                AppConstants.demo?
                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  color: Theme.of(context).primaryColor.withOpacity(.125),
                ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Row(
                        children: [
                          Text('${'email'.tr} : ',style: fontSizeBold,),
                          Text(' ${'admin@admin.com'}',style: fontSizeRegular,),
                        ],
                      ),
                      SizedBox(height: Dimensions.fontSizeExtraSmall),
                      Row(
                        children: [
                          Text('${'password'.tr} : ', style: fontSizeBold),
                          Text(' ${'12345678'}', style: fontSizeRegular),
                        ],
                      ),

                    ],),
                    InkWell(
                      onTap: (){
                        _emailController.text = "admin@admin.com";
                        _passwordController.text = "12345678";
                        showCustomSnackBar('successfully_copied'.tr, isError: false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          color: Theme.of(context).primaryColor
                        ),
                        width: 50,height: 50,
                          child: Icon(Icons.copy,color: Theme.of(context).cardColor)),
                    ),
                  ],
                ),):SizedBox(),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              ]);
            }),
          ),
          ),
        ),
      ),
    );
  }

  void _login(
      AuthController authController,
      TextEditingController emailController,
      TextEditingController passController,
      BuildContext context) async {
    String _password = passController.text.trim();
    String _email = _emailController.text.trim();

    if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (EmailChecker.isNotValid(_email)) {
      showCustomSnackBar('enter_valid_email'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.login(emailAddress: _email, password: _password).then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserEmailAndPassword(emailAddress: _email, password: _password);
          } else {
            authController.clearUserEmailAndPassword();
          }

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ApiSelectionScreen(apis: status.data),
          //   ),
          // );

          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NavBarScreen()));
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ApiSelectionScreen(apis: status.data)));
        }
      });
    }
  }
}

Future<bool> _onWillPop(BuildContext context) async {
  showAnimatedDialog(context,
      CustomDialog(
        icon: Icons.exit_to_app_rounded, title: 'exit'.tr,
        description: 'do_you_want_to_exit_the_app'.tr, onTapFalse:() => Navigator.of(context).pop(false),
        onTapTrue:() {
          SystemNavigator.pop();
        },
        onTapTrueText: 'yes'.tr, onTapFalseText: 'no'.tr,
      ),
      dismissible: false,
      isFlip: true);
  return true;
}