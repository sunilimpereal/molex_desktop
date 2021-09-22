// To parse this JSON data, do
//
//     final postGenerateLabel = postGenerateLabelFromJson(jsonString);

import 'dart:convert';

PostGenerateLabel postGenerateLabelFromJson(String str) =>
    PostGenerateLabel.fromJson(json.decode(str));

String postGenerateLabelToJson(PostGenerateLabel data) =>
    json.encode(data.toJson());

class PostGenerateLabel {
  PostGenerateLabel({
    this.finishedGoods,
    this.purchaseorder,
    this.orderIdentification,
    this.cablePartNumber,
    this.cutLength,
    this.color,
    this.scheduleIdentification,
    this.scheduledQuantity,
    this.machineIdentification,
    this.operatorIdentification,
    this.bundleIdentification,
    this.rejectedQuantity,
    this.terminalDamage, 
    this.terminalBend,
    this.terminalTwist,
    this.conductorCurlingUpDown,
    this.insulationCurlingUpDown,
    this.conductorBurr,
    this.windowGap,
    this.crimpOnInsulation,
    this.improperCrimping,
    this.tabBendOrTabOpen,
    this.bellMouthLessOrMore,
    this.cutOffLessOrMore,
    this.cutOffBurr,
    this.cutOffBend,
    this.insulationDamage,
    this.exposureStrands,
    this.strandsCut,
    this.brushLengthLessorMore,
    this.terminalCoppermark,
    this.setupRejections,
    this.terminalBackOut,
    this.cableDamage,
    this.crimpingPositionOutOrMissCrimp,
    this.terminalSeamOpen,
    this.rollerMark,
    this.lengthLessOrLengthMore,
    this.gripperMark,
    this.endTerminal,
    this.entangledCable,
    this.troubleShootingRejections,
    this.wireOverLoadRejectionsJam,
    this.halfCurlingA,
    this.brushLengthLessOrMoreC,
    this.exposureStrandsD,
    this.cameraPositionOutE,
    this.crimpOnInsulationF,
    this.cablePositionMovementG,
    this.crimpOnInsulationC,
    this.crimpingPositionOutOrMissCrimpD,
    this.crimpPositionOut,
    this.stripPositionOut,
    this.offCurling,
    this.cFmPfmRejections,
    this.incomingIssue,
    this.bladeMark,
    this.crossCut,
    this.insulationBarrel,
    this.method,
    this.terminalFrom,
    this.terminalTo,
    this.awg,
    this.setUpRejections,
    this.setUpRejectionTerminalFrom,
    this.setUpRejectionTerminalTo,
    this.cvmRejectionsCable,
    this.cvmRejectionsCableTerminalTo,
    this.cvmRejectionsCableTerminalFrom,
    this.cfmRejectionsCable,
    this.cfmRejectionsCableTerminalTo,
    this.cfmRejectionsCableTerminalFrom,
    this.endWire,
    this.rejectionsTerminalTo,
    this.rejectionsTerminalFrom,
    this.lengthVariation,
    this.stringLengthVariation,
    this.nickMark,
    this.bellMouthError,
    this.brushLengthLessMore,
    this.wrongTerminal,
    this.wrongCable,
    this.seamOpen,
    this.wrongCutLength,
    this.missCrimp,
    this.extrusionBurr,
    required this.crimpFromSchId,
    required this.crimpToSchId,
    required this.preparationCompleteFlag,
    required this.viCompleted,
    required this.processType,
  });

