import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cimapos/controller/quote_controller.dart';
import 'package:cimapos/data/model/response/quote_model.dart';
import 'package:cimapos/util/dimensions.dart';
import 'package:cimapos/view/base/custom_loader.dart';
import 'package:cimapos/view/base/no_data_screen.dart';
import 'package:cimapos/view/screens/quote/widget/quote_card_widget.dart';


class OrderListView extends StatelessWidget {
  final ScrollController scrollController;
  const OrderListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<QuoteController>().quoteList.length != 0
          && !Get.find<QuoteController>().isLoading) {
        int pageSize;
        pageSize = Get.find<QuoteController>().quoteListLength;

        if(Get.find<QuoteController>().offset < pageSize) {
          Get.find<QuoteController>().setOffset(Get.find<QuoteController>().offset);
          print('end of the page');
          Get.find<QuoteController>().showBottomLoader();
          Get.find<QuoteController>().getQuoteList(Get.find<QuoteController>().offset.toString());
        }
      }

    });

    return GetBuilder<QuoteController>(
      builder: (quoteController) {
        List<Quotes> quoteList;
        quoteList = quoteController.quoteList;

        return Column(children: [

          !quoteController.isFirst ? quoteList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: quoteList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return QuoteCardWidget(quote: quoteList[index]);

              }): NoDataScreen() : CustomLoader(),
          quoteController.isLoading  && !quoteController.isFirst ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : SizedBox.shrink(),

        ]);
      },
    );
  }
}
