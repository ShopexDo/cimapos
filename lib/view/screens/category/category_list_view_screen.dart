import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/category/widget/add_new_category.dart';
import 'package:six_pos/view/screens/category/widget/category_list_view.dart';
class CategoryListViewScreen extends StatefulWidget {
  const CategoryListViewScreen({Key key}) : super(key: key);

  @override
  State<CategoryListViewScreen> createState() => _CategoryListViewScreenState();
}

class _CategoryListViewScreenState extends State<CategoryListViewScreen> {
  final ScrollController _scrollController = ScrollController();

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
                      CustomHeader(title: 'category_list'.tr, headerImage: Images.categories),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT    ),
                      CategoryListView(scrollController: _scrollController,),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_EXTRA_LARGE)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

      floatingActionButton: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
        Get.to(AddNewCategory());
      },child: Image.asset(Images.add_category_icon),),
    );
  }
}