  int? finishedGoods;
  int? purchaseorder;
  int? orderIdentification;
  int? cablePartNumber;
  int? cutLength;
  String? color;
  int ?scheduleIdentification;
  int? scheduledQuantity;
  String? machineIdentification;
  String ?operatorIdentification;
  String ?bundleIdentification;
  int? rejectedQuantity;
  int? terminalDamage;
  int? terminalBend;
  int? terminalTwist;
  int? conductorCurlingUpDown;
  int ?insulationCurlingUpDown;
  int ?conductorBurr;
  int ?windowGap;
  int ?crimpOnInsulation;
  int ?improperCrimping;
  int ?tabBendOrTabOpen;
  int ?bellMouthLessOrMore;
  int ?cutOffLessOrMore;
  int ?cutOffBurr;
  int ?cutOffBend;
  int ?insulationDamage;
  int ?exposureStrands;
  int ?strandsCut;
  int ?brushLengthLessorMore;
  int ?terminalCoppermark;
  int ?setupRejections;
  int ?terminalBackOut;
  int ?cableDamage;
  int ?crimpingPositionOutOrMissCrimp;
  int ?terminalSeamOpen;
  int ?rollerMark;
  int ?lengthLessOrLengthMore;
  int ?gripperMark;
  int ?endTerminal;
  int ?entangledCable;
  int ?troubleShootingRejections;
  int ?wireOverLoadRejectionsJam;
  int ?halfCurlingA;
  int ?brushLengthLessOrMoreC;
  int ?exposureStrandsD;
  int ?cameraPositionOutE;
  int ?crimpOnInsulationF;
  int ?cablePositionMovementG;
  int ?crimpOnInsulationC;
  int ?crimpingPositionOutOrMissCrimpD;
  int ?crimpPositionOut;
  int? stripPositionOut;
  int? offCurling;
  int? cFmPfmRejections;
  int? incomingIssue;
  int? bladeMark;
  int ?crossCut;
  int? insulationBarrel;
  String? method;
  int? terminalFrom;
  int? terminalTo;
  String? awg;
  int? setUpRejections;
  int? setUpRejectionTerminalFrom;
  int? setUpRejectionTerminalTo;
  int? cvmRejectionsCable;
  int? cvmRejectionsCableTerminalTo;
  int? cvmRejectionsCableTerminalFrom;
  int? cfmRejectionsCable;
  int? cfmRejectionsCableTerminalTo;
  int? cfmRejectionsCableTerminalFrom;
  int? endWire;
  int? rejectionsTerminalTo;
  int? rejectionsTerminalFrom;
  int? lengthVariation;
  int? stringLengthVariation;
  int? nickMark;
  int? bellMouthError;
  int? brushLengthLessMore;
  int? wrongTerminal;
  int? wrongCable;
  int? seamOpen;
  int? wrongCutLength;
  int? missCrimp;
  int? extrusionBurr;
  String crimpFromSchId;
  String crimpToSchId;
  String preparationCompleteFlag;
  String viCompleted;
  String processType;

