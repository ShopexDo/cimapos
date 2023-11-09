import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/controller/theme_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/screens/product/widget/searched_product_item_widget.dart';
class ProductSearchDialog extends StatelessWidget {
  const ProductSearchDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (searchedProductController){
      return searchedProductController.searchedProductList != null && searchedProductController.searchedProductList.length !=0?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: Container(height: 400,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 400],
                  spreadRadius: .5, blurRadius: 12, offset: Offset(3,5))]

          ),
          child: ListView.builder(
              itemCount: searchedProductController.searchedProductList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return SearchedProductItemWidget(product: searchedProductController.searchedProductList[index]);

              }),
        ),
      ):SizedBox.shrink();
    });
  }
}
