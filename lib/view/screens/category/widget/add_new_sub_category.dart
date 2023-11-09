import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/category_controller.dart';
import 'package:six_pos/data/model/response/sub_category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
class AddNewSubCategory extends StatefulWidget {
  final SubCategories subCategory;
  const AddNewSubCategory({Key key, this.subCategory}) : super(key: key);

  @override
  State<AddNewSubCategory> createState() => _AddNewSubCategoryState();
}

class _AddNewSubCategoryState extends State<AddNewSubCategory> {
  final TextEditingController _subCategoryController = TextEditingController();
  final FocusNode _subCategoryFocusNode = FocusNode();
  int parentCategoryId = 0;
  String  parentCategoryName = '';
  bool update;
  @override
  void initState() {
    super.initState();

    update = widget.subCategory != null;
    if(update){
      _subCategoryController.text = widget.subCategory.name;
      parentCategoryId = widget.subCategory.parentId;
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: GetBuilder<CategoryController>(
          builder: (categoryController) {
            return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

              CustomHeader(title: update? 'update_sub_category'.tr : 'add_sub_category'.tr, headerImage: Images.add_new_category),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

                  Text('select_category_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
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
                          categoryController.categoryList[(categoryController.categoryIds.indexOf(value) -1)].name: update? categoryController.selectedCategoryName: 'select'.tr ));}).toList(),
                      onChanged: (int value) {
                        print('==here is category index value==>$value');
                        categoryController.setCategoryIndex(value, true);
                       },
                      isExpanded: true, underline: SizedBox(),),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                  Text('sub_category_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  CustomTextField(

                    controller: _subCategoryController,
                    focusNode: _subCategoryFocusNode,
                    hintText: 'sub_category_hint'.tr,),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                ],),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

              categoryController.isSub?
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
                  String subCategoryName  = _subCategoryController.text.trim();
                  int parentId = update? widget.subCategory.parentId: categoryController.categoryList[(categoryController.categoryIndex-1)].id;
                  int id = update? widget.subCategory.id : null;
                  categoryController.addSubCategory(subCategoryName, id,parentId, update);
                },),
              ),


            ],);
          }
      ),
    );
  }
}
