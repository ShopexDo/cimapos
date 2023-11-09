import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/data/model/response/category_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_search_field.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/base/product_shimmer.dart';
import 'package:six_pos/view/screens/product/widget/category_item_card_widget.dart';
import 'package:six_pos/view/screens/product/widget/item_card_widget.dart';
import 'package:six_pos/view/screens/product/widget/product_search_dialog.dart';

class ItemsScreen extends StatefulWidget {
  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getSearchProductList('');
    Get.find<CategoryController>().changeSelectedIndex(0);
    if(Get.find<CategoryController>().categoryList.isNotEmpty){
      Get.find<CategoryController>().getCategoryWiseProductList(Get.find<CategoryController>().categoryList[0].id);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(title: 'products'.tr, headerImage: Images.product),
          GetBuilder<CategoryController>(
            builder: (searchProductController) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal : Dimensions.PADDING_SIZE_DEFAULT,
                vertical: Dimensions.PADDING_SIZE_SMALL),
                child: CustomSearchField(
                  controller: searchController,
                  hint: 'search_product_by_name_or_barcode'.tr,
                  prefix: Icons.search,
                  iconPressed: () => (){},
                  onSubmit: (text) => (){},
                  onChanged: (value){
                    searchProductController.getSearchProductList(value);
                  },
                  isFilter: false,
                ),
              );
            }
          ),

          Expanded(child: Stack(
            children: [
              GetBuilder<CategoryController>(
                builder: (categoryController) {
                  return categoryController.categoryList.length != 0 ?
                  Row(children: [
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(top: 3),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorResources.getCategoryWithProductColor(),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.PADDING_SIZE_LARGE))
                      ),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: categoryController.categoryList.length,
                        padding: EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          Categories _category = categoryController.categoryList[index];
                          return InkWell(
                            onTap: () {
                              Get.find<CategoryController>().changeSelectedIndex(index);
                              Get.find<CategoryController>().getCategoryWiseProductList(categoryController.categoryList[index].id);
                            },
                            child: CategoryItem(
                              title: _category.name,
                              icon: _category.image,
                              isSelected: categoryController.categorySelectedIndex == index,
                            ),
                          );

                        },
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_MEDIUM_BORDER),

                    !categoryController.isCategory? categoryController.categoriesProductList.length != 0?
                    Expanded(child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${'all_product_from'.tr}', style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Expanded(
                                child: Text(' ${categoryController.categoryList[categoryController.categorySelectedIndex].name}',
                                  textAlign: TextAlign.start,
                                  maxLines:3,
                                  style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                childAspectRatio: 1/2,
                              ),
                              padding: EdgeInsets.all(0),
                              itemCount: categoryController.categoriesProductList.length,
                              itemBuilder: (context, index) {

                              return ItemCardWidget(categoriesProduct: categoryController.categoriesProductList[index], index: index);
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT)
                      ],
                    )):Expanded(child: NoDataScreen()): Expanded(child: ProductShimmer()),
                  ]) : NoDataScreen();
                },
              ),
              ProductSearchDialog(),

            ],
          )),
        ],
      ),
    );
  }

}



