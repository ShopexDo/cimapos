import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/controller/order_controller.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/order/widget/order_list_view.dart';
import 'package:six_pos/view/screens/user/widget/customer_wise_order_list.dart';
class OrderScreen extends StatefulWidget {
  final bool fromNavBar;
  final bool isCustomer;
  final int customerId;
  const OrderScreen({Key key, this.fromNavBar = true, this.isCustomer = false, this.customerId}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    if(widget.isCustomer){
      Get.find<CustomerController>().getCustomerWiseOrderListList(widget.customerId, 1);
    }else{
      Get.find<OrderController>().getOrderList('1', reload: true);
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            if(widget.isCustomer){
              Get.find<CustomerController>().getCustomerWiseOrderListList(widget.customerId, 1);
            }else{
              Get.find<OrderController>().getOrderList('1', reload: true);
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  CustomHeader(title: 'order_list'.tr, headerImage: Images.people_icon),
                  widget.isCustomer?  CustomerWiseOrderListView(scrollController: _scrollController, customerId: widget.customerId) :
                  OrderListView(scrollController: _scrollController)
                ],),
              )
            ],
          ),
        ),
      ),

    );
  }
}