  factory PostGenerateLabel.fromJson(Map<String, dynamic> json) =>
      PostGenerateLabel(
        finishedGoods: json["finishedGoods"],
        purchaseorder: json["purchaseorder"],
        orderIdentification: json["orderIdentification"],
        cablePartNumber: json["cablePartNumber"],
        cutLength: json["cutLength"],
        color: json["color"],
        scheduleIdentification: json["scheduleIdentification"],
        scheduledQuantity: json["scheduledQuantity"],
        machineIdentification: json["machineIdentification"],
        operatorIdentification: json["operatorIdentification"],
        bundleIdentification: json["bundleIdentification"],
        rejectedQuantity: json["rejectedQuantity"],
        terminalDamage: json["terminalDamage"],
        terminalBend: json["terminalBend"],
        terminalTwist: json["terminalTwist"],
        conductorCurlingUpDown: json["conductorCurlingUpDown"],
        insulationCurlingUpDown: json["insulationCurlingUpDown"],
        conductorBurr: json["conductorBurr"],
        windowGap: json["windowGap"],
        crimpOnInsulation: json["crimpOnInsulation"],
        improperCrimping: json["improperCrimping"],
        tabBendOrTabOpen: json["tabBendOrTabOpen"],
        bellMouthLessOrMore: json["bellMouthLessOrMore"],
        cutOffLessOrMore: json["cutOffLessOrMore"],
        cutOffBurr: json["cutOffBurr"],
        cutOffBend: json["cutOffBend"],
        insulationDamage: json["insulationDamage"],
        exposureStrands: json["exposureStrands"],
        strandsCut: json["strandsCut"],
        brushLengthLessorMore: json["brushLengthLessorMore"],
        terminalCoppermark: json["terminalCoppermark"],
        setupRejections: json["setupRejections"],
        terminalBackOut: json["terminalBackOut"],
        cableDamage: json["cableDamage"],
        crimpingPositionOutOrMissCrimp: json["crimpingPositionOutOrMissCrimp"],
        terminalSeamOpen: json["terminalSeamOpen"],
        rollerMark: json["rollerMark"],
        lengthLessOrLengthMore: json["lengthLessOrLengthMore"],
        gripperMark: json["gripperMark"],
        endTerminal: json["endTerminal"],
        entangledCable: json["entangledCable"],
        troubleShootingRejections: json["troubleShootingRejections"],
        wireOverLoadRejectionsJam: json["wireOverLoadRejectionsJam"],
        halfCurlingA: json["halfCurling_A"],
        brushLengthLessOrMoreC: json["brushLengthLessOrMore_C"],
        exposureStrandsD: json["exposureStrands_D"],
        cameraPositionOutE: json["cameraPositionOut_E"],
        crimpOnInsulationF: json["crimpOnInsulation_F"],
        cablePositionMovementG: json["cablePositionMovement_G"],
        crimpOnInsulationC: json["crimpOnInsulation_C"],
        crimpingPositionOutOrMissCrimpD:
            json["crimpingPositionOutOrMissCrimp_D"],
        crimpPositionOut: json["crimpPositionOut"],
        stripPositionOut: json["stripPositionOut"],
        offCurling: json["offCurling"],
        cFmPfmRejections: json["cFM_PFM_Rejections"],
        incomingIssue: json["incomingIssue"],
        bladeMark: json["bladeMark"],
        crossCut: json["crossCut"],
        insulationBarrel: json["insulationBarrel"],
        method: json["method"],
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        awg: json["awg"],
        setUpRejections: json["setUpRejections"],
        setUpRejectionTerminalFrom: json["setUpRejectionTerminalFrom"],
        setUpRejectionTerminalTo: json["setUpRejectionTerminalTo"],
        cvmRejectionsCable: json["cvmRejectionsCable"],
        cvmRejectionsCableTerminalTo: json["cvmRejectionsCableTerminalTo"],
        cvmRejectionsCableTerminalFrom: json["cvmRejectionsCableTerminalFrom"],
        cfmRejectionsCable: json["cfmRejectionsCable"],
        cfmRejectionsCableTerminalTo: json["cfmRejectionsCableTerminalTo"],
        cfmRejectionsCableTerminalFrom: json["cfmRejectionsCableTerminalFrom"],
        endWire: json["endWire"],
        rejectionsTerminalTo: json["rejectionsTerminalTo"],
        rejectionsTerminalFrom: json["rejectionsTerminalFrom"],
        lengthVariation: json["lengthVariation"],
        stringLengthVariation: json["stringLengthVariation"],
        nickMark: json["nickMark"],
        bellMouthError: json["bellMouthError"],
        brushLengthLessMore: json["brushLengthLessMore"],
        wrongTerminal: json["wrongTerminal"],
        wrongCable: json["wrongCable"],
        seamOpen: json["seamOpen"],
        wrongCutLength: json["wrongCutLength"],
        missCrimp: json["missCrimp"],
        extrusionBurr: json["extrusionBurr"],
        crimpFromSchId: json["crimpFromSchId"],
        crimpToSchId: json["crimpToSchId"],
        preparationCompleteFlag: json["preparationCompleteFlag"],
        viCompleted: json["viCompleted"],
        processType: json["processType"],
      );

