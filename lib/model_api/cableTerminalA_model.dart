// To parse this JSON data, do
//
//     final getCableTerminalA = getCableTerminalAFromJson(jsonString);

import 'dart:convert';

GetCableTerminalA getCableTerminalAFromJson(String ? str) => GetCableTerminalA.fromJson(json.decode(str!));

String ? getCableTerminalAToJson(GetCableTerminalA data) => json.encode(data.toJson());

class GetCableTerminalA {
    GetCableTerminalA({
        this.status,
        this.statusMsg,
        this.errorCode,
        this.data,
    });

    String ? status;
    String ? statusMsg;
    dynamic errorCode;
    Data ? data;

    factory GetCableTerminalA.fromJson(json) => GetCableTerminalA(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data.fromJson(json["data"]),
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
        this.findCableTerminalADto,
    });

    CableTerminalA? findCableTerminalADto;

    factory Data.fromJson(Map<String ?, dynamic> json) => Data(
        findCableTerminalADto: CableTerminalA.fromJson(json["findCableTerminalADto "]),
    );

    Map<String ?, dynamic> toJson() => {
        "findCableTerminalADto ": findCableTerminalADto!.toJson(),
    };
}

class CableTerminalA {
    CableTerminalA({
        this.fronStripLengthSpec,
        this.processType,
        this.terminalPart,
        this.specCrimpLength,
        this.pullforce,
        this.comment,
        this.unsheathingLength,
        this.stripLength,
    });

    dynamic fronStripLengthSpec;
    String ? processType;
    dynamic terminalPart;
    dynamic specCrimpLength;
    dynamic pullforce;
    dynamic comment;
    dynamic unsheathingLength;
    dynamic stripLength;

    factory CableTerminalA.fromJson(Map<String, dynamic> json) => CableTerminalA(
        fronStripLengthSpec: json["fronStripLengthSpec"]?.toString()?.replaceAll("Â±", "±"),
        processType: json["processType"]?.toString()?.replaceAll("Â±", "±"),
        terminalPart: json["terminalPart"],
        specCrimpLength: json["specCrimpLength"]?.toString()?.replaceAll("Â±", "±"),
        pullforce: json["pullforce"]?.toDouble(),
        comment: json["comment"]?.toString()?.replaceAll("Â±", "±"),
        unsheathingLength: json["unsheathingLength"]?.toString()?.replaceAll("Â±", "±"),
        stripLength: json["stripLength"]?.toString()?.replaceAll("Â±", "±"),
    );

    Map<String, dynamic> toJson() => {
        "fronStripLengthSpec": fronStripLengthSpec,
        "processType": processType,
        "terminalPart": terminalPart,
        "specCrimpLength": specCrimpLength,
        "pullforce": pullforce,
        "comment": comment,
        "unsheathingLength": unsheathingLength,
        "stripLength": stripLength,
    };
}
