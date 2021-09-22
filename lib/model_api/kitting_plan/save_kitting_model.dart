// To parse this JSON data, do
//
//     final saveKitting = saveKittingFromJson(jsonString);

import 'dart:convert';

List<SaveKitting> saveKittingFromJson(String ? str) => List<SaveKitting>.from(json.decode(str!).map((x) => SaveKitting.fromJson(x)));

String ? saveKittingToJson(List<SaveKitting> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SaveKitting {
    SaveKitting({
        this.fgPartNumber,
        this.orderId,
        this.cablePartNumber,
        this.cableType,
        this.length,
        this.wireCuttingColor,
        this.average,
        this.customerName,
        this.routeMaster,
        this.scheduledQty,
        this.actualQty,
        this.binId,
        this.binLocation,
        this.bundleId,
        this.bundleQty,
        this.suggetedScheduledQty,
        this.suggestedActualQty,
        this.suggestedBinLocation,
        this.suggestedBundleId,
        this.suggestedBundleQty,
        this.status,
    });

    int ? fgPartNumber;
    String ? orderId;
    String ? cablePartNumber;
    String ? cableType;
    int ? length;
    String ? wireCuttingColor;
    int ? average;
    String ? customerName;
    String ? routeMaster;
    int ? scheduledQty;
    dynamic actualQty;
    String ? binId;
    String ? binLocation;
    List<String ?>? bundleId;
    int ? bundleQty;
    dynamic suggetedScheduledQty;
    dynamic suggestedActualQty;
    dynamic suggestedBinLocation;
    dynamic suggestedBundleId;
    dynamic suggestedBundleQty;
    dynamic status;

    factory SaveKitting.fromJson(Map<String ?, dynamic> json) => SaveKitting(
        fgPartNumber: json["fgPartNumber"],
        orderId: json["orderId"],
        cablePartNumber: json["cablePartNumber"],
        cableType: json["cableType"],
        length: json["length"],
        wireCuttingColor: json["wireCuttingColor"],
        average: json["average"],
        customerName: json["customerName"],
        routeMaster: json["routeMaster"],
        scheduledQty: json["scheduledQty"],
        actualQty: json["actualQty"],
        binId: json["binId"],
        binLocation: json["binLocation"],
        bundleId: List<String ?>.from(json["bundleId"].map((x) => x)),
        bundleQty: json["bundleQty"],
        suggetedScheduledQty: json["SuggetedScheduledQty"],
        suggestedActualQty: json["suggestedActualQty"],
        suggestedBinLocation: json["SuggestedBinLocation"],
        suggestedBundleId: json["suggestedBundleId"],
        suggestedBundleQty: json["suggestedBundleQty"],
        status: json["status"],
    );

    Map<String ?, dynamic> toJson() => {
        "fgPartNumber": fgPartNumber,
        "orderId": orderId,
        "cablePartNumber": cablePartNumber,
        "cableType": cableType,
        "length": length,
        "wireCuttingColor": wireCuttingColor,
        "average": average,
        "customerName": customerName,
        "routeMaster": routeMaster,
        "scheduledQty": scheduledQty,
        "actualQty": actualQty,
        "binId": binId,
        "binLocation": binLocation,
        "bundleId": List<dynamic>.from(bundleId!.map((x) => x)),
        "bundleQty": bundleQty,
        "SuggetedScheduledQty": suggetedScheduledQty,
        "suggestedActualQty": suggestedActualQty,
        "SuggestedBinLocation": suggestedBinLocation,
        "suggestedBundleId": suggestedBundleId,
        "suggestedBundleQty": suggestedBundleQty,
        "status": status,
    };
}
