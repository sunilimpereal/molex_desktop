// To parse this JSON data, do
//
//     final getKittingData = getKittingDataFromJson(jsonString);

import 'dart:convert';

GetKittingData getKittingDataFromJson(String ? str) =>
    GetKittingData.fromJson(json.decode(str!));

String ? getKittingDataToJson(GetKittingData data) => json.encode(data.toJson());

class GetKittingData {
  GetKittingData({
    this.status,
    this.statusMsg,
    this.errorCode,
    this.data,
  });

  String ? status;
  String ? statusMsg;
  dynamic errorCode;
  Data ? data;

  factory GetKittingData.fromJson(Map<String ?, dynamic> json) => GetKittingData(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data ?.fromJson(json["data"]),
      );

  Map<String ?, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data?.toJson(),
      };
}

class Data  {
  Data ({
    this.kittingDetail,
  });

  KittingDetail? kittingDetail;

  factory Data.fromJson(Map<String ?, dynamic> json) => Data (
        kittingDetail: KittingDetail.fromJson(json["Kitting Detail"]),
      );

  Map<String ?, dynamic> toJson() => {
        "Kitting Detail": kittingDetail!.toJson(),
      };
}

class KittingDetail {
  KittingDetail({
    this.kittingEJobDtoList,
    this.kittingIssuanceList,
  });

  List<KittingEJobDtoList>? kittingEJobDtoList;
  List<dynamic> ?kittingIssuanceList;

  factory KittingDetail.fromJson(Map<String ?, dynamic> json) => KittingDetail(
        kittingEJobDtoList: List<KittingEJobDtoList>.from(
            json["kittingEJobDTOList"]
                .map((x) => KittingEJobDtoList.fromJson(x))),
        kittingIssuanceList:
            List<dynamic>.from(json["kittingIssuanceList"].map((x) => x)),
      );

  Map<String ?, dynamic> toJson() => {
        "kittingEJobDTOList":
            List<dynamic>.from(kittingEJobDtoList!.map((x) => x.toJson())),
        "kittingIssuanceList":
            List<dynamic>.from(kittingIssuanceList!.map((x) => x)),
      };
}

class KittingEJobDtoList {
  KittingEJobDtoList({
    this.fgNumber,
    this.cableColor,
    this.cableNumber,
    this.wireGuage,
    this.cutLength,
    this.bundleMaster,
  });

  int ? fgNumber;
  String ? cableColor;
  int ? cableNumber;
  int ? wireGuage;
  int ? cutLength;
  List<BundleMaster>? bundleMaster;

  factory KittingEJobDtoList.fromJson(Map<String ?, dynamic> json) =>
      KittingEJobDtoList(
        fgNumber: json["fgNumber"],
        cableColor: json["cableColor"],
        cableNumber: json["cableNumber"],
        wireGuage: json["wireGuage"],
        cutLength: json["cutLength"],
        bundleMaster: List<BundleMaster>.from(
            json["bundleMaster"].map((x) => BundleMaster.fromJson(x))),
      );

  Map<String ?, dynamic> toJson() => {
        "fgNumber": fgNumber,
        "cableColor": cableColor,
        "cableNumber": cableNumber,
        "wireGuage": wireGuage,
        "cutLength": cutLength,
        "bundleMaster": List<dynamic>.from(bundleMaster!.map((x) => x.toJson())),
      };
}

class BundleMaster {
  BundleMaster({
    this.id,
    this.bundleIdentification,
    this.scheduledId,
    this.bundleCreationTime,
    this.bundleUpdateTime,
    required this.bundleQuantity,
    this.machineIdentification,
    this.operatorIdentification,
    this.finishedGoodsPart,
    this.cablePartNumber,
    this.cablePartDescription,
    this.cutLengthSpecificationInmm,
    this.color,
    this.bundleStatus,
    this.binId,
    this.locationId,
    this.orderId,
    this.updateFromProcess,
    this.awg,
  });

  int ? id;
  String ? bundleIdentification;
  int ? scheduledId;
  DateTime? bundleCreationTime;
  dynamic bundleUpdateTime;
  int bundleQuantity;
  String ? machineIdentification;
  String ? operatorIdentification;
  int ? finishedGoodsPart;
  int ? cablePartNumber;
  dynamic cablePartDescription;
  int ? cutLengthSpecificationInmm;
  String ? color;
  String ? bundleStatus;
  int ? binId;
  String ? locationId;
  String ? orderId;
  String ? updateFromProcess;
  String ? awg;

  factory BundleMaster.fromJson(Map<String ?, dynamic> json) => BundleMaster(
        id: json["id"],
        bundleIdentification: json["bundleIdentification"],
        scheduledId: json["scheduledId"],
        bundleCreationTime: DateTime.parse(json["bundleCreationTime"]),
        bundleUpdateTime: json["bundleUpdateTime"],
        bundleQuantity: json["bundleQuantity"],
        machineIdentification: json["machineIdentification"],
        operatorIdentification: json["operatorIdentification"] == null
            ? null
            : json["operatorIdentification"],
        finishedGoodsPart: json["finishedGoodsPart"],
        cablePartNumber: json["cablePartNumber"],
        cablePartDescription: json["cablePartDescription"],
        cutLengthSpecificationInmm: json["cutLengthSpecificationInmm"],
        color: json["color"],
        bundleStatus: json["bundleStatus"],
        binId: json["binId"] == null ? null : json["binId"],
        locationId: json["locationId"] == null ? null : json["locationId"],
        orderId: json["orderId"],
        updateFromProcess: json["updateFromProcess"],
        awg: json["awg"],
      );

  Map<String ?, dynamic> toJson() => {
        "id": id,
        "bundleIdentification": bundleIdentification,
        "scheduledId": scheduledId,
        "bundleCreationTime":
            "${bundleCreationTime!.year.toString().padLeft(4, '0')}-${bundleCreationTime!.month.toString().padLeft(2, '0')}-${bundleCreationTime!.day.toString().padLeft(2, '0')}",
        "bundleUpdateTime": bundleUpdateTime,
        "bundleQuantity": bundleQuantity,
        "machineIdentification": machineIdentification,
        "operatorIdentification":
            operatorIdentification == null ? null : operatorIdentification,
        "finishedGoodsPart": finishedGoodsPart,
        "cablePartNumber": cablePartNumber,
        "cablePartDescription": cablePartDescription,
        "cutLengthSpecificationInmm": cutLengthSpecificationInmm,
        "color": color,
        "bundleStatus": bundleStatus,
        "binId": binId == null ? null : binId,
        "locationId": locationId == null ? null : locationId,
        "orderId": orderId,
        "updateFromProcess": updateFromProcess,
        "awg": awg,
      };
}

// To parse this JSON data, do
//
//     final postKittingData = postKittingDataFromJson(jsonString);

PostKittingData postKittingDataFromJson(String ? str) =>
    PostKittingData.fromJson(json.decode(str!));

String ? postKittingDataToJson(PostKittingData data) =>
    json.encode(data.toJson());

class PostKittingData {
  PostKittingData({
    this.orderNo,
    this.fgNumber,
    this.quantity,
  });

  String ? orderNo;
  int ? fgNumber;
  int ? quantity;

  factory PostKittingData.fromJson(Map<String ?, dynamic> json) =>
      PostKittingData(
        orderNo: json["orderNo"],
        fgNumber: json["fgNumber"],
        quantity: json["quantity"],
      );

  Map<String ?, dynamic> toJson() => {
        "orderNo": orderNo,
        "fgNumber": fgNumber,
        "quantity": quantity,
      };
}
