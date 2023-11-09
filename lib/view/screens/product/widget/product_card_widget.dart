import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/product_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/helper/price_converter.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_image.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/product/bar_code_generator.dart';
import 'package:six_pos/view/screens/product/widget/product_quantity_update_dialog.dart';
import 'package:six_pos/view/screens/product_setup_screen/add_product_screen.dart';
import 'package:six_pos/view/screens/user/widget/custom_divider.dart';
class ProductCardViewWidget extends StatelessWidget {
  final Products product;
  const ProductCardViewWidget({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
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
                      Text(product.title, style: fontSizeRegular.copyWith(),maxLines: 2,overflow: TextOverflow.ellipsis),
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
              children: [Expanded(
                child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Padding( padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: Text('${'purchase_price'.tr} : ${PriceConverter.priceWithSymbol(product.sellingPrice)}', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                  ),

                  Padding( padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Text('${'selling_price'.tr} : ${PriceConverter.priceWithSymbol(product.sellingPrice)}', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                  ),
                ],),),
              ),

              Expanded(
                child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
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

            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              InkWell(
                onTap: (){
                  Get.to(BarCodeGenerateScreen(product: product));
                  Get.find<ProductController>().setBarCodeQuantity(4);

                  },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Container(width: Dimensions.ICON_SIZE_SMALL, height: Dimensions.ICON_SIZE_SMALL,
                      child: Image.asset(Images.bar_code)),
                ),
              ),

              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProductScreen(product: product))),
                child: Container(width: Dimensions.ICON_SIZE_SMALL,height: Dimensions.ICON_SIZE_SMALL,
                    child: Image.asset(Images.edit_icon)),
              ),


              GetBuilder<ProductController>(
                builder: (productController) {
                  return InkWell(
                    onTap: (){
                      showAnimatedDialog(context,
                          CustomDialog(
                            delete: true,
                            icon: Icons.exit_to_app_rounded, title: '',
                            description: 'are_you_sure_you_want_to_delete_product'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                            onTapTrue:() {
                              productController.deleteProduct(product.id);
                            },
                            onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                          ),
                          dismissible: false,
                          isFlip: true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: Container(width: Dimensions.ICON_SIZE_SMALL,height: Dimensions.ICON_SIZE_SMALL,
                          child: Image.asset(Images.delete_icon)),
                    ),
                  );
                }
              ),
            ],)
          ]),
        ),
        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      ],),
    );
  }
}
