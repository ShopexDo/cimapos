
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/supplier_controller.dart';
import 'package:cimapos/data/model/response/supplier_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/view/base/account_shimmer.dart';
import 'package:cimapos/view/base/no_data_screen.dart';
import 'package:cimapos/view/screens/user/widget/supplier_card_view_widget.dart';

class SupplierListView extends StatelessWidget {
  final ScrollController scrollController;
  const SupplierListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<SupplierController>().supplierList.length != 0
          && !Get.find<SupplierController>().isGetting) {
        int pageSize;
        pageSize = Get.find<SupplierController>().supplierListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<SupplierController>().showBottomLoader();
          Get.find<SupplierController>().getSupplierList(offset, reload: false);
        }
      }

    });

    return GetBuilder<SupplierController>(
      builder: (supplierController) {
        List<Suppliers> supplierList;
        supplierList = supplierController.supplierList;

        return Column(children: [

          !supplierController.isFirst ? supplierList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: supplierList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return SupplierCardViewWidget(supplier: supplierList[index]);

              })  : NoDataScreen(): AccountShimmer(),
          supplierController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
