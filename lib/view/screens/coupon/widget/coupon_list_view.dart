
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/coupon_controller.dart';
import 'package:six_pos/data/model/response/coupon_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/screens/coupon/widget/coupon_card_widget.dart';


class CouponListView extends StatelessWidget {
  final ScrollController scrollController;
  const CouponListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<CouponController>().couponList.length != 0
          && !Get.find<CouponController>().isLoading) {
        int pageSize;
        pageSize = Get.find<CouponController>().couponListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<CouponController>().showBottomLoader();
          Get.find<CouponController>().getCouponListData(offset);
        }
      }

    });

    return GetBuilder<CouponController>(
      builder: (couponController) {
        List<Coupons> couponList;
        couponList = couponController.couponList;

        return Column(children: [

          !couponController.isFirst ? couponList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: couponList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return CouponCardWidget(coupon: couponList[index], index: index);

              }): SizedBox.shrink() : SizedBox.shrink(),
          couponController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
