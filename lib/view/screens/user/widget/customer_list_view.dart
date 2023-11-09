
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/data/model/response/customer_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/view/base/account_shimmer.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/screens/user/widget/customer_card_view_widget.dart';


class CustomerListView extends StatelessWidget {
  final ScrollController scrollController;
  const CustomerListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<CustomerController>().customerList.length != 0
          && !Get.find<CustomerController>().isGetting) {
        int pageSize;
        pageSize = Get.find<CustomerController>().customerListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<CustomerController>().showBottomLoader();
          Get.find<CustomerController>().getCustomerList(offset);
        }
      }

    });

    return GetBuilder<CustomerController>(
      builder: (customerController) {
        List<Customers> customerList;
        customerList = customerController.customerList;

        return Column(children: [

          !customerController.isFirst ? customerList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: customerList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return CustomerCardViewWidget(customer: customerList[index]);

              }) : AccountShimmer() : NoDataScreen(),
          customerController.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
