import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/brand_controller.dart';
import 'package:cimapos/controller/category_controller.dart';
import 'package:cimapos/controller/product_controller.dart';
import 'package:cimapos/controller/supplier_controller.dart';
import 'package:cimapos/controller/unit_controller.dart';
import 'package:cimapos/data/model/response/product_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_button.dart';
import 'package:cimapos/view/base/custom_drawer.dart';
import 'package:cimapos/view/base/custom_header.dart';
import 'package:cimapos/view/base/custom_snackbar.dart';
import 'package:cimapos/view/screens/product_setup_screen/widget/product_general_info.dart';
import 'package:cimapos/view/screens/product_setup_screen/widget/product_price_info.dart';

class AddProductScreen extends StatefulWidget {
  final Products product;
  const AddProductScreen({Key key, this.product}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> with TickerProviderStateMixin{
  TabController _tabController;
  int selectedIndex = 0;
  bool update;

  Future<void> _loadData() async {
    Get.find<CategoryController>().getCategoryList(1, product: widget.product, reload: true);
    Get.find<BrandController>().getBrandList(1, product: widget.product, reload: true);
    Get.find<UnitController>().getUnitList(1,  product: widget.product);
    Get.find<SupplierController>().getSupplierList(1,  product: widget.product,reload: true);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    update = widget.product != null;
    if(update){
      _loadData();
      Get.find<ProductController>().productSellingPriceController.text = widget.product.sellingPrice.toString();
      Get.find<ProductController>().productPurchasePriceController.text = widget.product.purchasePrice.toString();
      Get.find<ProductController>().productTaxController.text = widget.product.tax.toString();
      Get.find<ProductController>().productDiscountController.text = widget.product.discount.toString();
      Get.find<ProductController>().productSkuController.text = widget.product.productCode;
      Get.find<ProductController>().productStockController.text = widget.product.quantity.toString();
      Get.find<ProductController>().productNameController.text = widget.product.title;
    }else{
      Get.find<ProductController>().productSellingPriceController.clear();
      Get.find<ProductController>().productPurchasePriceController.clear();
      Get.find<ProductController>().productTaxController.clear();
      Get.find<ProductController>().productDiscountController.clear();
      Get.find<ProductController>().productSkuController.clear();
      Get.find<ProductController>().productStockController.clear();
      Get.find<ProductController>().productNameController.clear();
      Get.find<BrandController>().setBrandEmpty();
      Get.find<CategoryController>().setCategoryAndSubCategoryEmpty();
      Get.find<UnitController>().setUnitEmpty();

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: CustomDrawer(),

      appBar: CustomAppBar(),

      body: Column( children: [
        CustomHeader(title: 'add_product'.tr, headerImage: Images.add_new_category),

        Center(
          child: Container(
            width: 1170,
            color: Theme.of(context).cardColor,
            child: TabBar(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              controller: _tabController,
              labelColor: Theme.of(context).secondaryHeaderColor,
              unselectedLabelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).secondaryHeaderColor,
              indicatorWeight: 3,
              unselectedLabelStyle: fontSizeRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w400,
              ),
              labelStyle: fontSizeRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(text: 'general_info'.tr),
                Tab(text: 'price_info'.tr),
              ],
            ),
          ),
        ),

        Expanded(child: TabBarView(
          controller: _tabController,
          children: [
            ProductGeneralInfo(product: widget.product),
            ProductPriceInfo(),
          ],
        )),
      ]),

      bottomNavigationBar:
      GetBuilder<ProductController>(
        builder: (productController) {
          return Container(height: 70,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child:(productController.selectionTabIndex ==0 ||
                productController.selectionTabIndex == 1)?
            CustomButton(buttonText: 'next'.tr,onPressed: (){
              _tabController.animateTo((_tabController.index + 1) % 2);
              selectedIndex = _tabController.index + 1;
              productController.setIndexForTabBar(selectedIndex);
            },):Row(children: [
              Expanded(
                child: CustomButton(
                  buttonColor: Theme.of(context).hintColor,
                  buttonText: 'back'.tr,onPressed: (){
                  _tabController.animateTo((_tabController.index + 1) % 2);
                  selectedIndex = _tabController.index + 1;
                  productController.setIndexForTabBar(selectedIndex);
                },),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),



              GetBuilder<CategoryController>(
                builder: (categoryController) {
                  return Expanded(
                    child: CustomButton(buttonText: update? 'update'.tr : 'save'.tr,
                      onPressed: (){
                        String  sellingPrice =  productController.productSellingPriceController.text.trim();
                        String  purchasePrice =  productController.productPurchasePriceController.text.trim();
                        String  tax =  productController.productTaxController.text.trim();
                        String  discount =  productController.productDiscountController.text.trim();
                        String categoryId = categoryController.categoryList[categoryController.categoryIndex-1].id.toString();
                        String subCategoryId = Get.find<CategoryController>().subCategoryIndex.toString();
                        String unitId = Get.find<UnitController>().unitIndex.toString();
                        int brandId = Get.find<BrandController>().brandIndex;
                        int supplierId = Get.find<SupplierController>().supplierIndex;
                        String productName = productController.productNameController.text.trim();
                        String productCode = productController.productSkuController.text.trim();
                        String productQuantity = productController.productStockController.text.trim();
                        String selectedDiscountType = productController.selectedDiscountType;

                        if(sellingPrice.isEmpty){
                          showCustomSnackBar('selling_price_required'.tr);
                        }else if(purchasePrice.isEmpty){
                          showCustomSnackBar('purchase_price_required'.tr);
                        }else if(tax.isEmpty){
                          showCustomSnackBar('tax_price_required'.tr);
                        }else{
                          Products product = Products(
                            id: update? widget.product.id : null,
                            title: productName,
                            sellingPrice:  double.parse(sellingPrice),
                            purchasePrice: double.parse(purchasePrice),
                            tax: double.parse(tax),
                            discount: double.parse(discount),
                            discountType: selectedDiscountType,
                            unitType: int.parse(unitId),
                            productCode: productCode,
                            quantity: int.parse(productQuantity),
                          );
                          productController.addProduct(product,categoryId,subCategoryId, brandId, supplierId, update);
                        }
                      },),
                  );
                }
              )
            ],),
          );
        }
      ),
    );
  }
}

