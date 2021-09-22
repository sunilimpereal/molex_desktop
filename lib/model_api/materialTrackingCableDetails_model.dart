// To parse this JSON data, do
//
//     final getMaterialTrackingCableDetails = getMaterialTrackingCableDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:molex_desktop/model_api/postrawmatList_model.dart';
MatTrkPostDetail matTrkPostDetailFromJson(String ? str) => MatTrkPostDetail.fromJson(json.decode(str!));

String ? matTrkPostDetailToJson(MatTrkPostDetail data) => json.encode(data.toJson());

class MatTrkPostDetail {
    MatTrkPostDetail({
        this.machineId,
        this.schedulerId,
        this.cablePartNumbers,
        this.selectedRawMaterial,
    });

    String ? machineId;
    String ? schedulerId;
    List<String ?> ?cablePartNumbers;
       List<PostRawMaterial>? selectedRawMaterial;

    factory MatTrkPostDetail.fromJson(Map<String ?, dynamic> json) => MatTrkPostDetail(
        machineId: json["machineId"],
        schedulerId: json["schedulerId"],
        cablePartNumbers: List<String ?>.from(json["cablePartNumbers"].map((x) => x)),
    );

    Map<String ?, dynamic> toJson() => {
        "machineId": machineId,
        "schedulerId": schedulerId,
        "cablePartNumbers": List<dynamic>.from(cablePartNumbers!.map((x) => x)),
    };
}


MatTrkDetail matTrkDetailFromJson(String ? str) => MatTrkDetail.fromJson(json.decode(str!));

String ? matTrkDetailToJson(MatTrkDetail data) => json.encode(data.toJson());

class MatTrkDetail {
    MatTrkDetail({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String ? status;
    String ? statusMsg;
    dynamic errorCode;
    Data1? data;

    factory MatTrkDetail.fromJson(Map<String ?, dynamic> json) => MatTrkDetail(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data1.fromJson(json["data"]),
    );

    Map<String ?, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data?.toJson(),
    };
}

class Data1 {
    Data1({
        this.material,
    });

    List<MaterialDetail>? material;

    factory Data1.fromJson(Map<String ?, dynamic> json) => Data1(
        material: List<MaterialDetail>.from(json["Material "].map((x) => MaterialDetail.fromJson(x))),
    );

    Map<String ?, dynamic> toJson() => {
        "Material ": List<dynamic>.from(material!.map((x) => x.toJson())),
    };
}

class MaterialDetail {
    MaterialDetail({
        this.uom,
        this.requiredQty,
        this.loadedQty,
        this.availableQty,
        this.machineNo,
        this.cablePartNo,
    });

    String ? uom;
    String ? requiredQty;
    String ? loadedQty;
    String ? availableQty;
    String ? machineNo;
    String ? cablePartNo;

    factory MaterialDetail.fromJson(Map<String ?, dynamic> json) => MaterialDetail(
        uom: json["uom"],
        requiredQty: json["requiredQty"],
        loadedQty: json["loadedQty"],
        availableQty: json["availableQty"],
        machineNo: json["machineNo"],
        cablePartNo: json["cablePartNo"],
    );

    Map<String ?, dynamic> toJson() => {
        "uom": uom,
        "requiredQty": requiredQty,
        "loadedQty": loadedQty,
        "availableQty": availableQty,
        "machineNo": machineNo,
        "cablePartNo": cablePartNo,
    };
}
