
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/brand_controller.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/data/model/response/brand_model.dart';
import 'package:six_pos/view/base/brand_shimmer.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/brand/widget/brand_card_widget.dart';

class BrandListView extends StatelessWidget {
  final ScrollController scrollController;
  const BrandListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<BrandController>().brandList.length != 0
          && !Get.find<BrandController>().isLoading) {
        int pageSize;
        pageSize = Get.find<CategoryController>().categoryListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<BrandController>().showBottomLoader();
          Get.find<BrandController>().getBrandList(offset);
        }
      }

    });

    return GetBuilder<BrandController>(
      builder: (brandController) {
        List<Brands> brandList;
        brandList = brandController.brandList;

        return Column(children: [

          brandList != null ? brandList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: brandList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return BrandCardWidget(brand: brandList[index]);

              }) : BrandShimmer() : NoDataScreen(),
          //brandController.isLoading ? BrandShimmer() : SizedBox.shrink(),

        ]);
      },
    );
  }
}
