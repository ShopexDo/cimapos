import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/brand_controller.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/controller/unit_controller.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';


class ProductGeneralInfo extends StatefulWidget {
  final Products product;
  const ProductGeneralInfo({Key key, this.product}) : super(key: key);

  @override
  State<ProductGeneralInfo> createState() => _ProductGeneralInfoState();
}

class _ProductGeneralInfoState extends State<ProductGeneralInfo> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'product_name_hint'.tr,
                        controller: productController.productNameController
                      ),
                      title: 'product_name'.tr,
                      requiredField: true,
                    ),

                    GetBuilder<BrandController>(
                        builder: (brandController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                            child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_brand'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                child: DropdownButton<int>(
                                  value: brandController.brandIndex,
                                  items: brandController.brandIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text( value != 0?
                                        brandController.brandList[(brandController.brandIds.indexOf(value) -1)].name: 'select'.tr ));}).toList(),
                                  onChanged: (int value) {
                                    brandController.setBrandIndex(value, true);
                                  },
                                  isExpanded: true, underline: SizedBox(),),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            ],),),
                          );
                        }
                    ),

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

                    GetBuilder<CategoryController>(
                        builder: (categoryController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                            child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_sub_category'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                child: DropdownButton<int>(
                                  value: categoryController.subCategoryIndex ?? 0,
                                  items: categoryController.subCategoryIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text( value != 0?
                                        categoryController.subCategoryList[(categoryController.subCategoryIds.indexOf(value) -1)].name: 'select'.tr ));}).toList(),
                                  onChanged: (int value) {
                                    categoryController.setSubCategoryIndex(value, true);
                                  },
                                  isExpanded: true, underline: SizedBox(),),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            ],),),
                          );
                        }
                    ),

                    GetBuilder<UnitController>(
                        builder: (unitController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                            child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_unit'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                child: DropdownButton<int>(
                                  value: unitController.unitIndex,
                                  items: unitController.unitIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value != 0?
                                        unitController.unitList[(unitController.unitIds.indexOf(value) -1)].unitType: 'select'.tr ));}).toList(),
                                  onChanged: (int value) {
                                    unitController.setUnitIndex(value, true);
                                  },
                                  isExpanded: true, underline: SizedBox(),),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            ],),),
                          );
                        }
                    ),

                    CustomFieldWithTitle(
                      onTap: (){
                        var rng = new Random();
                        var code = rng.nextInt(900000) + 100000;
                        productController.productSkuController.text = code.toString();
                      },
                      isSKU: true,
                      customTextField: CustomTextField(hintText: 'sku_hint'.tr,
                      controller: productController.productSkuController),
                      title: 'sku'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'stock_quantity_hint'.tr,
                      controller: productController.productStockController,
                        inputType: TextInputType.number,
                      ),
                      title: 'stock_quantity'.tr,
                      requiredField: true,
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                      child: Text('product_image'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                    GetBuilder<ProductController>(
                      builder: (productController) {
                        return  Align(alignment: Alignment.center, child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            child: productController.productImage != null ?  Image.file(File(productController.productImage.path),
                              width: 150, height: 120, fit: BoxFit.cover,
                            ) :widget.product!=null? FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              image: '${Get.find<SplashController>().baseUrls.productImageUrl}/${widget.product.image != null ? widget.product.image : ''}',
                              height: 120, width: 150, fit: BoxFit.cover,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                  height: 120, width: 150, fit: BoxFit.cover),
                            ):Image.asset(Images.placeholder,height: 120,
                              width: 150, fit: BoxFit.cover,),
                          ),
                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: () => productController.pickImage(false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                  border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2, color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.camera_alt, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ]));
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
