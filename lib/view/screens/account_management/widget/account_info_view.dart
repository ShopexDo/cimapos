import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/account_controller.dart';
import 'package:six_pos/data/model/response/account_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_divider.dart';
import 'package:six_pos/view/base/custom_ink_well.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/account_management/add_account_screen.dart';

class AccountCardViewWidget extends StatelessWidget {
  final bool isHome;
  final Accounts account;
  final int index;
  const AccountCardViewWidget({Key key, this.account, this.index, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHome?Container(height: 40,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        children: [
          Row(
            children: [
              Text('${index + 1}.', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),
              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
              Expanded(child: Text('${account.account}', maxLines: 1,overflow: TextOverflow.ellipsis,
                  style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor))),
              Spacer(),
              Text('${account.balance}', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),

            ],
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          CustomDivider(color: Theme.of(context).hintColor,height: .5)
        ],
      ),
    ) :Column(
      children: [
        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),

        Container(color: Theme.of(context).cardColor, child: Column(children: [
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            leading: Text('${index + 1}.', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
            title: Text('${'account_type'.tr} : ${account.account}', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: CustomDivider(color: Theme.of(context).hintColor),
          ),

          ListTile(
            leading: SizedBox(),

            title: Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text('balance_info'.tr, style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor)),

                Text('${'balance'.tr} : ${account.balance}'),

                Text('${'total_in'.tr}: ${account.totalIn}'),

                Text('${'total_out'.tr}: ${account.totalOut}'),
              ]),
            ),
            trailing:  account.id == 1 || account.id == 2 || account.id == 3?SizedBox():
            Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: CustomInkWell(child: Image.asset(Images.edit_icon, height: 20), onTap: () {
                    Get.to(AddAccountScreen(account: account));

                  },),
                ),
              ),

              GetBuilder<AccountController>(
                builder: (accountController) {
                  return Flexible(
                    child: CustomInkWell(child: Image.asset(Images.delete_icon, height: 20), onTap: () {
                      showAnimatedDialog(context,
                          CustomDialog(
                            delete: true,
                            icon: Icons.exit_to_app_rounded, title: '',
                            description: 'are_you_sure_you_want_to_delete_account'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                            onTapTrue:() {
                              accountController.deleteAccount(account.id);
                            },
                            onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                          ),
                          dismissible: false,
                          isFlip: true);

                    },),
                  );
                }
              ),
            ],)
          )
        ],),),

        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      ],
    );
  }
}
