import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/data/model/response/sub_category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/screens/category/widget/sub_category_card_widget.dart';
class SubCategoryListView extends StatelessWidget {
  final ScrollController scrollController;
  const SubCategoryListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<CategoryController>().subCategoryList.length != 0
          && !Get.find<CategoryController>().isGetting) {
        int pageSize;
        pageSize = Get.find<CategoryController>().subCategoryListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getSubCategoryList(offset, Get.find<CategoryController>().categoryList[Get.find<CategoryController>().categoryIndex].id);
        }
      }

    });

    return GetBuilder<CategoryController>(
      builder: (categoryController) {
        List<SubCategories> subCategoryList;
        subCategoryList = categoryController.subCategoryList;

        return Column(children: [

          subCategoryList != null ? subCategoryList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: subCategoryList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return SubCategoryCardWidget(subCategory: subCategoryList[index]);

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

