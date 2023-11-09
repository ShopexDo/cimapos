import 'dart:io';

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/data/model/response/config_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';

class InfoFieldVIew extends StatefulWidget {
  final ConfigModel configModel;
  final bool isBusinessInfo;
  const InfoFieldVIew({Key key, this.isBusinessInfo = false, this.configModel}) : super(key: key);

  @override
  State<InfoFieldVIew> createState() => _InfoFieldVIewState();
}

class _InfoFieldVIewState extends State<InfoFieldVIew> {
  TextEditingController shopNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController paginationTextController = TextEditingController();
  TextEditingController footerTextController = TextEditingController();
  TextEditingController stockLimitController = TextEditingController();
  TextEditingController vatRegistrationNoController = TextEditingController();
  String currency = '',  country = '', selectedTimeZone = '';
  @override
  void initState() {
    super.initState();
    shopNameController.text = widget.configModel.businessInfo.shopName;
    emailController.text = widget.configModel.businessInfo.shopEmail;
    phoneController.text = widget.configModel.businessInfo.shopPhone;
    addressController.text = widget.configModel.businessInfo.shopAddress;
    currency = widget.configModel.businessInfo.currency;
    Get.find<SplashController>().setValueForSelectedTimeZone(widget.configModel.businessInfo.timeZone);
    country = widget.configModel.businessInfo.country;
    paginationTextController.text = widget.configModel.businessInfo.paginationLimit;
    footerTextController.text = widget.configModel.businessInfo.footerText;
    stockLimitController.text = widget.configModel.businessInfo.stockLimit;
    vatRegistrationNoController.text = widget.configModel.businessInfo.vat;
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (shopController) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   if(!widget.isBusinessInfo) CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'enter_shop_name'.tr,
                      controller: shopNameController),
                      title: 'shop_name'.tr,
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitle(
                      title: 'vat_registration_no'.tr,
                      customTextField: CustomTextField(
                          controller: vatRegistrationNoController),
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitle(
                      title: 'country'.tr,
                      customTextField: Container(
                        padding: EdgeInsets.symmetric(horizontal : Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 0.5)
                        ),
                        child: CountryPickerDropdown(
                          initialValue: country,
                          itemBuilder: _buildDropdownItemForCountry,
                          onValuePicked: (Country country) {
                            print("${country.name}");
                          },
                        ),
                      ),
                      requiredField: true,
                    ),


                   if(!widget.isBusinessInfo) CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'enter_email_address'.tr,
                      controller: emailController),
                      title: 'email'.tr,
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitle(
                      title: 'currency'.tr,
                      customTextField: Container(
                        padding: EdgeInsets.symmetric(horizontal : Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 0.5)
                        ),
                        child: CountryPickerDropdown(
                          initialValue: country,
                          itemBuilder: _buildDropdownItemForCurrency,
                          onValuePicked: (Country country) {
                            print("${country.name}");
                          },
                        ),
                      ),
                      requiredField: true,
                    ),

                    if(!widget.isBusinessInfo) CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'enter_phone_number'.tr,
                      controller: phoneController),
                      title: 'phone'.tr,
                      requiredField: true,
                    ),



                    if(widget.isBusinessInfo)Padding(
                      padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0, Dimensions.PADDING_SIZE_DEFAULT,0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('${'time_zone'.tr}', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),
                              Text('*', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                              border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                            ),
                            child: DropdownButton<String>(
                              hint: shopController.selectedTimeZone == null ? Text('select'.tr) :
                              Text(shopController.selectedTimeZone, style: fontSizeRegular.copyWith(color: ColorResources.getTextColor()),),
                              items: shopController.timeZone.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value));}).toList(),
                              onChanged: (val) {
                                selectedTimeZone = val;
                                setState(() {
                                  shopController.setValueForSelectedTimeZone(val);
                                  },);},
                              isExpanded: true,
                              underline: SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if(!widget.isBusinessInfo) CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'enter_address'.tr, maxLines: 3,
                      controller: addressController),
                      title: 'address'.tr,
                      requiredField: true,
                    ),


                    if(widget.isBusinessInfo) CustomFieldWithTitle(
                      title: 'reorder_level'.tr,
                      customTextField: CustomTextField(
                          controller: stockLimitController),
                      requiredField: true,
                    ),



                    if(!widget.isBusinessInfo) Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_SMALL,
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'upload_shop_logo'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                          children: <TextSpan>[
                            TextSpan(text: 'ratio'.tr, style: fontSizeBold.copyWith(color: Theme.of(context).errorColor)),
                          ],
                        ),
                      ),
                    ),
                   if(!widget.isBusinessInfo) Padding(
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Align(alignment: Alignment.center, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          child: shopController.shopLogo != null ?  Image.file(File(shopController.shopLogo.path),
                            width: 150, height: 120, fit: BoxFit.cover,
                          ) :widget.configModel.businessInfo.shopLogo!=null? FadeInImage.assetNetwork(
                            placeholder: Images.placeholder,
                            image: '${Get.find<SplashController>().baseUrls.shopImageUrl}/${widget.configModel.businessInfo.shopLogo != null ? widget.configModel.businessInfo.shopLogo : ''}',
                            height: 120, width: 150, fit: BoxFit.cover,
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                height: 120, width: 150, fit: BoxFit.cover),
                          ):Image.asset(Images.placeholder,height: 120,
                            width: 150, fit: BoxFit.cover,),
                        ),
                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => shopController.pickImage(false),
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
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitle(
                      title: 'pagination_limit'.tr,
                      customTextField: CustomTextField(
                        inputType: TextInputType.number,
                          controller: paginationTextController),
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitle(
                      title: 'footer_text'.tr,
                      customTextField: CustomTextField(
                          controller: footerTextController),
                      requiredField: true,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(buttonText: shopController.isLoading? 'actualizando......'.tr : 'update'.tr,onPressed: (){
                String shopName = shopNameController.text.trim();
                String email = emailController.text.trim();
                String phone = phoneController.text.trim();
                String address = addressController.text.trim();
                String currency = widget.configModel.businessInfo.currency;
                String timeZ = selectedTimeZone;
                String selectedCountry = country;
                String pagination = paginationTextController.text.trim();
                String footer = footerTextController.text.trim();
                String stockLimit = stockLimitController.text.trim();
                String vatReg = vatRegistrationNoController.text.trim();
                BusinessInfo shop = BusinessInfo(
                  paginationLimit: pagination,
                  currency:  currency,
                  shopName: shopName,
                  shopAddress: address,
                  shopEmail: email,
                  shopPhone: phone,
                  stockLimit: stockLimit,
                  timeZone: timeZ,
                  country: selectedCountry,
                  footerText: footer,
                  vat: vatReg
                );
                if(int.parse(pagination)<1){
                  showCustomSnackBar('pagination_should_be_greater_than_0'.tr);
                }else{
                  shopController.updateShop(shop);
                }

              },),
            ),
          ],
        );
      }
    );
  }
}
Widget _buildDropdownItemForCountry(Country country) => Container(
  child: Container(
      width: MediaQuery.of(Get.context).size.width-85,
      child: Text("${country.name}")),
);

Widget _buildDropdownItemForCurrency(Country country) => Container(
  child: Container(
      width: MediaQuery.of(Get.context).size.width-85,
      child: Text("${country.currencyCode}")),
);