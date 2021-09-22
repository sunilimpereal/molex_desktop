// To parse this JSON data, do
//
//     final getBinDetail = getBinDetailFromJson(jsonString);

import 'dart:convert';

GetBinDetail getBinDetailFromJson(String str) => GetBinDetail.fromJson(json.decode(str));

String getBinDetailToJson(GetBinDetail data) => json.encode(data.toJson());

class GetBinDetail {
    GetBinDetail({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String? status;
    String? statusMsg;
    dynamic errorCode;
    Data ?data;

    factory GetBinDetail.fromJson(Map<String, dynamic> json) => GetBinDetail(
        status: json["status"] == null ? null : json["status"],
        statusMsg: json["statusMsg"] == null ? null : json["statusMsg"],
        errorCode: json["errorCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "statusMsg": statusMsg == null ? null : statusMsg,
        "errorCode": errorCode,
        "data": data == null ? null : data!.toJson(),
    };
}

class Data {
    Data({
        this.materialCodinatorSchedulerData,
    });

    List<BundleDetail> ?materialCodinatorSchedulerData;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        materialCodinatorSchedulerData: json["  Material Codinator Scheduler Data "] == null ? null : List<BundleDetail>.from(json["  Material Codinator Scheduler Data "].map((x) => BundleDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "  Material Codinator Scheduler Data ": materialCodinatorSchedulerData == null ? null : List<dynamic>.from(materialCodinatorSchedulerData!.map((x) => x.toJson())),
    };
}

class BundleDetail {
    BundleDetail({
        this.id,
        this.bundleIdentification,
        this.scheduledId,
        this.bundleCreationTime,
        this.bundleUpdateTime,
        this.bundleQuantity,
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

    int? id;
    String? bundleIdentification;
    int? scheduledId;
    DateTime? bundleCreationTime;
    dynamic? bundleUpdateTime;
    int ?bundleQuantity;
    String ?machineIdentification;
    String? operatorIdentification;
    int ?finishedGoodsPart;
    int ?cablePartNumber;
    dynamic? cablePartDescription;
    int ?cutLengthSpecificationInmm;
    String? color;
    String? bundleStatus;
    int ?binId;
    String? locationId;
    String? orderId;
    String? updateFromProcess;
    String? awg;

    factory BundleDetail.fromJson(Map<String, dynamic> json) => BundleDetail(
        id: json["id"] == null ? null : json["id"],
        bundleIdentification: json["bundleIdentification"] == null ? null : json["bundleIdentification"],
        scheduledId: json["scheduledId"] == null ? null : json["scheduledId"],
        bundleCreationTime: json["bundleCreationTime"] == null ? null : DateTime.parse(json["bundleCreationTime"]),
        bundleUpdateTime: json["bundleUpdateTime"],
        bundleQuantity: json["bundleQuantity"] == null ? null : json["bundleQuantity"],
        machineIdentification: json["machineIdentification"] == null ? null : json["machineIdentification"],
        operatorIdentification: json["operatorIdentification"] == null ? null : json["operatorIdentification"],
        finishedGoodsPart: json["finishedGoodsPart"] == null ? null : json["finishedGoodsPart"],
        cablePartNumber: json["cablePartNumber"] == null ? null : json["cablePartNumber"],
        cablePartDescription: json["cablePartDescription"],
        cutLengthSpecificationInmm: json["cutLengthSpecificationInmm"] == null ? null : json["cutLengthSpecificationInmm"],
        color: json["color"] == null ? null : json["color"],
        bundleStatus: json["bundleStatus"] == null ? null : json["bundleStatus"],
        binId: json["binId"] == null ? null : json["binId"],
        locationId: json["locationId"] == null ? null : json["locationId"],
        orderId: json["orderId"] == null ? null : json["orderId"],
        updateFromProcess: json["updateFromProcess"] == null ? null : json["updateFromProcess"],
        awg: json["awg"] == null ? null : json["awg"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "bundleIdentification": bundleIdentification == null ? null : bundleIdentification,
        "scheduledId": scheduledId == null ? null : scheduledId,
        "bundleCreationTime": bundleCreationTime == null ? null : "${bundleCreationTime!.year.toString().padLeft(4, '0')}-${bundleCreationTime!.month.toString().padLeft(2, '0')}-${bundleCreationTime!.day.toString().padLeft(2, '0')}",
        "bundleUpdateTime": bundleUpdateTime,
        "bundleQuantity": bundleQuantity == null ? null : bundleQuantity,
        "machineIdentification": machineIdentification == null ? null : machineIdentification,
        "operatorIdentification": operatorIdentification == null ? null : operatorIdentification,
        "finishedGoodsPart": finishedGoodsPart == null ? null : finishedGoodsPart,
        "cablePartNumber": cablePartNumber == null ? null : cablePartNumber,
        "cablePartDescription": cablePartDescription,
        "cutLengthSpecificationInmm": cutLengthSpecificationInmm == null ? null : cutLengthSpecificationInmm,
        "color": color == null ? null : color,
        "bundleStatus": bundleStatus == null ? null : bundleStatus,
        "binId": binId == null ? null : binId,
        "locationId": locationId == null ? null : locationId,
        "orderId": orderId == null ? null : orderId,
        "updateFromProcess": updateFromProcess == null ? null : updateFromProcess,
        "awg": awg == null ? null : awg,
    };
}

