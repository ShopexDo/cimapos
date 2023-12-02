import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/category_controller.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'package:cimapos/data/model/response/category_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_button.dart';
import 'package:cimapos/view/base/custom_header.dart';
import 'package:cimapos/view/base/custom_text_field.dart';
class AddNewCategory extends StatefulWidget {
  final Categories category;
  const AddNewCategory({Key key, this.category}) : super(key: key);

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  final TextEditingController _categoryController = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();
   bool update;
   @override
  void initState() {
    super.initState();

    update = widget.category != null;
    if(update){
      _categoryController.text = widget.category.name;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
            CustomAppBar(isBackButtonExist: true,),

            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                CustomHeader(title: 'add_category'.tr, headerImage: Images.add_new_category),

                Text('category_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                CustomTextField(
                controller: _categoryController,
                focusNode: _categoryFocusNode,
                hintText: 'category_name'.tr,),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                Text('category_image'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Align(alignment: Alignment.center, child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    child: categoryController.categoryImage != null ?  Image.file(File(categoryController.categoryImage.path),
                      width: 150, height: 120, fit: BoxFit.cover,
                    ) :widget.category!=null? FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      image: '${Get.find<SplashController>().baseUrls.categoryImageUrl}/${widget.category.image != null ? widget.category.image : ''}',
                      height: 120, width: 150, fit: BoxFit.cover,
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                          height: 120, width: 150, fit: BoxFit.cover),
                    ):Image.asset(Images.placeholder,height: 120,
                      width: 150, fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => categoryController.pickImage(false),
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

            categoryController.isLoading?
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
              child: CustomButton(buttonText: update? 'update'.tr :'save'.tr,  onPressed: (){
                int categoryId  =  update? widget.category.id : null;
                String categoryName  =  _categoryController.text.trim();
                categoryController.addCategory(categoryName, categoryId, update);
              },),
            ),


          ],);
        }
      ),
    );
  }
}
