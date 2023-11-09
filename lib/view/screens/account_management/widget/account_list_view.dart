
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/account_controller.dart';
import 'package:six_pos/data/model/response/account_model.dart';

import 'package:six_pos/view/base/account_shimmer.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/account_management/widget/account_info_view.dart';


class AccountListView extends StatelessWidget {
  final bool isHome;
  final ScrollController scrollController;
  const AccountListView({Key key, this.scrollController, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<AccountController>().accountList.length != 0
          && !Get.find<AccountController>().isLoading) {
        int pageSize;
        pageSize = Get.find<AccountController>().accountListLength;

        if(offset < pageSize  && !isHome) {
          offset++;
          print('end of the page');
          Get.find<AccountController>().showBottomLoader();
          Get.find<AccountController>().getAccountList(offset);
        }
      }

    });

    return GetBuilder<AccountController>(
      builder: (accountController) {
        List<Accounts> accountList;
        accountList = accountController.accountList;

        return Column(children: [
          accountList != null ? accountList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: isHome && accountList.length> 3 ? 3: accountList.length,
              physics: isHome? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return AccountCardViewWidget(account: accountList[index], index: index,isHome:isHome);

              }): AccountShimmer() : NoDataScreen(),


        ]);
      },
    );
  }
}
