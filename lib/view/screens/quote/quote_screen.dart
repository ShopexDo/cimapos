import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/controller/quote_controller.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/quote/widget/quote_list_view.dart';
import 'package:six_pos/view/screens/user/widget/customer_wise_order_list.dart';
class QuoteScreen extends StatefulWidget {
  final bool fromNavBar;
  final bool isCustomer;
  final int customerId;
  const QuoteScreen({Key key, this.fromNavBar = true, this.isCustomer = false, this.customerId}) : super(key: key);

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    if(widget.isCustomer){
      Get.find<CustomerController>().getCustomerWiseOrderListList(widget.customerId, 1);
    }else{
      Get.find<QuoteController>().getQuoteList('1', reload: true);
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
              Get.find<QuoteController>().getQuoteList('1', reload: true);
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  CustomHeader(title: 'quote_list'.tr, headerImage: Images.people_icon),
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