  Map<String, dynamic> toJson() => {
        "finishedGoods": finishedGoods ?? 0,
        "purchaseorder": purchaseorder ?? 0,
        "orderIdentification": orderIdentification,
        "cablePartNumber": cablePartNumber ?? 0,
        "cutLength": cutLength ?? 0,
        "color": color,
        "scheduleIdentification": scheduleIdentification ?? 0,
        "scheduledQuantity": scheduledQuantity ?? 0,
        "machineIdentification": machineIdentification,
        "operatorIdentification": operatorIdentification ?? 0,
        "bundleIdentification": bundleIdentification,
        "rejectedQuantity": rejectedQuantity ?? 0,
        "terminalDamage": terminalDamage ?? 0,
        "terminalBend": terminalBend ?? 0,
        "terminalTwist": terminalTwist ?? 0,
        "conductorCurlingUpDown": conductorCurlingUpDown ?? 0,
        "insulationCurlingUpDown": insulationCurlingUpDown ?? 0,
        "conductorBurr": conductorBurr ?? 0,
        "windowGap": windowGap ?? 0,
        "crimpOnInsulation": crimpOnInsulation ?? 0,
        "improperCrimping": improperCrimping ?? 0,
        "tabBendOrTabOpen": tabBendOrTabOpen ?? 0,
        "bellMouthLessOrMore": bellMouthLessOrMore ?? 0,
        "cutOffLessOrMore": cutOffLessOrMore ?? 0,
        "cutOffBurr": cutOffBurr ?? 0,
        "cutOffBend": cutOffBend ?? 0,
        "insulationDamage": insulationDamage ?? 0,
        "exposureStrands": exposureStrands ?? 0,
        "strandsCut": strandsCut ?? 0,
        "brushLengthLessorMore": brushLengthLessorMore ?? 0,
        "terminalCoppermark": terminalCoppermark ?? 0,
        "setupRejections": setupRejections ?? 0,
        "terminalBackOut": terminalBackOut ?? 0,
        "cableDamage": cableDamage ?? 0,
        "crimpingPositionOutOrMissCrimp": crimpingPositionOutOrMissCrimp ?? 0,
        "terminalSeamOpen": terminalSeamOpen ?? 0,
        "rollerMark": rollerMark ?? 0,
        "lengthLessOrLengthMore": lengthLessOrLengthMore ?? 0,
        "gripperMark": gripperMark ?? 0,
        "endTerminal": endTerminal ?? 0,
        "entangledCable": entangledCable ?? 0,
        "troubleShootingRejections": troubleShootingRejections ?? 0,
        "wireOverLoadRejectionsJam": wireOverLoadRejectionsJam ?? 0,
        "halfCurling_A": halfCurlingA ?? 0,
        "brushLengthLessOrMore_C": brushLengthLessOrMoreC ?? 0,
        "exposureStrands_D": exposureStrandsD ?? 0,
        "cameraPositionOut_E": cameraPositionOutE ?? 0,
        "crimpOnInsulation_F": crimpOnInsulationF ?? 0,
        "cablePositionMovement_G": cablePositionMovementG ?? 0,
        "crimpOnInsulation_C": crimpOnInsulationC ?? 0,
        "crimpingPositionOutOrMissCrimp_D":
            crimpingPositionOutOrMissCrimpD ?? 0,
        "crimpPositionOut": crimpPositionOut ?? 0,
        "stripPositionOut": stripPositionOut ?? 0,
        "offCurling": offCurling ?? 0,
        "cFM_PFM_Rejections": cFmPfmRejections ?? 0,
        "incomingIssue": incomingIssue ?? 0,
        "bladeMark": bladeMark ?? 0,
        "crossCut": crossCut ?? 0,
        "insulationBarrel": insulationBarrel ?? 0,
        "method": method,
        "terminalFrom": terminalFrom ?? 0,
        "terminalTo": terminalTo ?? 0,
        "awg": awg,
        "setUpRejections": setUpRejections ?? 0,
        "setUpRejectionTerminalFrom": setUpRejectionTerminalFrom ?? 0,
        "setUpRejectionTerminalTo": setUpRejectionTerminalTo ?? 0,
        "cvmRejectionsCable": cvmRejectionsCable ?? 0,
        "cvmRejectionsCableTerminalTo": cvmRejectionsCableTerminalTo ?? 0,
        "cvmRejectionsCableTerminalFrom": cvmRejectionsCableTerminalFrom ?? 0,
        "cfmRejectionsCable": cfmRejectionsCable ?? 0,
        "cfmRejectionsCableTerminalTo": cfmRejectionsCableTerminalTo ?? 0,
        "cfmRejectionsCableTerminalFrom": cfmRejectionsCableTerminalFrom ?? 0,
        "endWire": endWire ?? 0,
        "rejectionsTerminalTo": rejectionsTerminalTo ?? 0,
        "rejectionsTerminalFrom": rejectionsTerminalFrom ?? 0,
        "lengthVariation": lengthVariation ?? 0,
        "stringLengthVariation": stringLengthVariation ?? 0,
        "nickMark": nickMark ?? 0,
        "bellMouthError": bellMouthError ?? 0,
        "brushLengthLessMore": brushLengthLessMore ?? 0,
        "wrongTerminal": wrongTerminal ?? 0,
        "wrongCable": wrongCable ?? 0,
        "seamOpen": seamOpen ?? 0,
        "wrongCutLength": wrongCutLength ?? 0,
        "missCrimp": missCrimp ?? 0,
        "extrusionBurr": extrusionBurr ?? 0,
        "crimpFromSchId": crimpFromSchId??"",
        "crimpToSchId": crimpToSchId??'',
        "preparationCompleteFlag": preparationCompleteFlag??'0',
        "viCompleted": viCompleted??'0',
        "processType": processType,
      };
}

