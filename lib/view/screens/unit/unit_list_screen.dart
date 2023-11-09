import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/unit_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/unit/widget/add_new_unit_screen.dart';
import 'package:six_pos/view/screens/unit/widget/unit_list_view.dart';
class UnitListViewScreen extends StatefulWidget {
  const UnitListViewScreen({Key key}) : super(key: key);

  @override
  State<UnitListViewScreen> createState() => _UnitListViewScreenState();
}

class _UnitListViewScreenState extends State<UnitListViewScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<UnitController>().getUnitList(1);
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
                    CustomHeader(title: 'unit_list'.tr, headerImage: Images.categories),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT    ),
                    UnitListView(scrollController: _scrollController,),
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
          Get.to(AddNewUnit());
        },child: Image.asset(Images.add_category_icon),),
    );
  }
}
