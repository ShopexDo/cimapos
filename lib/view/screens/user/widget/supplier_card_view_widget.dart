import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/controller/supplier_controller.dart';
import 'package:six_pos/data/model/response/supplier_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/animated_custom_dialog.dart';
import 'package:six_pos/view/base/custom_image.dart';
import 'package:six_pos/view/base/custom_ink_well.dart';
import 'package:six_pos/view/base/logout_dialog.dart';
import 'package:six_pos/view/screens/product/product_view_screen.dart';
import 'package:six_pos/view/screens/user/add_new_suppliers_and_customers.dart';
import 'package:six_pos/view/screens/user/supplier_transaction_screen.dart';
import 'package:six_pos/view/screens/user/widget/custom_divider.dart';
class SupplierCardViewWidget extends StatelessWidget {
  final Suppliers supplier;
  const SupplierCardViewWidget({Key key, this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          horizontal: Dimensions.PADDING_SIZE_SMALL,
        ),
        child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Card(child: CustomImage(
                    image: '${Get.find<SplashController>().configModel.baseUrls.supplierImageUrl}/${supplier.image}',
                    width: 50, height: 50, fit: BoxFit.cover, placeholder: Images.profile_place_holder,
                  )),
                  title: Text(supplier.name),
                  subtitle: Text('${'total_products'.tr} ${supplier.productCount}'),

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: CustomInkWell(child: Image.asset(Images.edit_icon, height: 30), onTap: () {
                  Get.to(AddNewSuppliersOrCustomer(supplier: supplier));

                },),
              ),

              GetBuilder<SupplierController>(
                builder: (supplierController) {
                  return CustomInkWell(child: Image.asset(Images.delete_icon, height: 30), onTap: () {
                    showAnimatedDialog(context,
                        CustomDialog(
                          delete: true,
                          icon: Icons.exit_to_app_rounded, title: '',
                          description: 'are_you_sure_you_want_to_delete_supplier'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                          onTapTrue:() {
                            supplierController.deleteSupplier(supplier.id);
                          },
                          onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                        ),
                        dismissible: false,
                        isFlip: true);
                  },);
                }
              ),
            ],
          ),

          CustomDivider(color: Theme.of(context).hintColor),

          Row(children: [
            Container(child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding( padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Text('contact_information'.tr, style: fontSizeMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
              ),

              Padding( padding: EdgeInsets.only(bottom: 2),
                child: Text(supplier.email, style: fontSizeRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                )),
              ),

              Padding( padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(supplier.mobile, style: fontSizeRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                )),
              ),
            ],),),
            Spacer(),
            Container(child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
              InkWell(
                onTap: ()=> Get.to(SupplierTransactionListScreen(supplierId: supplier.id, supplier: supplier)),
                child: Row(children: [
                  Text('${'transactions'.tr}', style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.item))
                ],),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),



              InkWell(
                onTap: ()=> Get.to(ProductScreen(isSupplier: true,supplierId: supplier.id)),
                child: Row(children: [
                  Text('${'products'.tr}',style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.stock,color: Theme.of(context).secondaryHeaderColor,))
                ],),
              ),
            ],),)
          ],)
        ]),
      ),
    ],);
  }
}
