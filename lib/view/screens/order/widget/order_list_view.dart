import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/order_controller.dart';
import 'package:cimapos/data/model/response/order_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/view/base/custom_loader.dart';
import 'package:cimapos/view/base/no_data_screen.dart';
import 'package:cimapos/view/screens/order/widget/order_card_widget.dart';


class OrderListView extends StatelessWidget {
  final ScrollController scrollController;
  const OrderListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<OrderController>().orderList.length != 0
          && !Get.find<OrderController>().isLoading) {
        int pageSize;
        pageSize = Get.find<OrderController>().orderListLength;

        if(Get.find<OrderController>().offset < pageSize) {
          Get.find<OrderController>().setOffset(Get.find<OrderController>().offset);
          print('end of the page');
          Get.find<OrderController>().showBottomLoader();
          Get.find<OrderController>().getOrderList(Get.find<OrderController>().offset.toString());
        }
      }

    });

    return GetBuilder<OrderController>(
      builder: (orderController) {
        List<Orders> orderList;
        orderList = orderController.orderList;

        return Column(children: [

          !orderController.isFirst ? orderList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: orderList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return OrderCardWidget(order: orderList[index]);

              }): NoDataScreen() : CustomLoader(),
          orderController.isLoading  && !orderController.isFirst ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
