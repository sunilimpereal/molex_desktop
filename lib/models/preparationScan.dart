

import 'package:molex_desktop/model_api/crimping/bundleDetail.dart';

class PreparationScan{
  String ? employeeId;
  String ? bundleId;
  String ? status;
  String ? binId;
  BundleData bundleDetail;
  PreparationScan({this.bundleId,required this.bundleDetail,this.employeeId,this.status,this.binId});
}