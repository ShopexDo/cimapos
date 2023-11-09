import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/screens/category/widget/add_new_sub_category.dart';
import 'package:six_pos/view/screens/category/widget/sub_category_list_view.dart';
class SubCategoryListViewScreen extends StatefulWidget {
  const SubCategoryListViewScreen({Key key}) : super(key: key);

  @override
  State<SubCategoryListViewScreen> createState() => _SubCategoryListViewScreenState();
}

class _SubCategoryListViewScreenState extends State<SubCategoryListViewScreen> {
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
                child:  Column(
                  children: [
                    CustomHeader(title: 'sub_category_list'.tr, headerImage: Images.categories),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    GetBuilder<CategoryController>(
                        builder: (categoryController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                            child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_category'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                child: DropdownButton<int>(
                                  value: categoryController.categoryIndex,
                                  items: categoryController.categoryIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                        value: categoryController.categoryIds.indexOf(value),
                                        child: Text( value != 0?
                                        categoryController.categoryList[(categoryController.categoryIds.indexOf(value) -1)].name: 'select' ));}).toList(),
                                  onChanged: (int value) {
                                    categoryController.setCategoryIndex(value, true);
                                  },
                                  isExpanded: true, underline: SizedBox(),),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            ],),),
                          );
                        }
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    SubCategoryListView(scrollController: _scrollController,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),






      floatingActionButton: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(AddNewSubCategory());
        },child: Image.asset(Images.add_category_icon),),
    );
  }
}
