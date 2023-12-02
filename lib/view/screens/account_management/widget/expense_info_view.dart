import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/data/model/response/expenseModel.dart';
import 'package:cimapos/helper/price_converter.dart';
import 'package:cimapos/util/color_resources.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/util/styles.dart';
import 'package:cimapos/view/base/custom_divider.dart';

class ExpenseCardViewWidget extends StatelessWidget {
  final Expenses expense;
  final int index;
  const ExpenseCardViewWidget({Key key, this.index, this.expense}) : super(key: key);

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
              Text('Account type: ${ expense.account != null ?expense.account.account:''}', style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor),),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Debit: ', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                Text('- ${expense.debit == 1? PriceConverter.priceWithSymbol(expense.amount): 0}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Credit: ', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                Text(' ${expense.credit == 1? PriceConverter.priceWithSymbol(expense.credit): 0 }', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),

            ]),

          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            child: CustomDivider(color: Theme.of(context).hintColor),
          ),

          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            leading: SizedBox(),
            title: Text('Balance', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
            trailing: Text(' ${PriceConverter.priceWithSymbol(expense.balance)}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              Text('${'description'.tr} : ', style: fontSizeRegular.copyWith(color: ColorResources.getTextColor())),

              Text('- ${expense.description}', style: fontSizeRegular.copyWith(color:  Theme.of(context).hintColor)),

            ],),
          ),
        ],),),

        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      ],
    );
  }
}
