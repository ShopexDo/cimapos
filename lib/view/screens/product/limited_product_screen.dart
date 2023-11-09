import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/secondary_header_view.dart';
import 'package:six_pos/view/screens/product/widget/limited_product_list_view.dart';


class LimitedStockProductScreen extends StatefulWidget {
  const LimitedStockProductScreen({Key key}) : super(key: key);

  @override
  State<LimitedStockProductScreen> createState() => _LimitedStockProductScreenState();
}

class _LimitedStockProductScreenState extends State<LimitedStockProductScreen> {
  final ScrollController _scrollController = ScrollController();



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            Get.find<ProductController>().getLimitedStockProductList(1, reload: true);
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  CustomHeader(title:  'product_list'.tr , headerImage: Images.people_icon),
                  SizedBox(height: Dimensions.PADDING_SIZE_BORDER),
                  SecondaryHeaderView(key: UniqueKey(), isLimited: true),
                  LimitedStockProductListView(scrollController: _scrollController, isHome: false,)

                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
