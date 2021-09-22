// To parse this JSON data, do
//
//     final postgetBundleMaster = postgetBundleMasterFromJson(jsonString);

import 'dart:convert';

PostgetBundleMaster postgetBundleMasterFromJson(String str) => PostgetBundleMaster.fromJson(json.decode(str));

String postgetBundleMasterToJson(PostgetBundleMaster data) => json.encode(data.toJson());

class PostgetBundleMaster {
    PostgetBundleMaster({
        required this.binId,
        required this.status,
        required this.bundleId,
        required this.location,
        required this.finishedGoods,
        required this.cablePartNumber,
        required this.orderId,
        required this.scheduleId,
    });

    int binId;
    String status;
    String bundleId;
    String location;
    int finishedGoods;
    int cablePartNumber;
    String orderId;
    int scheduleId;

    factory PostgetBundleMaster.fromJson(Map<String, dynamic> json) => PostgetBundleMaster(
        binId: json["binId"],
        status: json["status"],
        bundleId: json["bundleId"],
        location: json["location"],
        finishedGoods: json["finishedGoods"],
        cablePartNumber: json["cablePartNumber"],
        orderId: json["orderId"],
        scheduleId: json["scheduleId"],
    );

    Map<String, dynamic> toJson() => {
        "binId": binId,
        "status": status,
        "bundleId": bundleId,
        "location": location,
        "finishedGoods": finishedGoods,
        "cablePartNumber": cablePartNumber,
        "orderId": orderId,
        "scheduleId": scheduleId,
    };
}
