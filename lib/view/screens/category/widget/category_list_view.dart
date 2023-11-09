
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/data/model/response/category_model.dart';
import 'package:six_pos/util/dimensions.dart';

import 'category_card_widget.dart';
class CategoryListView extends StatelessWidget {
  final ScrollController scrollController;
  const CategoryListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<CategoryController>().categoryList.length != 0
          && !Get.find<CategoryController>().isGetting) {
        int pageSize;
        pageSize = Get.find<CategoryController>().categoryListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryList(offset);
        }
      }

    });

    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        List<Categories> categoryList;
        categoryList = categoryController.categoryList;

        return Column(children: [

          !categoryController.isFirst ? categoryList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: categoryList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return CategoryCardWidget(category: categoryList[index], index: index,);

              }): SizedBox.shrink() : SizedBox.shrink(),
          categoryController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
