import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/data/model/response/transaction_model.dart';
import 'package:cimapos/helper/price_converter.dart';
import 'package:cimapos/util/color_resources.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_divider.dart';

class TransactionCardViewWidget extends StatelessWidget {
  final Transfers transfer;
  final int index;
  const TransactionCardViewWidget({Key key, this.index, this.transfer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),

        Container(color: Theme.of(context).cardColor, child: Column(children: [
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            leading: Text('${index + 1}.', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
            title: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text('${'account_type'.tr}: ${transfer.account != null? transfer.account.account : ''}', style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor),),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Text('${'type'.tr}: ${transfer.tranType}', style: fontSizeMedium.copyWith(color: ColorResources.getTextColor()),),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Text('${'transaction_date'.tr}: ${transfer.date}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Debit: ', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                Text('- ${transfer.debit == 1? PriceConverter.priceWithSymbol(transfer.amount): 0}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Credit: ', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                Text('${transfer.credit == 1? PriceConverter.priceWithSymbol(transfer.amount) : 0}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            ]),

          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: CustomDivider(color: Theme.of(context).hintColor),
          ),

          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            leading: SizedBox(),
            title: Text('Balance', style: fontSizeRegular.copyWith(color: ColorResources.getTextColor())),
            trailing: Text('${PriceConverter.priceWithSymbol(transfer.balance)}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              Text('${'description'.tr} : ', style: fontSizeRegular.copyWith(color: ColorResources.getTextColor())),

              Text('- ${transfer.description}', style: fontSizeRegular.copyWith(color:  Theme.of(context).hintColor)),

            ],),
          ),



        ],),),

        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      ],
    );
  }
}
