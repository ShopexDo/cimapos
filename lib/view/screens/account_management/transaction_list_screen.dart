import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/account_controller.dart';
import 'package:six_pos/controller/transaction_controller.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/view/base/custom_app_bar.dart';
import 'package:six_pos/view/base/custom_date_picker.dart';
import 'package:six_pos/view/base/custom_drawer.dart';
import 'package:six_pos/view/base/custom_header.dart';
import 'package:six_pos/view/base/custom_snackbar.dart';
import 'package:six_pos/view/base/secondary_header_view.dart';
import 'package:six_pos/view/screens/account_management/widget/customer_transaction_list_view.dart';
import 'package:six_pos/view/screens/account_management/widget/transaction_list_view.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionListScreen extends StatefulWidget {
  final bool fromCustomer;
  final int customerId;
  const TransactionListScreen({Key key, this.fromCustomer = false, this.customerId}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final ScrollController _scrollController = ScrollController();


  ReceivePort _port = ReceivePort();


  @override
  void initState() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    if(widget.fromCustomer){
      Get.find<TransactionController>().getCustomerWiseTransactionListList(widget.customerId,1);
    }else{
      Get.find<TransactionController>().getTransactionList(1);
    }

    Get.find<TransactionController>().getTransactionTypeList();
    super.initState();

  }


  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isBackButtonExist: true),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            return false;
          },
          child: CustomScrollView(
            controller: Get.find<TransactionController>().scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  CustomHeader(title: 'transaction_List'.tr , headerImage: Images.people_icon),

                  GetBuilder<TransactionController>(
                      builder: (transactionController) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                                GetBuilder<AccountController>(
                                    builder: (accountController) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                                          child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text('account'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                            Container(
                                              height: 50,
                                              padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                                  border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                              child: DropdownButton<int>(

                                                value: accountController.accountIndex,
                                                items: accountController.accountIds.map((int value) {
                                                  return DropdownMenuItem<int>(
                                                      value: value,
                                                      child: Text(accountController.accountList[(accountController.accountIds.indexOf(value))].account ));}).toList(),
                                                onChanged: (int value) {
                                                  accountController.setAccountIndex(value, true);
                                                },
                                                isExpanded: true, underline: SizedBox(),),),
                                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                          ],),),
                                        ),
                                      );
                                    }
                                ),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_DEFAULT,0,Dimensions.PADDING_SIZE_DEFAULT,0),
                                    child: Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text('transaction_type'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                                      Container(
                                        height: 50,
                                        padding: EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_SMALL),
                                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                            border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_MEDIUM_BORDER)),
                                        child: DropdownButton<int>(

                                          value: transactionController.transactionTypeIndex,
                                          items: transactionController.transactionTypeIds.map((int value) {
                                            return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(transactionController.transactionTypeList[(transactionController.transactionTypeIds.indexOf(value))].tranType ));}).toList(),
                                          onChanged: (int value) {
                                            transactionController.setTransactionTypeIndex(value, true);
                                          },
                                          isExpanded: true, underline: SizedBox(),),),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    ],),),
                                  ),
                                ),

                              ],),
                              Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                                Expanded(
                                  child: CustomDatePicker(
                                    title: 'from'.tr,
                                    text: transactionController.startDate != null ?
                                    transactionController.dateFormat.format(transactionController.startDate).toString() : 'from_date'.tr,
                                    image: Images.calender,
                                    requiredField: false,
                                    selectDate: () => transactionController.selectDate("start", context),
                                  ),
                                ),

                                Expanded(
                                  child: CustomDatePicker(
                                    title: 'to'.tr,
                                    text: transactionController.endDate != null ?
                                    transactionController.dateFormat.format(transactionController.endDate).toString() : 'to_date'.tr,
                                    image: Images.calender,
                                    requiredField: false,
                                    selectDate: () => transactionController.selectDate("end", context),
                                  ),
                                ),

                              ],),

                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        final baseUrl = await AppConstants.getSavedBaseUrl();
                                        _launchUrl(Uri.parse('${baseUrl}${AppConstants.TRANSACTION_LIST_EXPORT_URI}'));
                                        _launchUrl(Uri.parse('${baseUrl}${AppConstants.TRANSACTION_LIST_EXPORT_URI}?'
                                            'from=${transactionController.startDate.toString()}&to=${transactionController.endDate.toString()}&account_id=0&transaction_type='));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                                            color: Theme.of(context).secondaryHeaderColor,

                                          ),
                                          child: Center(child: Text('export'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),)),),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        transactionController.getTransactionList(1);
                                        transactionController.resetDate();

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                                            color: ColorResources.getCategoryWithProductColor(),

                                          ),
                                          child: Center(child: Text('reset'.tr, style: fontSizeRegular.copyWith(color: ColorResources.getTextColor()),)),),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        String startDate = transactionController.startDate.toString();
                                        String endDate = transactionController.endDate.toString();
                                        String selectedStartDate = '';
                                        String selectedEndDate = '';


                                        if(startDate == 'null'  && endDate == 'null'){
                                          showCustomSnackBar('select_from_and_to_date'.tr);
                                        }
                                        else{

                                          selectedStartDate = transactionController.dateFormat.format(transactionController.startDate).toString();
                                          selectedEndDate = transactionController.dateFormat.format(transactionController.endDate).toString();

                                          transactionController.getTransactionFilter(selectedStartDate, selectedEndDate,
                                              Get.find<AccountController>().accountIndex, transactionController.transactionTypeName != null
                                                  ?transactionController.transactionTypeName:'income',1 );
                                        }



                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_BORDER),
                                            color: Theme.of(context).primaryColor,

                                          ),
                                          child: Center(child: Text('filter'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),)),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                  ),


                  SecondaryHeaderView(isSerial: true, key: UniqueKey(),isTransaction: true, title: 'transaction_info'.tr,),


                  widget.fromCustomer?
                  CustomerTransactionListView(isHome: false,scrollController: _scrollController, customerId: widget.customerId) :
                  TransactionListView(isHome: false,)


                ]),
              )
            ],
          ),
        ),
      ),



    );
  }
}


Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $_url';
  }
}