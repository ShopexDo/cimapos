import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/cart_model.dart';
import 'package:six_pos/data/model/response/categoriesProductModel.dart';
import 'package:six_pos/helper/price_converter.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_image.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
class ItemCardWidget extends StatelessWidget {
  final int index;
  final CategoriesProduct categoriesProduct;
  const ItemCardWidget({Key key, this.categoriesProduct, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return InkWell(
          onTap: (){
            if(categoriesProduct.quantity<1){
              showCustomSnackBar('stock_out'.tr);
            }else{
              CartModel cartModel = CartModel(categoriesProduct.sellingPrice, categoriesProduct.discount, 1, categoriesProduct.tax, categoriesProduct);
              cartController.addToCart(cartModel);
            }

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_BORDER),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.03),
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                    ),
                    width: Dimensions.PRODUCT_IMAGE_SIZE_ITEM,height: Dimensions.PRODUCT_IMAGE_SIZE_ITEM,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                      child: CustomImage(image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${categoriesProduct.image}',
                          placeholder: Images.placeholder,
                          fit: BoxFit.cover,
                          width: Dimensions.PRODUCT_IMAGE_SIZE_ITEM,height: Dimensions.PRODUCT_IMAGE_SIZE_ITEM),
                    ),),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(height: 50,
                  child: Text(categoriesProduct.title, maxLines: 3,overflow: TextOverflow.ellipsis,
                      style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),textAlign: TextAlign.center),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_BORDER),
                categoriesProduct.discount>0 ?
                Text(PriceConverter.priceWithSymbol(categoriesProduct.sellingPrice,),
                  style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor,decoration: TextDecoration.lineThrough),):SizedBox(),
                SizedBox(height: Dimensions.PADDING_SIZE_BORDER),


                Text(PriceConverter.convertPrice(context, categoriesProduct.sellingPrice, discount: categoriesProduct.discount ,discountType : categoriesProduct.discountType),
                  style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
              ],),),
        );
      }
    );
  }
}
