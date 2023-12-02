import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/splash_controller.dart';
import 'package:cimapos/helper/price_converter.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/images.dart';
import 'package:cimapos/util/styles.dart';


class RevenueStatistics extends StatelessWidget {
  const RevenueStatistics({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor
      ),
      child: GetBuilder<SplashController>(
        builder: (revenueController) {

          double revenue = 0;
          List<String> _itemsTitle =[];
          List<String> _itemsAmount =[];
          List<String> _bg =[];

          if(revenueController.revenueModel != null){
            revenue = revenueController.revenueModel.totalIncome -
                revenueController.revenueModel.totalExpense;

             _itemsTitle = ['total_revenue'.tr, 'total_income'.tr, 'total_expense'.tr, 'account_receivable'.tr, 'account_payable'.tr];
             _itemsAmount = ['${revenue.toString()}', '${revenueController.revenueModel.totalIncome}',
               '${revenueController.revenueModel.totalExpense}', '${revenueController.revenueModel.totalReceivable}',
               '${revenueController.revenueModel.totalPayable}'];
             _bg = ['0xFF286FC6', '0xFF5ABD88', '0xFFD0517F', '0xFF2BA361', '0xFFFF6D6D'];

          }

          return Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                SizedBox(width: Dimensions.ICON_SIZE_DEFAULT,height: Dimensions.ICON_SIZE_DEFAULT,
                  child: Image.asset(Images.revenue),),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                Text('revenue_statistics'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),

                Expanded(child: SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE,)),
                Container(
                  height: 50,width: 150,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                    borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  ),
                  child: DropdownButton<String>(
                    value: revenueController.revenueFilterTypeIndex == 0 ? 'General' : revenueController.revenueFilterTypeIndex == 1 ? 'Hoy' : 'Este mes',
                    items: <String>['General', 'Hoy', 'Este mes' ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: fontSizeRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      revenueController.setRevenueFilterName(value, true);
                      revenueController.setRevenueFilterType(value == 'General' ? 0 : value == 'Hoy'? 1:2, true);

                    },
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),


              ],),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
              revenueController.revenueModel != null?
              Container(height: Dimensions.REVENUE_CARD,
                child: ListView.builder(
                  itemCount: 5,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_CARD),
                        width: Dimensions.DASHBOARD_CARD_WIDTH,height: Dimensions.REVENUE_CARD,
                        decoration: BoxDecoration(
                          color: Color(int.parse(_bg[index])),
                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)
                        ),
                        child: Stack(
                          children: [
                            Positioned(bottom: Dimensions.PADDING_SIZE_LARGE,left: Dimensions.PADDING_SIZE_LARGE,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                Text('${PriceConverter.priceWithSymbol(double.parse(_itemsAmount[index]))}',maxLines: 2,overflow: TextOverflow.ellipsis, style: fontSizeBold.copyWith(color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),),
                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                                Text('${_itemsTitle[index]}',style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                      ],),
                            ),
                            Positioned(top: Dimensions.PADDING_SIZE_SMALL,
                              right: Dimensions.PADDING_SIZE_SMALL,
                              child: SizedBox(width: Dimensions.ICON_SIZE_DEFAULT,height: Dimensions.ICON_SIZE_DEFAULT,
                                  child: Image.asset(Images.dollar)),
                            ),
                          ],
                        ),),
                    );

                }),
              ):SizedBox(),
            ],
          );
        }
      ),
    );
  }
}
