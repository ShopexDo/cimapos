import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/supplier_controller.dart';
import 'package:cimapos/data/model/response/supplier_model.dart';
import 'package:cimapos/data/model/response/transaction_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/view/base/account_shimmer.dart';
import 'package:cimapos/view/base/no_data_screen.dart';
import 'package:cimapos/view/screens/account_management/widget/transaction_list_card_widget.dart';


class SupplierTransactionListView extends StatelessWidget {
  final Suppliers supplier;
  final ScrollController scrollController;
  const SupplierTransactionListView({Key key, this.scrollController, this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<SupplierController>().supplierTransactionList.length != 0
          && !Get.find<SupplierController>().isLoading) {
        int pageSize;
        pageSize = Get.find<SupplierController>().supplierTransactionListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<SupplierController>().showBottomLoader();
          Get.find<SupplierController>().getSupplierTransactionList(offset, supplier.id, reload: false);
        }
      }

    });

    return GetBuilder<SupplierController>(
      builder: (supplierController) {
        List<Transfers> transactionList;
        transactionList = supplierController.supplierTransactionList;

        return Column(children: [
          !supplierController.isFirst ?  transactionList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: transactionList.length,
              physics:  BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return TransactionCardViewWidget(transfer: transactionList[index], index: index);

              }): NoDataScreen() :AccountShimmer(),
          supplierController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
