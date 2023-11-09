import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/customer_controller.dart';
import 'package:six_pos/controller/splash_controller.dart';
import 'package:six_pos/controller/supplier_controller.dart';
import 'package:six_pos/data/model/response/customer_model.dart';
import 'package:six_pos/data/model/response/supplier_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_button.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_field_with_title.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/custom_text_field.dart';

class AddNewSuppliersOrCustomer extends StatefulWidget {
  final bool isCustomer;
  final Suppliers supplier;
  final Customers customer;
  const AddNewSuppliersOrCustomer({Key key, this.isCustomer = false, this.supplier, this.customer}) : super(key: key);

  @override
  State<AddNewSuppliersOrCustomer> createState() => _AddNewSuppliersOrCustomerState();
}

class _AddNewSuppliersOrCustomerState extends State<AddNewSuppliersOrCustomer> {

  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierPhoneNumber = TextEditingController();
  TextEditingController supplierEmail = TextEditingController();
  TextEditingController supplierState = TextEditingController();
  TextEditingController supplierCity = TextEditingController();
  TextEditingController supplierZip = TextEditingController();
  TextEditingController supplierAddress = TextEditingController();

  bool customerUpdate, supplierUpdate;
  @override
  void initState() {
    super.initState();

    customerUpdate =  widget.customer != null;
    supplierUpdate = widget.supplier != null;
    if(customerUpdate){
      supplierNameController.text = widget.customer.name;
      supplierPhoneNumber.text = widget.customer.mobile;
      supplierEmail.text = widget.customer.email;
      supplierState.text = widget.customer.state;
      supplierCity.text = widget.customer.city;
      supplierZip.text = widget.customer.zipCode;
      supplierAddress.text = widget.customer.address;
    }else if(supplierUpdate){
      supplierNameController.text = widget.supplier.name;
      supplierPhoneNumber.text = widget.supplier.mobile;
      supplierEmail.text = widget.supplier.email;
      supplierState.text = widget.supplier.state;
      supplierCity.text = widget.supplier.city;
      supplierZip.text = widget.supplier.zipCode;
      supplierAddress.text = widget.supplier.address;
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(),

      appBar: CustomAppBar(isBackButtonExist: true),

      body: GetBuilder<SupplierController>(
        builder: (supplierController) {
          return Column(children: [
            CustomHeader(title:  widget.isCustomer && customerUpdate? 'update_customer'.tr :
            widget.isCustomer && !customerUpdate? 'add_new_customer'.tr : supplierUpdate ?
            'update_supplier'.tr : 'add_new_supplier'.tr, headerImage: Images.add_icon),

            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  CustomFieldWithTitle(
                    customTextField: CustomTextField(hintText:  widget.isCustomer?  'enter_customer_name'.tr : 'enter_supplier_name'.tr,
                      controller: supplierNameController,
                    ),
                    title: widget.isCustomer?  'customer_name'.tr :'supplier_name'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitle(
                    customTextField: CustomTextField(hintText: 'enter_phone_number'.tr,
                      controller: supplierPhoneNumber,
                      inputType: TextInputType.number,
                    ),
                    title: 'phone_number'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitle(
                    customTextField: CustomTextField(hintText: 'enter_email_address'.tr,
                      controller: supplierEmail,),
                    title: 'email'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitle(
                    customTextField: CustomTextField(hintText: 'enter_state'.tr,
                      controller: supplierState,),
                    title: 'state'.tr,
                    requiredField: true,
                  ),

                  Row(children: [
                    Expanded(child: CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'enter_city_name'.tr,
                        controller: supplierCity,),
                      title: 'city'.tr,
                      requiredField: true,
                    ),),

                    Expanded(child: CustomFieldWithTitle(
                      customTextField: CustomTextField(hintText: 'enter_zip_code'.tr,
                        controller: supplierZip,),
                      title: 'zip'.tr,
                      requiredField: true,
                    ),),
                  ]),

                  CustomFieldWithTitle(
                    customTextField: CustomTextField(hintText: 'enter_address'.tr, maxLines: 5,
                      controller: supplierAddress,
                    ),
                    title: 'address'.tr,
                    requiredField: true,
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_SMALL,
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'image'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                            children: <TextSpan>[
                              TextSpan(text: 'ratio'.tr, style: fontSizeBold.copyWith(color: Theme.of(context).errorColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  customerUpdate || widget.isCustomer?
                  GetBuilder<CustomerController>(
                    builder: (customerController) {
                      return Align(alignment: Alignment.center, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                          child: customerController.customerImage != null ?  Image.file(File(customerController.customerImage.path),
                            width: 150, height: 120, fit: BoxFit.cover,
                          ) :widget.customer!=null? FadeInImage.assetNetwork(
                            placeholder: Images.placeholder,
                            image: '${'https://test.6am.one/6pos/storage/app/public/customer'}/${widget.customer.image != null ? widget.customer.image : ''}',
                            height: 120, width: 150, fit: BoxFit.cover,
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                height: 120, width: 150, fit: BoxFit.cover),
                          ):Image.asset(Images.placeholder,height: 120,
                            width: 150, fit: BoxFit.cover,),
                        ),
                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => customerController.pickImage(false),
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
                      ]));
                    }
                  ):
                  Align(alignment: Alignment.center, child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                      child: supplierController.supplierImage != null ?  Image.file(File(supplierController.supplierImage.path),
                        width: 150, height: 120, fit: BoxFit.cover,
                      ) :widget.supplier!=null? FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: '${Get.find<SplashController>().baseUrls.supplierImageUrl}/${widget.supplier.image != null ? widget.supplier.image : ''}',
                        height: 120, width: 150, fit: BoxFit.cover,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                            height: 120, width: 150, fit: BoxFit.cover),
                      ):Image.asset(Images.placeholder,height: 120,
                        width: 150, fit: BoxFit.cover,),
                    ),
                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => supplierController.pickImage(false),
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
                ]),
              ),
            ),


            supplierController.isLoading?
            Container(height: 30,width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).cardColor,
              ),
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(buttonText:supplierUpdate || customerUpdate? 'update'.tr : 'save'.tr,onPressed: (){
                String supplierName = supplierNameController.text.trim();
                String supplierMobile = supplierPhoneNumber.text.trim();
                String supplierEmailAddress = supplierEmail.text.trim();
                String state = supplierState.text.trim();
                String city = supplierCity.text.trim();
                String zip = supplierZip.text.trim();
                String address = supplierAddress.text.trim();
                if(supplierName.isEmpty){
                  showCustomSnackBar('name_required'.tr);
                }else if(supplierMobile.isEmpty){
                  showCustomSnackBar('mobile_required'.tr);
                }else if(supplierEmailAddress.isEmpty){
                  showCustomSnackBar('email_required'.tr);
                }else if(state.isEmpty){
                  showCustomSnackBar('state_required'.tr);
                }else if(city.isEmpty){
                  showCustomSnackBar('city_required'.tr);
                }else if(zip.isEmpty){
                  showCustomSnackBar('zip_required'.tr);
                }else if(address.isEmpty){
                  showCustomSnackBar('address_required'.tr);
                }
                else{
                  Suppliers supplier = Suppliers(
                    id: supplierUpdate? widget.supplier.id: null,
                    name: supplierName,
                    mobile : supplierMobile,
                    email : supplierEmailAddress,
                    state : state,
                    city : city,
                    zipCode : zip,
                    address : address,
                  );
                  Customers customer = Customers(
                    id: customerUpdate? widget.customer.id : null,
                    name: supplierName,
                    mobile : supplierMobile,
                    email : supplierEmailAddress,
                    state : state,
                    city : city,
                    zipCode : zip,
                    address : address,
                  );

                  if(!widget.isCustomer){
                    supplierController.addSupplier(supplier,supplierUpdate);
                  }else{
                    Get.find<CustomerController>().addCustomer(customer, customerUpdate);
                  }

                }

              },),
            ),
          ]);
        }
      ),
    );
  }
}
