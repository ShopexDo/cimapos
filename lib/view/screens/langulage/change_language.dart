import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/localization_controller.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'widget/language_widget.dart';

class ChooseLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return Column(children: [
          Expanded(child: Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Center(child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(Images.logo)),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text('select_language'.tr, style: fontSizeMedium.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                        )),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 1),
                        ),
                        itemCount: localizationController.languages.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => LanguageWidget(
                          languageModel: localizationController.languages[index],
                          localizationController: localizationController,
                          index: index,
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Text('you_can_change_language'.tr, style: fontSizeRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: Theme.of(context).disabledColor,
                      )),
                    ],
                  ),
                ),),
              ),
            ),
          ),),
          Container(
            padding: const EdgeInsets.only(
              left: Dimensions.PADDING_SIZE_DEFAULT,
              right: Dimensions.PADDING_SIZE_DEFAULT,
              bottom: Dimensions.PADDING_SIZE_EXTRA_LARGE,
            ),
            child: Row(children: [
              Expanded(child: CustomButton(
                buttonText: 'save'.tr,
                onPressed: () {
                  if (localizationController.languages.length > 0 && localizationController.selectedIndex != -1) {
                    localizationController.setLanguage(Locale(
                      AppConstants.languages[localizationController.selectedIndex].languageCode,
                      AppConstants.languages[localizationController.selectedIndex].countryCode,
                    ),);
                    Get.back();
                  } else {
                    showCustomSnackBar('select_a_language'.tr, isError: false);
                  }
                },
                ),
              ),
            ],
            ),
          ),
        ]);
      },),
    );
  }
}
