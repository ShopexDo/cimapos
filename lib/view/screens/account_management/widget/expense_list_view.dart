
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/expense_controller.dart';
import 'package:six_pos/data/model/response/expenseModel.dart';
import 'package:six_pos/view/base/account_shimmer.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/account_management/widget/expense_info_view.dart';



class ExpenseListView extends StatelessWidget {
  final bool isHome;
  final ScrollController scrollController;
  const ExpenseListView({Key key, this.scrollController, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<ExpenseController>().expenseList.length != 0
          && !Get.find<ExpenseController>().isLoading) {
        int pageSize;
        pageSize = Get.find<ExpenseController>().expenseListLength;

        if(offset < pageSize  && !isHome) {
          offset++;
          print('end of the page');
          Get.find<ExpenseController>().showBottomLoader();
          Get.find<ExpenseController>().getExpenseList(offset);
        }
      }

    });

    return GetBuilder<ExpenseController>(
      builder: (expanseController) {
        List<Expenses> expensetList;
        expensetList = expanseController.expenseList;

        return Column(children: [
          expensetList != null? expensetList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: isHome && expensetList.length> 3 ? 3: expensetList.length,
              physics: isHome? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return ExpenseCardViewWidget(expense: expensetList[index], index: index);

              }) :AccountShimmer(): NoDataScreen(),
          expanseController.isLoading ? AccountShimmer() : SizedBox(),

        ]);
      },
    );
  }
}
