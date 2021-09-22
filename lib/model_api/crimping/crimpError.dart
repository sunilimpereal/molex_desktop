// To parse this JSON data, do
//
//     final crimpRejectionError = crimpRejectionErrorFromJson(jsonString);

import 'dart:convert';

CrimpRejectionError crimpRejectionErrorFromJson(String? str) =>
    CrimpRejectionError.fromJson(json.decode(str!));

String? crimpRejectionErrorToJson(CrimpRejectionError data) =>
    json.encode(data.toJson());

class CrimpRejectionError {
  CrimpRejectionError({
    this.status,
    this.statusMsg,
    this.errorCode,
    this.data,
  });

  String? status;
  String? statusMsg;
  String? errorCode;
  Data? data;

  factory CrimpRejectionError.fromJson(Map<String?, dynamic> json) =>
      CrimpRejectionError(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data?.fromJson(json["data"]),
      );

  Map<String?, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data?.toJson(),
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String?, dynamic> json) => Data();

  Map<String?, dynamic> toJson() => {};
}
