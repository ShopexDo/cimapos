import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/limite_stock_product_model.dart';
import 'package:six_pos/helper/price_converter.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_image.dart';
import 'package:six_pos/view/screens/product/widget/product_quantity_update_dialog.dart';
import 'package:six_pos/view/screens/user/widget/custom_divider.dart';
class LimitedStockProductCardViewWidget extends StatelessWidget {
  final StockLimitedProducts product;
  final bool isHome;
  final int index;
  const LimitedStockProductCardViewWidget({Key key, this.product, this.isHome = false, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHome? Container(height: 40,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        children: [
          Row(
            children: [
              Text('${index + 1}.', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),
              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
              Expanded(child: Text('${product.name}', maxLines: 1,overflow: TextOverflow.ellipsis,
                  style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor))),
              Spacer(),
              Text('${product.quantity}', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),

            ],
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          CustomDivider(color: Theme.of(context).hintColor,height: .5)
        ],
      ),
    )
        :Column(children: [
      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          horizontal: Dimensions.PADDING_SIZE_SMALL,
        ),
        child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_BORDER),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER),
                    color: Theme.of(context).primaryColor.withOpacity(.12),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER),
                      child: CustomImage(
                        image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${product.image}',
                        width: 60, height: 60, fit: BoxFit.cover, placeholder: Images.placeholder,
                      ))),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: fontSizeRegular.copyWith(),maxLines: 2,overflow: TextOverflow.ellipsis),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('${'code'.tr} : ${product.productCode}', style: fontSizeRegular.copyWith(
                              color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_SMALL)),
                        ),
                        GetBuilder<ProductController>(
                          builder: (productController) {
                            return InkWell(
                              onTap: (){
                                showAnimatedDialog(context,
                                    ProductQuantityUpdateDialog(
                                      onYesPressed: (){
                                        productController.updateProductQuantity(product.id, int.parse(productController.productQuantityController.text.trim()));

                                      },
                                    ),
                                    dismissible: false,
                                    isFlip: false);
                              },
                              child: Container(child: Row(children: [
                                Icon(Icons.add_circle),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE,vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    child: Text('${product.quantity}'),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER),

                                    ),),
                                ),

                              ]),),
                            );
                          }
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            child: CustomDivider(color: Theme.of(context).hintColor),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Padding( padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: Text('${'purchase_price'.tr} : ${PriceConverter.priceWithSymbol(product.sellingPrice)}', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                  ),
                  Text('${'supplier_information'.tr}', style: fontSizeRegular.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                  )),

                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  product.supplier != null?
                  Padding( padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: Text('${product.supplier.name??''}', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                  ):SizedBox(),

                  product.supplier != null?
                  Padding( padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Text('${product.supplier.mobile??''}', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                  ):SizedBox(),
                ],),),
              )
            ],),
        ]),
      ),
      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
    ],);
  }
}
