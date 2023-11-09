import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/cart_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/controller/theme_controller.dart';
import 'package:six_pos/data/model/response/cart_model.dart';
import 'package:six_pos/helper/price_converter.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_divider.dart';
import 'package:six_pos/view/base/custom_image.dart';



class ItemCartWidget extends StatelessWidget {
  final CartModel cartModel;
  final int index;
  const ItemCartWidget({Key key, this.cartModel, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_BORDER),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          Get.find<CartController>().removeFromCart(index);

        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 200],
                  spreadRadius: 0.5, blurRadius: 0.3)]
          ),
          padding: const EdgeInsets.fromLTRB( Dimensions.PADDING_SIZE_EXTRA_SMALL,Dimensions.PADDING_SIZE_SMALL,0,Dimensions.PADDING_SIZE_SMALL),
          child: Column(
            children: [
              Row(children: [

                Expanded(flex: 5,
                  child: Container(child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: Dimensions.PRODUCT_IMAGE_SIZE,
                          width: Dimensions.PRODUCT_IMAGE_SIZE,
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_BORDER),
                          child: CustomImage(image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${cartModel.product.image}',
                              placeholder: Images.placeholder,
                              fit: BoxFit.cover,
                              width: Dimensions.PRODUCT_IMAGE_SIZE_ITEM,height: Dimensions.PRODUCT_IMAGE_SIZE_ITEM),),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Expanded(child: Text('${cartModel.product.title}', maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),)),
                    ],
                  ),),
                ),

                Expanded(
                  flex: 4,
                  child: GetBuilder<CartController>(
                    builder: (cartController) {
                      return Container(child: Row(children: [
                        InkWell(
                          onTap: (){
                            cartController.setQuantity(false, index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.remove_circle),
                          ),
                        ),
                        Container(width: 40,height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          ),
                          child: Center(child: Text(cartModel.quantity.toString(),
                            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),)),),
                        InkWell(
                          onTap: (){
                            cartController.setQuantity(true, index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.add_circle),
                          ),
                        ),
                      ],),);
                    }
                  ),
                ),

                Expanded(flex: 2,
                    child: Container(child: Text(PriceConverter.priceWithSymbol(cartModel.price),
                        style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)))),


              ],),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: CustomDivider(height: .4,color: Theme.of(context).hintColor.withOpacity(.5),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
