import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/brand_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/brand_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
class AddNewBrand extends StatefulWidget {
  final Brands brand;
  const AddNewBrand({Key key, this.brand}) : super(key: key);

  @override
  State<AddNewBrand> createState() => _AddNewBrandState();
}

class _AddNewBrandState extends State<AddNewBrand> {
  final TextEditingController _brandController = TextEditingController();
  final FocusNode _brandFocusNode = FocusNode();

  bool update;

  @override
  void initState() {
    super.initState();
    update = widget.brand != null;
    if(update){
      _brandController.text = widget.brand.name;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BrandController>(
          builder: (brandController) {
            return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
              CustomAppBar(isBackButtonExist: true,),

              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                  CustomHeader(title: 'add_brand'.tr, headerImage: Images.add_new_category),

                  Text('brand_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  CustomTextField(
                    controller: _brandController,
                    focusNode: _brandFocusNode,
                    hintText: 'brand_name_hint'.tr,),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                  Text('brand_image'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                  Align(alignment: Alignment.center, child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                      child: brandController.brandImage != null ?  Image.file(File(brandController.brandImage.path),
                        width: 150, height: 120, fit: BoxFit.cover,
                      ) :widget.brand!=null? FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: '${Get.find<SplashController>().baseUrls.brandImageUrl}/${widget.brand.image != null ? widget.brand.image : ''}',
                        height: 120, width: 150, fit: BoxFit.cover,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                            height: 120, width: 150, fit: BoxFit.cover),
                      ):Image.asset(Images.placeholder,height: 120,
                        width: 150, fit: BoxFit.cover,),
                    ),
                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => brandController.pickImage(false),
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
                  ])),

                ],),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

              brandController.isLoading?
              Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width/2-30,
                        vertical: Dimensions.PADDING_SIZE_LARGE),
                    child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      width: 30,height: 30,child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),),
                  ),
                ],
              ):
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                child: CustomButton(buttonText: update? 'update'.tr : 'save'.tr,  onPressed: (){
                  int brandId  =  update? widget.brand.id : null;
                  String brandName  =  _brandController.text.trim();
                  brandController.addBrand(brandName, brandId, update);
                },),
              ),


            ],);
          }
      ),
    );
  }
}
