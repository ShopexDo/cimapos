
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/data/model/response/transaction_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/base/account_shimmer.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/account_management/widget/transaction_list_card_widget.dart';



class TransactionListView extends StatelessWidget {
  final bool isHome;

  const TransactionListView({Key key, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<TransactionController>(
      builder: (transactionController) {
        List<Transfers> transactionList;
        transactionList = transactionController.transactionList;

        return transactionController.filterClick? AccountShimmer() : Column(children: [
          !transactionController.isFirst ?transactionList != null? transactionList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: isHome && transactionList.length> 3 ? 3: transactionList.length,
              physics: isHome? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return TransactionCardViewWidget(transfer: transactionList[index], index: index);

              }) : NoDataScreen(): AccountShimmer():AccountShimmer(),
          transactionController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
