import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/coupon_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/coupon/add_coupon_screen.dart';
import 'package:six_pos/view/screens/coupon/widget/coupon_list_view.dart';




class CouponListScreen extends StatefulWidget {
  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  initState(){
    super.initState();
    Get.find<CouponController>().getCouponListData(1);
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
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CustomHeader(title: 'coupon_list'.tr, headerImage: Images.categories),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT    ),
                    CouponListView(scrollController: _scrollController),
                  ],
                ),
              )
            ],
          ),
        ),
      ),



      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: ColorResources.whiteColor,
        child: Image.asset(Images.add_new_category),
        onPressed: () => Get.to(() => AddCouponScreen()),
      ),
    );
  }
}
