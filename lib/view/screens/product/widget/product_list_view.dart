
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/screens/product/widget/product_card_widget.dart';


class ProductListView extends StatelessWidget {
  final ScrollController scrollController;
  const ProductListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<ProductController>().productList.length != 0
          && !Get.find<ProductController>().isLoading) {
        int pageSize;
        pageSize = Get.find<ProductController>().productListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<ProductController>().showBottomLoader();
          Get.find<ProductController>().getProductList(offset);
        }
      }

    });

    return GetBuilder<ProductController>(
      builder: (productController) {
        List<Products> productList;
        productList = productController.productList;

        return Column(children: [

          !productController.isFirst ? productList.length != 0 ?
          ListView.builder(
              itemCount: productList.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return ProductCardViewWidget(product: productList[index]);

              }): SizedBox.shrink() : SizedBox.shrink(),
          productController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
