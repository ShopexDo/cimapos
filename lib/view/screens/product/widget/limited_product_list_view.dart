import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/data/model/response/limite_stock_product_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/product/widget/limited_stock_product_card.dart';



class LimitedStockProductListView extends StatelessWidget {
  final bool isHome;
  final ScrollController scrollController;
  const LimitedStockProductListView({Key key, this.scrollController, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;

    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<ProductController>().limitedStockProductList.length != 0
          && !Get.find<ProductController>().isLoading) {
        int pageSize;
        pageSize = Get.find<ProductController>().limitedStockProductListLength;
        print('end of the page ===>$pageSize and offset is ==>$offset');

        if(offset < pageSize && !isHome) {
          offset++;
          print('end of the page');
          Get.find<ProductController>().showBottomLoader();
          Get.find<ProductController>().getLimitedStockProductList(offset);
        }
      }

    });

    return GetBuilder<ProductController>(
      builder: (limitedStockProductController) {
        List<StockLimitedProducts> limitedStockProductList;
        limitedStockProductList = limitedStockProductController.limitedStockProductList;

        return Column(children: [
          !limitedStockProductController.isFirst ? limitedStockProductList != null && limitedStockProductList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: isHome &&  limitedStockProductList.length> 2 ? 3:limitedStockProductList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return LimitedStockProductCardViewWidget(product: limitedStockProductList[index], index: index, isHome: isHome);
              }): NoDataScreen() : SizedBox.shrink(),
          limitedStockProductController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
