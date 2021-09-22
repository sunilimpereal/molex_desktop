import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:molex_desktop/model_api/Preparation/getpreparationSchedule.dart';
import 'package:molex_desktop/model_api/Preparation/postPreparationDetail.dart';
import 'package:molex_desktop/model_api/Transfer/binToLocation_model.dart';
import 'package:molex_desktop/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex_desktop/model_api/Transfer/getBinDetail.dart';
import 'package:molex_desktop/model_api/Transfer/postgetbundleMaster.dart';
import 'package:molex_desktop/model_api/cableDetails_model.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/crimping/bundleDetail.dart';
import 'package:molex_desktop/model_api/crimping/crimpError.dart';
import 'package:molex_desktop/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex_desktop/model_api/crimping/getbundleQtyCrimp.dart';
import 'package:molex_desktop/model_api/crimping/postCrimprejectedDetail.dart';
import 'package:molex_desktop/model_api/crimping/resPostCrimpRejectDetail.dart';
import 'package:molex_desktop/model_api/fgDetail_model.dart';
import 'package:molex_desktop/model_api/generateLabel_model.dart';
import 'package:molex_desktop/model_api/getuserId.dart';
import 'package:molex_desktop/model_api/kitting_plan/getKittingData_model.dart';
import 'package:molex_desktop/model_api/kitting_plan/save_kitting_model.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingTerminalA_model.dart';
import 'package:molex_desktop/model_api/materialTrackingTerminalB_model.dart';
import 'package:molex_desktop/model_api/partiallyComplete_model.dart';
import 'package:molex_desktop/model_api/postReturnMaterial.dart';
import 'package:molex_desktop/model_api/postrawmatList_model.dart';
import 'package:molex_desktop/model_api/process1/100Complete_model.dart';
import 'package:molex_desktop/model_api/process1/getbundleListGl.dart';
import 'package:molex_desktop/model_api/rawMaterialDetail_model.dart';
import 'package:molex_desktop/model_api/rawMaterial_modal.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/startProcess_model.dart';
import 'package:molex_desktop/model_api/visualInspection/VI_scheduler_model.dart';
import 'package:molex_desktop/model_api/visualInspection/saveinspectedBundle_model.dart';

import 'package:path_provider/path_provider.dart';

import '../main.dart';

class ApiService {
  String? baseUrl = "${sharedPref.baseIp}";

  // String ? baseUrl = "http://10.221.46.8:8080/wipts/";
  // String ? baseUrl = "http://192.168.1.252:8080/wipts/";

  // String ? baseUrl = 'http://mlxbngvwqwip01.molex.com:8080/wipts/';
  Map<String, String> headerList = {
    "Content-Type": "application/json",
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br,*",
    "Connection": "keep-alive",
    "Keep-Alive": "timeout=0",
  };
  //open null empty

