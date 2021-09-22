// To parse this JSON data, do
//
//     final postReturnMaterial = postReturnMaterialFromJson(jsonString);

import 'dart:convert';

PostReturnMaterial postReturnMaterialFromJson(String str) => PostReturnMaterial.fromJson(json.decode(str));

String postReturnMaterialToJson(PostReturnMaterial data) => json.encode(data.toJson());

class PostReturnMaterial {
    PostReturnMaterial({
        required this.machineIdentification,
        required this.partNumberList,
    });

    String machineIdentification;
    List<Part> partNumberList;

    factory PostReturnMaterial.fromJson(Map<String, dynamic> json) => PostReturnMaterial(
        machineIdentification: json["machineIdentification"],
        partNumberList: List<Part>.from(json["partNumberList"].map((x) => Part.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "machineIdentification": machineIdentification,
        "partNumberList": List<dynamic>.from(partNumberList.map((x) => x.toJson())),
    };
}

class Part {
    Part({
        required this.partNumbers,
        required this.usedQuantity,
        required this.traceabilityNumber,
    });

    int partNumbers;
    int usedQuantity;
    String traceabilityNumber;
    factory Part.fromJson(Map<String, dynamic> json) => Part(
        partNumbers: json["partNumbers"],
        usedQuantity: json["usedQuantity"],
        traceabilityNumber: json["traceabilityNumber"],
    );

    Map<String, dynamic> toJson() => {
        "partNumbers": partNumbers,
        "usedQuantity": usedQuantity,
        "traceabilityNumber": traceabilityNumber,
    };
}
