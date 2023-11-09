import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/controller/supplier_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';


class ProductPriceInfo extends StatefulWidget {
  const ProductPriceInfo({Key key}) : super(key: key);

  @override
  State<ProductPriceInfo> createState() => _ProductPriceInfoState();
}

class _ProductPriceInfoState extends State<ProductPriceInfo> {

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
                      customTextField: CustomTextField(hintText: 'selling_price_hint'.tr,
                      controller: productController.productSellingPriceController,
                        inputType: TextInputType.number,
                      ),
                      title: 'selling_price'.tr,
                      requiredField: true,
                    ),
                    CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'purchase_price_hint'.tr,
                      controller: productController.productPurchasePriceController,
                        inputType: TextInputType.number,
                      ),
                      title: 'purchase_price'.tr,
                      requiredField: true,
                    ),


                    Container(padding: EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT, 0, Dimensions.PADDING_SIZE_DEFAULT, 0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('discount_type'.tr,
                          style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          ),
                          child: DropdownButton<String>(
                            value: productController.discountTypeIndex == 0 ? 'percent' : 'amount',
                            items: <String>['percent', 'amount'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              productController.setSelectedDiscountType(value);
                              productController.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);

                            },
                            isExpanded: true,
                            underline: SizedBox(),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                    CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'discount_hint'.tr,
                      controller: productController.productDiscountController,
                        inputType: TextInputType.number,
                      ),
                      title: 'discount_percentage'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'tax_hint'.tr,
                      controller: productController.productTaxController,
                        inputType: TextInputType.number,
                      ),
                      title: 'tax'.tr,
                      requiredField: true,
                    ),


                    GetBuilder<SupplierController>(
                        builder: (supplierController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                            child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_supplier'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                child: DropdownButton<int>(

                                  value: supplierController.supplierIndex,
                                  items: supplierController.supplierIds.map((int value) {
                                    return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text( value != 0?
                                        supplierController.supplierList[(supplierController.supplierIds.indexOf(value) -1)].name: 'select'.tr ));}).toList(),
                                  onChanged: (int value) {
                                    supplierController.setSupplierIndex(value, true);
                                  },
                                  isExpanded: true, underline: SizedBox(),),),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            ],),),
                          );
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
