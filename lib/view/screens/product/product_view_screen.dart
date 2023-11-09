import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/controller/supplier_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_search_field.dart';
import 'package:six_pos/view/base/secondary_header_view.dart';
import 'package:six_pos/view/screens/product/widget/product_list_view.dart';
import 'package:six_pos/view/screens/product/widget/supplier_product_list.dart';

class ProductScreen extends StatefulWidget {
  final bool isSupplier;
  final int supplierId;
  const ProductScreen({Key key, this.isSupplier = false, this.supplierId}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    if(widget.isSupplier){
      Get.find<SupplierController>().getSupplierProductList(1,widget.supplierId);
    }else{
      Get.find<ProductController>().getProductList(1, reload: true);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(),
      appBar:  CustomAppBar(isBackButtonExist: true),
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
                child: Column(children: [
                  CustomHeader(title:  'product_list'.tr , headerImage: Images.people_icon),

                GetBuilder<ProductController>(
                    builder: (searchProductController) {
                      return Padding(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                        child: CustomSearchField(
                          controller: searchController,
                          hint: 'search_product_by_name_or_barcode'.tr,
                          prefix: Icons.search,
                          iconPressed: () => (){},
                          onSubmit: (text) => (){},
                          onChanged: (value){
                            if(value != ''){
                              searchProductController.getSearchProductList(value);
                            }
                            },
                          isFilter: false,
                        ),);}),

                  SecondaryHeaderView(key: UniqueKey()),
                  widget.isSupplier? SupplierProductListView(supplierId: widget.supplierId, scrollController: _scrollController,) :
                  ProductListView(scrollController: _scrollController,)

                ],),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 70 || oldDelegate.minExtent != 70 || child != oldDelegate.child;
  }
}