  Future<Employee?> empIdlogin(String? empId) async {
    var url =
        Uri.parse(baseUrl! + "molex/employee/get-employee-list/empid=$empId");
    var response = await http.get(url);
    log('Login  status Code ${response.statusCode}');
    log('Login  status Code ${response.body}');
    if (response.statusCode == 200) {
      try {
        Login login = loginFromJson(response.body);
        Employee? empolyee = login.data?.employeeList;
        return empolyee;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<Schedule>?> getScheduelarData(
      {String? machId, String? type, String? sameMachine}) async {
    print("called api");
    print("called $machId");
    print("called $type");
    // var url = Uri.parse(baseUrl +
    //     "molex/scheduler/get-scheduler-same-machine-data?schdTyp=A&mchNo=$machId&sameMachine=true");
    var url = Uri.parse(baseUrl! +
        "molex/scheduler/get-scheduler-same-machine-data?schdTyp=$type&mchNo=$machId&sameMachine=$sameMachine");
    log("url : molex/scheduler/get-scheduler-same-machine-data?schdTyp=$type&mchNo=$machId&sameMachine=$sameMachine");
    var response = await http.get(url);
    log('schedular data status code ${response.statusCode}');
    log('schedular data ${response.body}');
    if (response.statusCode == 200) {
      Schedular schedualr = schedularFromJson(response.body);
      log(" sch data ${response.body}");
      List<Schedule>? scheduleList = schedualr.data?.employeeList;
      return scheduleList;
    } else {
      return [];
    }
  }
  //Update Schedular Tracker information data POST method

  Future<List<MachineDetails>?> getmachinedetails(String? machineid) async {
    print('sad');
    var url = Uri.parse(
        baseUrl! + "molex/machine/get-by-machine-number?machNo=$machineid");
    var response = await http.get(url);
    print('Machine details status code ${response.body}');
    if (response.statusCode == 200) {
      try {
        GetMachineDetails getMachineDetails =
            getMachineDetailsFromJson(response.body);
        List<MachineDetails>? machineDetails =
            getMachineDetails.data?.machineDetailsList;
        return machineDetails!.length != 0 ? machineDetails : null;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  List<RawMaterial> sortRaw(List<RawMaterial> rawmaterial) {
    RawMaterial temp = new RawMaterial();
    List<RawMaterial> newList = [];
    for (RawMaterial rawmat in rawmaterial) {
      if (temp.partNunber == rawmat.partNunber) {
        temp.requireQuantity = (double?.parse(temp.requireQuantity ?? '') +
                double?.parse(rawmat.requireQuantity ?? ''))
            .toString();
        temp.toatalScheduleQuantity =
            (double?.parse(temp.toatalScheduleQuantity ?? '') +
                    double?.parse(rawmat.toatalScheduleQuantity ?? ''))
                .toString();
        newList.removeLast();

        newList.add(temp);
      } else {
        newList.add(rawmat);
        temp = rawmat;
        // s
      }
    }
    return newList;
  }
  
  Future<List<RawMaterial>> rawMaterial(
      {String? machineId,
      String? partNo,
      String? fgNo,
      String? scheduleId,
      String? type}) async {
    print('fgpart : ${fgNo}');
    print('schedule: ${scheduleId}');
    print('machineID: ${machineId}');
    //TODO : variables in api
    var urlcable = Uri.parse(baseUrl! +
        "molex/scheduler/get-req-material-detail?machId=$machineId&fgNo=$fgNo&schdId=$scheduleId");
    var urlfrom = Uri.parse(baseUrl! +
        "molex/scheduler/get-req-material-detail-from?machId=$machineId&fgNo=$fgNo&schdId=$scheduleId");
    var urlto = Uri.parse(baseUrl! +
        "molex/scheduler/get-req-material-detail-to?machId=$machineId&fgNo=$fgNo&schdId=$scheduleId");
    var responsecable = await http.get(urlcable);
    var responsefrom = await http.get(urlfrom);
    var responseto = await http.get(urlto);
    log('Raw Material cable status code ${responsecable.body}');
    log('Raw Material from status code ${responsefrom.body}');
    log('Raw Material to status code ${responseto.body}');
    if (responseto.statusCode == 200) {
      try {
        print(responseto.body);
        GetRawMaterial getrawMaterialto =
            getRawMaterialFromJson(responseto.body);

        GetRawMaterial getrawMaterialfrom =
            getRawMaterialFromJson(responsefrom.body);
        print(responsefrom.body);
        GetRawMaterial getrawMaterialcable =
            getRawMaterialFromJson(responsecable.body);
        print(responsecable.body);
        List<RawMaterial>? rawmaterialListcable =
            getrawMaterialcable.data?.rawMaterialDetails;
        List<RawMaterial>? rawmaterialListto =
            getrawMaterialto.data?.rawMaterialDetails;
        List<RawMaterial>? rawmaterialListfrom =
            getrawMaterialfrom.data?.rawMaterialDetails;

        List<RawMaterial> rawMateriallist = [];
        if (type == "Automatic Cut & Crimp") {
          rawMateriallist =
              rawmaterialListcable! + rawmaterialListto! + rawmaterialListfrom!;
          rawMateriallist = rawMateriallist
              .where((element) => element.partNunber != "0")
              .toList();
          rawMateriallist = sortRaw(rawMateriallist);
        }
        if (type!.contains("Cutting")) {
          rawMateriallist = rawmaterialListcable!;
          rawMateriallist = rawMateriallist
              .where((element) => element.partNunber != "0")
              .toList();
          rawMateriallist = sortRaw(rawMateriallist);
        }
        if (type.contains("Crimping")) {
          rawMateriallist = (rawmaterialListto! + rawmaterialListfrom!);
          rawMateriallist = rawMateriallist
              .where((element) => element.partNunber != "0")
              .toList();
          rawMateriallist = sortRaw(rawMateriallist);
        }

        print(rawMateriallist);
        return rawMateriallist;
      } catch (e) {
        print('error $e');
        return [];
      }
    } else {
      return [];
    }
  }

  // Get Raw material detail
  // check where this goes
  Future<RawMaterialDetail?> getRawmaterialDetail(String? partNo) async {
    var url = Uri.parse(baseUrl =
        "molex/ejobticketmaster/get-raw=material-for-add?PartNo=$partNo");
    var response = await http.get(url);
    print('Raw Material details status code ${response.statusCode}');
    if (response.statusCode == 200) {
      GetRawMaterialDetail getRawMaterialDetail =
          getRawMaterialDetailFromJson(response.body);
      RawMaterialDetail? rawMaterialDetail =
          getRawMaterialDetail.data?.addRawMaterialRequiredDetails;
      return rawMaterialDetail;
    } else {
      return null;
    }
  }

  // Reqired raw material detail save data POST Method
  Future<bool> postRawmaterial(
      List<PostRawMaterial> postRawmaterialList) async {
    var url = Uri.parse(baseUrl! + "molex/materialldg/post-req-material");
    final response = await http.post(url,
        body: postRawMaterialListToJson(postRawmaterialList),
        headers: headerList);
    print('post raw material ${response.statusCode}');
    log('post raw material body ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<FgDetails?> getFgDetails(String? partNo) async {
    var url = Uri.parse(
        baseUrl! + 'molex/ejobticketmaster/fgDetails-byfgNo?fgPartNo=$partNo');
    var response = await http.get(url);
    log('Fg  details status code $partNo ${response.statusCode}');
    log('Fg  details status response  ${response.body}');
    if (response.statusCode == 200) {
      print(response.body);
      GetFgDetails getFgDetails = getFgDetailsFromJson(response.body);
      FgDetails? fgDetails = getFgDetails.data?.getFgDetaials;
      return fgDetails;
    } else {
      return null;
    }
  }

  // Get material Tracking cable Detail
  Future<List<MaterialDetail>?> getMaterialTrackingCableDetail(
      MatTrkPostDetail matTrkPostDetail) async {
    var url =
        Uri.parse(baseUrl! + "molex/materialldg/get-material-cable-detail");
    log('getMaterialTrackingCableDetail post body details ${matTrkPostDetailToJson(matTrkPostDetail)} ');
    var response = await http.post(url,
        body: matTrkPostDetailToJson(matTrkPostDetail), headers: headerList);
    log('getMaterialTrackingCableDetail details status code ${response.statusCode}');
    log('getMaterialTrackingCableDetail details status code ${response.body}');
    if (response.statusCode == 200) {
      MatTrkDetail matTrkDetail = matTrkDetailFromJson(response.body);
      List<MaterialDetail>? materilDetailList = matTrkDetail.data!.material;
      return materilDetailList;
    } else {
      return [];
    }
  }

  //Get Cable Details
  Future<CableDetails?> getCableDetails(
      {String? fgpartNo,
      String? cablepartno,
      String? length,
      String? color,
      int? awg}) async {
    var url = Uri.parse(baseUrl! +
        "molex/ejobticketmaster/get-cable-Details-bycableNo?fgPartNo=$fgpartNo&cblPartNo=$cablepartno&length=$length&color=$color&awg=$awg");
    var response = await http.get(url);
    print('Cable details status code ${response.statusCode}');
    if (response.statusCode == 200) {
      GetCableDetail getCableDetails = getCableDetailFromJson(response.body);
      CableDetails? cableDetails = getCableDetails.data?.findCableDetails;
      return cableDetails;
    } else {
      return null;
    }
  }

  //cableTerminalA
  Future<CableTerminalA?> getCableTerminalA(
      {String? cablepartno,
      String? fgpartNo,
      String? length,
      String? color,
      int? awg}) async {
    //TODO variable in url
    print("cable No TA : $cablepartno");
    var url = Uri.parse(baseUrl! +
        "molex/ejobticketmaster/get-cable-terminalA-bycableNo?fgPartNo=$fgpartNo&cblPartNo=$cablepartno&length=$length&color=$color&awg=$awg");
    var response = await http.get(url);
    log('Cable termianl A url molex/ejobticketmaster/get-cable-terminalA-bycableNo?cblPartNo=$cablepartno&length=$length&color=$color&awg=$awg');
    log('Cable termianl A status code ${response.statusCode}');
    log('Cable termianl A status code ${response.body}');
    if (response.statusCode == 200) {
      GetCableTerminalA getCableTerminalA =
          getCableTerminalAFromJson(response.body);
      CableTerminalA? cableTerminalA =
          getCableTerminalA.data?.findCableTerminalADto;
      return cableTerminalA;
    } else {
      return null;
    }
  }

  //CableTerminalB
  Future<CableTerminalB?> getCableTerminalB(
      {String? fgpartNo,
      String? cablepartno,
      String? length,
      String? color,
      int? awg}) async {
    var url = Uri.parse(baseUrl! +
        'molex/ejobticketmaster/get-cable-terminalB-bycableNo?fgPartNo=$fgpartNo&cblPartNo=$cablepartno&length=$length&color=$color&awg=$awg');
    var response = await http.get(url, headers: headerList);
    print('Cable termianl B status code ${response.statusCode}');
    print('Cable termianl B body: ${response.body}');
    if (response.statusCode == 200) {
      GetCableTerminalB getCableTerminalB =
          getCableTerminalBFromJson(response.body);
      var getCableTerminalB2 = getCableTerminalB;
      var getCableTerminalB22 = getCableTerminalB2;
      CableTerminalB? cableTerminalB =
          getCableTerminalB22.data?.findCableTerminalBDto;
      return cableTerminalB;
    } else {
      CableTerminalB cableTerminalB = new CableTerminalB();
      return cableTerminalB;
    }
  }

  //Start Process
  Future<bool> startProcess1(PostStartProcessP1 process) async {
    var url = Uri.parse(baseUrl! +
        "molex/schedule-start-tracking/start-process-save-in-schedule-tracking");
    var response = await http.post(url,
        body: postStartProcessP1ToJson(process), headers: headerList);
    print("start proces response = ${response.statusCode}");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //MaterialTrackingTerminalA
  Future<List<MaterialTrackingTerminalA>?> getMaterialtrackingterminalA(
      String? partNo) async {
    var url = Uri.parse(baseUrl! +
        'molex/material-tracking/tracking-cable-terminalA?partNo=$partNo');
    var response = await http.get(url);
    print('Cable termianl A status code ${response.statusCode}');
    if (response.statusCode == 200) {
      GetMaterialTrackingTerminalA getMaterialTrackingTerminalA =
          getMaterialTrackingTerminalAFromJson(response.body);
      List<MaterialTrackingTerminalA>? materialTrackingtermianlAList =
          getMaterialTrackingTerminalA.data?.materialTrackingTerminalA;
      return materialTrackingtermianlAList;
    } else {
      return null;
    }
  }

  //MaterialTrackingTerminalB
  Future<List<MaterialTrackingTerminalB>?> getMaterialtrackingterminalB(
      String? partNo) async {
    var url = Uri.parse(baseUrl! +
        'molex/material-tracking/tracking-cable-terminalB?partNo=$partNo');
    var response = await http.get(url);
    print('Cable termianl A status code ${response.statusCode}');
    if (response.statusCode == 200) {
      GetMaterialTrackingTerminalB getMaterialTrackingTerminalB =
          getMaterialTrackingTerminalBFromJson(response.body);
      List<MaterialTrackingTerminalB>? materialTrackingtermianlBList =
          getMaterialTrackingTerminalB.data?.materialTrackingTerminalB;
      return materialTrackingtermianlBList;
    } else {
      return null;
    }
  }

  // get bundle in schedule
  Future<List<BundlesRetrieved>?> getBundlesInSchedule(
      {PostgetBundleMaster? postgetBundleMaster,
      required String scheduleID}) async {
    var url = Uri.parse(baseUrl! + 'molex/bundlemaster/');
    var response = await http.post(url,
        body: postgetBundleMasterToJson(postgetBundleMaster!),
        headers: headerList);
    log('Get Bundles From Bin status Code: ${response.statusCode}');
    log('Get Bundleslist From Bin  response body :${response.body}');
    log('Get Bundleslistp From Bin  response body :${postgetBundleMasterToJson(postgetBundleMaster)}');
    if (response.statusCode == 200) {
      GetBundleListGl getBundleListGl = getBundleListGlFromJson(response.body);
      List<BundlesRetrieved> bundleList = getBundleListGl.data.bundlesRetrieved;
      bundleList = bundleList
          .where((element) => element.scheduledId.toString() == scheduleID
              // element.cablePartNumber.toString() == cablePartNumber &&
              // element.orderId == orderID &&
              // element.finishedGoodsPart.toString() == finishedGoods

              )
          .toList();
      return bundleList;
    } else {
      Fluttertoast.showToast(
        msg: "Unable to Find Bin",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  //BundleQuantity api Json missing
  //TODO
  // Generate label request model POst method
  Future<GeneratedLabel?> postGeneratelabel(
      PostGenerateLabel postGenerateLabel, String? bundleQuantiy) async {
    var url =
        Uri.parse(baseUrl! + 'molex/wccr/generate-label/bdQty=$bundleQuantiy');
    print(
        'body generate label :${postGenerateLabelToJson(postGenerateLabel)} ');
    var response = await http.post(url,
        body: postGenerateLabelToJson(postGenerateLabel), headers: headerList);
    print("response post generate label ${response.body}");

    if (response.statusCode == 200) {
      try {
        GeneratedLabel? generatedLabel =
            responseGenerateLabelFromJson(response.body).data?.generateLabel;
        return generatedLabel;
      } catch (e) {
        try {
          ErrorGenerateLabel errorGenerateLabel =
              errorGenerateLabelFromJson(response.body);
          AlertController.show(
            "Error Generating Label",
            "${errorGenerateLabel.statusMsg}",
            TypeAlert.error,
          );
          Fluttertoast.showToast(
            msg: "${errorGenerateLabel.status}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return null;
        } catch (e) {
          return null;
        }
      }
    } else {
      AlertController.show(
        "Generate label status ${response.statusCode}",
        "",
        TypeAlert.error,
      );
      Fluttertoast.showToast(
        msg: "Generate label status ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  //Transfer Bundle to bin
  Future<List<BundleTransferToBin>?> postTransferBundletoBin(
      {required List<TransferBundleToBin> transferBundleToBin}) async {
    var url = Uri.parse(
        baseUrl! + 'molex/bin-tracking/transfer-bundle-to-bin-tracking');
    print(
        'post Transfer Bundle to bin :${transferBundleToBinToJson(transferBundleToBin)} ');
    var response = await http.post(url,
        body: transferBundleToBinToJson(transferBundleToBin),
        headers: headerList);
    log("status post Transfer Bundle to bin ${response.statusCode}");
    log("response post Transfer Bundle to bin ${response.body}");
    if (response.statusCode == 200) {
      try {
        List<BundleTransferToBin>? b =
            responseTransferBundletoBinFromJson(response.body)
                .data!
                .bundleTransferToBinTracking;
        return b;
      } catch (e) {
        Fluttertoast.showToast(
          msg: "status : parse error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      }
    } else {
      Fluttertoast.showToast(
        msg: "bundle transfer api status ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  //Post transfer bin to location
  Future<List<BinTransferToLocationTracking>?> postTransferBinToLocation(
      List<TransferBinToLocation> transferBinToLocationList) async {
    var url =
        Uri.parse(baseUrl! + 'molex/bin-tracking/update-bin-location-in-bin');
    log('post Transfer BIn to Location :${transferBinToLocationToJson(transferBinToLocationList)} ');
    var response = await http.post(url,
        body: transferBinToLocationToJson(transferBinToLocationList),
        headers: headerList);
    print("status post Transfer Bin To Location ${response.statusCode}");
    print("response post Transfer Bin to Location ${response.body}");
    if (response.statusCode == 200) {
      try {
        List<BinTransferToLocationTracking>? b =
            responseTransferBinToLocationFromJson(response.body)
                .data!
                .bundleTransferToBinTracking;
        return b;
      } catch (e) {
        print("error");
        ErrorTransferBinToLocation errorTransferBinToLocation =
            errorTransferBinToLocationFromJson(response.body);

        Fluttertoast.showToast(
          msg: "status ${errorTransferBinToLocation.status}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      }
    } else {
      return null;
    }
  }

  // CountBundleQty api Json missing
  //TODO
  // Click on 9999 return value bndle id List api Json missing
  // 100% complete  post method
  Future<bool> post100Complete(FullyCompleteModel postFullyComplete) async {
    var url =
        Uri.parse(baseUrl! + 'molex/production-report/save-production-report');
    var response = await http.post(url,
        body: fullyCompleteModelToJson(postFullyComplete), headers: headerList);
    log("Production Report Post status ${response.statusCode}");
    log(fullyCompleteModelToJson(postFullyComplete) ?? '');
    Fluttertoast.showToast(
      msg: "Production Report Post status ${response.statusCode}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Post Completion data failed status ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  // partially complete post method
  Future<bool> postpartialComplete(
      PostpartiallyComplete postpartiallyComplete, int? awg) async {
    var url = Uri.parse(baseUrl! +
        'molex/partial-completion-reason/save-in-partial-completion-reason/$awg');
    var response = await http.post(url,
        body: postpartiallyCompleteToJson(postpartiallyComplete),
        headers: headerList);
    log("post partial report  ${postpartiallyCompleteToJson(postpartiallyComplete)}");
    log("partial report  ${response.body}");
    if (response.statusCode == 200) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg:
              "Post Partial Completion data failed status ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  // Future<bool> postpartialComplete(
  // Location Updation PUT method

//Visual Inspection
//
//get Visual inspection Data ?
//TODO VISUAL INSPECTION
  Future<List<ViScheduler>?> getviSchedule() async {
    var url = Uri.parse(
        baseUrl! + 'molex/visual-inspection/get-visual-inspection-data');
    var response = await http.get(url);
    print('ViScheduler status Code: ${response.statusCode}');
    print(response.body);
    if (response.statusCode == 200) {
      GetViSchedule getViSchedule = getViScheduleFromJson(response.body);
      List<ViScheduler>? viScheduleList =
          getViSchedule.data?.visualInspectionScheduler;
      return viScheduleList;
    } else {
      return [];
    }
  }

// Post ViSchedule data
  Future<bool> postVIinspectedBundle(
      {required ViInspectedbundle viInspectedbudle}) async {
    log("postVIinspectedBundle :${viInspectedbudleQtyToJson(viInspectedbudle)}");
    var url = Uri.parse(baseUrl! +
        'molex/visual-inspection/save-visual-inspected-bundle-quantity');
    var response = await http.post(url,
        body: viInspectedbudleQtyToJson(viInspectedbudle), headers: headerList);
    log("postVIinspectedBundle :${viInspectedbudleQtyToJson(viInspectedbudle)}");
    log('postVIinspectedBundle status Code: ${response.statusCode}');
    log('postVIinspectedBundle response status body: ${response.body}');
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<PreparationSchedule>?> getPreparationSchedule(
      {String? type, String? machineNo}) async {
    var url = Uri.parse(baseUrl! +
        'molex/preparation/get-preparation-schedule-data?scheduleType=$type&machineNumber=$machineNo&sameMachine=true');
    var response = await http.get(url);
    print('Get Preparation Schedule status Code: ${response.statusCode}');
    print(response.body);
    if (response.statusCode == 200) {
      GetpreparationShedule getpreparationShedule =
          getpreparationSheduleFromJson(response.body);
      List<PreparationSchedule>? preparationList =
          getpreparationShedule.data?.preparationProcessData;
      return preparationList;
    } else {
      return [];
    }
  }

  //post Visual Inspected Data ?
  Future<bool> postPreparationDetail(
      {required PostPreparationDetail postPreparationDetail}) async {
    var url = Uri.parse(
        baseUrl! + 'molex/preparation/save-preparation-rejected-detail');

    var response = await http.post(url,
        body: postPreparationDetailToJson(postPreparationDetail),
        headers: headerList);
    log("postPreparationDetail :${postPreparationDetailToJson(postPreparationDetail)}");
    print('postPreparationDetail status Code: ${response.statusCode}');
    log('postPreparationDetail status body: ${response.body}');
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

// CRIMPING API
  // crimping Schedule
  Future<List<CrimpingSchedule>?> getCrimpingSchedule(
      {String? scheduleType, String? machineNo, String? sameMachine}) async {
    var url = Uri.parse(baseUrl! +
        'molex/crimping/get-bundle-detail?machineNo=$machineNo&scheduleType=$scheduleType&sameMachine=$sameMachine');
    var response = await http.get(url);
    print('Get Crimping Schedule status Code: ${response.statusCode}');
    log('crimping schedule response :${response.body}');
    if (response.statusCode == 200) {
      GetCrimpingSchedule getCrimpingSchedule =
          getCrimpingScheduleFromJson(response.body);
      List<CrimpingSchedule>? crimpingScheduleList =
          getCrimpingSchedule.data?.crimpingBundleList;
      log(" aa $crimpingScheduleList");
      return crimpingScheduleList;
    } else {
      return [];
    }
  }

  // Scan bundle Get Quantity
  Future<String?> scaBundleGetQty({String? bundleID}) async {
    var url = Uri.parse(
        baseUrl! + 'molex/crimping/get-bundle-quantity?bundleId=$bundleID');
    var response = await http.get(url);
    print('Get BundleQty from Id status Code: ${response.statusCode}');
    print('bundle Scan schedule response :${response.body}');
    if (response.statusCode == 200) {
      try {
        GetBundleQtyCrimp getScanBundleId =
            getBundleQtyCrimpFromJson(response.body);
        String? qty =
            getScanBundleId.data?.crimpingProcess![0].bundleQuantity.toString();
        return qty;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  //post crimping rejected Quantity
  Future<CrimpingResponse?> postCrimpRejectedQty(
      PostCrimpingRejectedDetail postCrimpingRejectedDetail) async {
    log('Post Rejected  body :${postCrimpingRejectedDetailToJson(postCrimpingRejectedDetail)}');
    var url =
        Uri.parse(baseUrl! + 'molex/crimping/save-crimping-rejected-detal');
    var response = await http.post(url,
        body: postCrimpingRejectedDetailToJson(postCrimpingRejectedDetail),
        headers: headerList);
    print('Post Rejected status Code: ${response.statusCode}');
    print('Post Rejected response body :${response.body}');
    if (response.statusCode == 200) {
      try {
        ResponsePostCrimpingDetail resPostCrimpingRejectedDetail =
            responsePostCrimpingDetailFromJson(response.body);
        CrimpingResponse? crimpingRejectDetail =
            resPostCrimpingRejectedDetail.data?.crimpingProcess;
        return crimpingRejectDetail;
      } catch (e) {
        CrimpRejectionError crimpRejectionError =
            crimpRejectionErrorFromJson(response.body);

        Fluttertoast.showToast(
          msg: "${crimpRejectionError.status}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Post Crimping Reject Deatil Status ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  Future<List<Userid>?> getUserList() async {
    var url = Uri.parse(baseUrl! + 'molex/employee/get-user-id');
    var response = await http.get(url);
    print('Post Rejected status Code: ${response.statusCode}');
    print('Post Rejected response body :${response.body}');
    if (response.statusCode == 200) {
      GetUser getuserId = getUserFromJson(response.body);
      List<Userid>? userIdList = getuserId.data?.userId;
      return userIdList;
    } else {
      return null;
    }
  }

  //Get bundle Detail
  Future<BundleData?> getBundleDetail(String? bundleId) async {
    var url = Uri.parse(
        baseUrl! + 'molex/material-codinator/getbundle?bundleId=$bundleId');
    var response = await http.get(url);
    print('Get Bundle Data ? status Code: ${response.statusCode}');
    print('Get Bundle Data ?  response body :${response.body}');
    if (response.statusCode == 200) {
      try {
        GetBundleDetail getBundleDetail =
            getBundleDetailFromJson(response.body);
        BundleData? bundleDetail = getBundleDetail.data?.bundleData;
        return bundleDetail;
      } catch (e) {
        return null;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Unable to Find Bundle",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  Future<List<BundleDetail>?> getBundlesinBin(String binId) async {
    var url = Uri.parse(baseUrl! +
        'molex/material-codinator/material-codinator-ytbp-data?binId=$binId');
    var response = await http.get(url);
    log('Get Bundles From Bin status Code: ${response.statusCode}');
    log('Get Bundles From Bin  response body :${response.body}');
    if (response.statusCode == 200) {
      GetBinDetail getBinDetail = getBinDetailFromJson(response.body);
      List<BundleDetail>? bundleList =
          getBinDetail.data!.materialCodinatorSchedulerData;
      log("#bunlist $bundleList");
      return bundleList;
    } else {
      AlertController.show(
        "Unable to Find Bin",
        "",
        TypeAlert.error,
      );
      Fluttertoast.showToast(
        msg: "Unable to Find Bin",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  //Kitting
  Future<List<KittingEJobDtoList>?> getkittingDetail(
      PostKittingData postKittingData) async {
    var url = Uri.parse(baseUrl! + 'molex/kitting/get-kitting-data');
    var response = await http.post(url,
        body: postKittingDataToJson(postKittingData), headers: headerList);
        log('getkittingDetail body: ${postKittingDataToJson(postKittingData)}');
    log('getkittingDetail status Code: ${response.statusCode}');
    log('getkittingDetail Bin  response body :${response.body}');
    if (response.statusCode == 200) {
      GetKittingData kittingData = getKittingDataFromJson(response.body);
      List<KittingEJobDtoList>? kitList =
          kittingData.data?.kittingDetail!.kittingEJobDtoList;
      return kitList;
    } else {
      AlertController.show(
        "Unable to Find Data ? status Code: ${response.statusCode}",
        "",
        TypeAlert.warning,
      );
      return null;
    }
  }

  //post kitting data
  Future<bool> postKittingData(List<SaveKitting> saveKitting) async {
    log('Save Kitting data body :${saveKittingToJson(saveKitting)}');
    var url = Uri.parse(baseUrl! + 'molex/kitting');
    var response = await http.post(url,
        body: saveKittingToJson(saveKitting), headers: headerList);
    print('Post Rejected status Code: ${response.statusCode}');
    print('Post Rejected response body :${response.body}');
    if (response.statusCode == 200) {
      try {
        AlertController.show(
          "Post Kitting  saved status code ${response.statusCode}",
          "",
          TypeAlert.success,
        );

        return true;
      } catch (e) {
        CrimpRejectionError crimpRejectionError =
            crimpRejectionErrorFromJson(response.body);
        AlertController.show(
          "${crimpRejectionError.status}",
          "",
          TypeAlert.warning,
        );

        return false;
      }
    } else {
      AlertController.show(
        "Post Kitting status code ${response.statusCode}",
        "",
        TypeAlert.error,
      );

      return false;
    }
  }

  Future<bool> postreturnRawMaterial(
      PostReturnMaterial postReturnMaterial) async {
    log('post return raw material data body :${postReturnMaterialToJson(postReturnMaterial)}');
    var url = Uri.parse(baseUrl! + 'molex/materialldg//update-used-quantity');
    var response = await http.put(url,
        body: postReturnMaterialToJson(postReturnMaterial),
        headers: headerList);
    print('post return raw material status Code: ${response.statusCode}');
    print('post return raw material  response body :${response.body}');
    if (response.statusCode == 200) {
      try {
         AlertController.show(
          " Return Raw Material  saved status code ${response.statusCode}",
          "",
          TypeAlert.success,
        );
        return true;
      } catch (e) {
        CrimpRejectionError crimpRejectionError =
            crimpRejectionErrorFromJson(response.body);
        AlertController.show(
          "${crimpRejectionError.statusMsg}",
          "",
          TypeAlert.error,
        );

        return false;
      }
    } else {
      AlertController.show(
        " Return Raw Material status code ${response.statusCode}",
        "",
        TypeAlert.error,
      );

      return false;
    }
  }
}
