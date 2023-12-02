
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/unit_controller.dart';
import 'package:cimapos/data/model/response/unit_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_app_bar.dart';
import 'package:cimapos/view/base/custom_button.dart';
import 'package:cimapos/view/base/custom_header.dart';
import 'package:cimapos/view/base/custom_text_field.dart';
class AddNewUnit extends StatefulWidget {
  final Units unit;
  const AddNewUnit({Key key, this.unit}) : super(key: key);

  @override
  State<AddNewUnit> createState() => _AddNewUnitState();
}

class _AddNewUnitState extends State<AddNewUnit> {
  bool update;
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _unitFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    update = widget.unit != null;
    if(update){
      _unitController.text = widget.unit.unitType;
    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: GetBuilder<UnitController>(
          builder: (unitController) {
            return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
              CustomAppBar(isBackButtonExist: true,),

              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
              CustomHeader(title: update? 'update_unit'.tr : 'add_unit'.tr, headerImage: Images.product_unit),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [


                  Text('unit_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  CustomTextField(
                    controller: _unitController,
                    focusNode: _unitFocusNode,
                    hintText: 'unit_name_hint'.tr,),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                ],),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

              unitController.isLoading?
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
                  String unitName  =  _unitController.text.trim();
                  int unitId = update ? widget.unit.id : null;
                  unitController.addUnit(unitName, unitId, update);
                },),
              ),


            ],);
          }
      ),
    ));
  }
}
