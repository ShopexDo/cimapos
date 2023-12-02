import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/customer_controller.dart';
import 'package:cimapos/controller/supplier_controller.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_drawer.dart';
import 'package:cimapos/view/base/custom_header.dart';
import 'package:cimapos/view/base/custom_search_field.dart';
import 'package:cimapos/view/base/secondary_header_view.dart';
import 'package:cimapos/view/screens/user/widget/customer_list_view.dart';
import 'package:cimapos/view/screens/user/widget/supplier_list_view.dart';

class SupplierOrCustomerList extends StatefulWidget {
  final bool isCustomer;
  const SupplierOrCustomerList({Key key, this.isCustomer = false}) : super(key: key);

  @override
  State<SupplierOrCustomerList> createState() => _SupplierOrCustomerListState();
}

class _SupplierOrCustomerListState extends State<SupplierOrCustomerList> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    Get.find<SupplierController>().getSupplierList(1);
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
                child:  Column(children: [
                  CustomHeader(title: widget.isCustomer? 'customer_list'.tr : 'supplier_list'.tr, headerImage: Images.people_icon),

                  widget.isCustomer?
                  GetBuilder<CustomerController>(
                      builder: (customerController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal : Dimensions.PADDING_SIZE_DEFAULT,
                              vertical: Dimensions.PADDING_SIZE_SMALL),
                          child: CustomSearchField(
                            controller: searchController,
                            hint: 'search_customer'.tr,
                            prefix: Icons.search,
                            iconPressed: () => (){},
                            onSubmit: (text) => (){},
                            onChanged: (value){
                              customerController.filterCustomerList(value);
                            },
                            isFilter: false,
                          ),
                        );
                      }
                  ): GetBuilder<SupplierController>(
                      builder: (supplierController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal : Dimensions.PADDING_SIZE_DEFAULT,
                              vertical: Dimensions.PADDING_SIZE_SMALL),
                          child: CustomSearchField(
                            controller: searchController,
                            hint: 'search_supplier'.tr,
                            prefix: Icons.search,
                            iconPressed: () => (){},
                            onSubmit: (text) => (){},
                            onChanged: (value){
                              supplierController.searchSupplier(value);
                            },
                            isFilter: false,
                          ),
                        );
                      }
                  ),

                  SecondaryHeaderView(key: UniqueKey(), title:widget.isCustomer? 'customer_info'.tr : 'supplier_info'.tr, showOwnTitle: true, isSerial: true,),
                  widget.isCustomer? CustomerListView(scrollController: _scrollController,) : SupplierListView(scrollController: _scrollController,)

                ]),
              )
            ],
          ),
        ),
      ),


    );
  }
}
