import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';



class UnitRepo{
  ApiClient apiClient;
  UnitRepo({@required this.apiClient});

  Future<Response> getUnitList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_UNIT_LIST}?limit=10&offset=$offset');
  }

  Future<Response> deleteUnit(int unitId) async {
    return await apiClient.getData('${AppConstants.DELETE_UNIT_URI}?id=$unitId  ');
  }

  Future<Response> addUnit(String unitType, int unitId, {bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate? '${AppConstants.UPDATE_UNIT_URI}': '${AppConstants.ADD_UNIT}',
        {
          'id': unitId,
          'unit_type': unitType,
          '_method': isUpdate? 'put' :'post'
        });
  }


}