// To parse this JSON data, do
//
//     final responseGenerateLabel = responseGenerateLabelFromJson(jsonString);

// To parse this JSON data, do
//
//     final responseGenerateLabel = responseGenerateLabelFromJson(jsonString);

ResponseGenerateLabel responseGenerateLabelFromJson(String str) =>
    ResponseGenerateLabel.fromJson(json.decode(str));

String responseGenerateLabelToJson(ResponseGenerateLabel data) =>
    json.encode(data.toJson());

class ResponseGenerateLabel {
  ResponseGenerateLabel({
    required this.status,
    required this.statusMsg,
    this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  dynamic errorCode;
  Data data;

  factory ResponseGenerateLabel.fromJson(Map<String, dynamic> json) =>
      ResponseGenerateLabel(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.generateLabel,
  });

  GeneratedLabel generateLabel;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        generateLabel: GeneratedLabel.fromJson(json[" Generate Label "]),
      );

  Map<String, dynamic> toJson() => {
        " Generate Label ": generateLabel.toJson(),
      };
}

class GeneratedLabel {
  GeneratedLabel({
    required this.finishedGoods,
    required this.cablePartNumber,
    required this.cutLength,
    required this.wireGauge,
    required this.terminalFrom,
    required this.terminalTo,
    required this.bundleQuantity,
    required this.routeNo,
    required this.bundleId,
    required this.status,
  });

  int finishedGoods;
  int cablePartNumber;
  int cutLength;
  String wireGauge;
  int terminalFrom;
  int terminalTo;
  int bundleQuantity;
  String routeNo;
  String bundleId;
  int status;

  factory GeneratedLabel.fromJson(Map<String, dynamic> json) => GeneratedLabel(
        finishedGoods: json["finishedGoods"],
        cablePartNumber: json["cablePartNumber"],
        cutLength: json["cutLength"],
        wireGauge: json["wireGauge"],
        terminalFrom: json["terminalFrom"],
        terminalTo: json["terminalTo"],
        bundleQuantity: json["bundleQuantity"],
        routeNo: json["routeNo"],
        bundleId: json["bundleId"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "finishedGoods": finishedGoods,
        "cablePartNumber": cablePartNumber,
        "cutLength": cutLength,
        "wireGauge": wireGauge,
        "terminalFrom": terminalFrom,
        "terminalTo": terminalTo,
        "bundleQuantity": bundleQuantity,
        "routeNo": routeNo,
        "bundleId": bundleId,
        "status": status,
      };
}

// To parse this JSON data, do
//
//     final errorGenerateLabel = errorGenerateLabelFromJson(jsonString);

ErrorGenerateLabel errorGenerateLabelFromJson(String str) =>
    ErrorGenerateLabel.fromJson(json.decode(str));

String errorGenerateLabelToJson(ErrorGenerateLabel data) =>
    json.encode(data.toJson());

class ErrorGenerateLabel {
  ErrorGenerateLabel({
    required this.status,
    required this.statusMsg,
    required this.errorCode,
    required this.data,
  });

  String status;
  String statusMsg;
  String errorCode;
  Data1 data;

  factory ErrorGenerateLabel.fromJson(Map<String, dynamic> json) =>
      ErrorGenerateLabel(
        status: json["status"],
        statusMsg: json["statusMsg"],
        errorCode: json["errorCode"],
        data: Data1.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusMsg": statusMsg,
        "errorCode": errorCode,
        "data": data.toJson(),
      };
}

class Data1 {
  Data1();

  factory Data1.fromJson(Map<String, dynamic> json) => Data1();

  Map<String, dynamic> toJson() => {};
}
