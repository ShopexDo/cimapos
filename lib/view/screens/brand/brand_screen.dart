import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/brand_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/brand/widget/add_new_brand_screen.dart';
import 'package:six_pos/view/screens/brand/widget/brand_list_view.dart';
class BrandListViewScreen extends StatefulWidget {
  const BrandListViewScreen({Key key}) : super(key: key);

  @override
  State<BrandListViewScreen> createState() => _BrandListViewScreenState();
}

class _BrandListViewScreenState extends State<BrandListViewScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<BrandController>().getBrandList(1,reload: true);
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
                    CustomHeader(title: 'brand_list'.tr, headerImage: Images.categories),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT    ),
                    BrandListView(scrollController: _scrollController,),
                    SizedBox(height: 100),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(AddNewBrand());
        },child: Image.asset(Images.add_category_icon),),
    );
  }
}
