
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/controller/unit_controller.dart';
import 'package:six_pos/data/model/response/unit_model.dart';
import 'package:six_pos/view/base/no_data_screen.dart';
import 'package:six_pos/view/base/unit_shimmer.dart';
import 'package:six_pos/view/screens/unit/widget/unit_card_widget.dart';

class UnitListView extends StatelessWidget {
  final ScrollController scrollController;
  const UnitListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController.position.maxScrollExtent == scrollController.position.pixels
          && Get.find<UnitController>().unitList.length != 0
          && !Get.find<UnitController>().isLoading) {
        int pageSize;
        pageSize = Get.find<UnitController>().unitListLength;

        if(offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<UnitController>().showBottomLoader();
          Get.find<UnitController>().getUnitList(offset);
        }
      }

    });

    return GetBuilder<UnitController>(
      builder: (unitController) {
        List<Units> unitList;
        unitList = unitController.unitList;

        return Column(children: [

          unitList != null ? unitList.length != 0 ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: unitList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return UnitCardWidget(unit: unitList[index]);
              }) : UnitShimmer() : NoDataScreen(),

        ]);
      },
    );
  }
}
