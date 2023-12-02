import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/income_controller.dart';
import 'package:cimapos/data/model/response/income_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/view/base/account_shimmer.dart';
import 'package:cimapos/view/base/no_data_screen.dart';
import 'package:cimapos/view/screens/account_management/widget/income_info.dart';
class IncomeListView extends StatelessWidget {
  final ScrollController scrollController;
  const IncomeListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<IncomeController>().incomeList.length != 0
          && !Get.find<IncomeController>().isLoading) {
        int pageSize;
        pageSize = Get.find<IncomeController>().incomeListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<IncomeController>().showBottomLoader();
          Get.find<IncomeController>().getIncomeList(offset, reload: false);
        }
      }

    });

    return GetBuilder<IncomeController>(
      builder: (incomeController) {
        List<Incomes> incomeList;
        incomeList = incomeController.incomeList;

        return Column(children: [
          !incomeController.isFirst ? incomeList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount:  incomeList.length,
              physics:  BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return IncomeCardViewWidget(income: incomeList[index], index: index);

              }) : NoDataScreen(): AccountShimmer(),
          incomeController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
