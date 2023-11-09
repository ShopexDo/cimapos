import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/cart_model.dart';
import 'package:six_pos/data/model/response/categoriesProductModel.dart';
import 'package:six_pos/data/model/response/product_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_image.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
class SearchedProductItemWidget extends StatelessWidget {
  final Products product;
  const SearchedProductItemWidget({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<CartController>(
        builder: (cartController) {
          return InkWell(
            onTap: (){
              if(product.quantity<1){
                showCustomSnackBar('stock_out'.tr);
              }else{
                CartModel cartModel = CartModel(product.sellingPrice, product.discount, 1, product.tax, CategoriesProduct(
                    id: product.id,title: product.title,productCode: product.productCode,unitType: product.unitType,unitValue: product.unitValue,
                    image: product.image, sellingPrice: product.sellingPrice, purchasePrice: product.sellingPrice,discountType: product.discountType,
                    discount: product.discount,tax: product.tax,quantity: product.quantity
                ));
                cartController.addToCart(cartModel);
              }

            },
            child: Container(child: Row(children: [
              Container(width: Dimensions.PRODUCT_IMAGE_SIZE,height: Dimensions.PRODUCT_IMAGE_SIZE,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_BORDER),
                  child: CustomImage(
                    fit: BoxFit.cover,
                    placeholder: Images.placeholder,
                    image: '${Get.find<SplashController>().baseUrls.productImageUrl}/${product.image}',
                  ),
                ),
              ),),
              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
              Expanded(child: Text(product.title, style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                maxLines: 1,overflow: TextOverflow.ellipsis,))
            ])),
          );
        }
      ),
    );
  }
}
