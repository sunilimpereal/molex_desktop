import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex_desktop/model_api/Transfer/postgetbundleMaster.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/generateLabel_model.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/model_api/process1/getbundleListGl.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/transferBundle_model.dart';
import 'package:molex_desktop/screens/widgets/keypad.dart';
import 'package:molex_desktop/screens/widgets/showBundles.dart';
import 'package:molex_desktop/screens/widgets/timer.dart';
import 'package:molex_desktop/service/api_service.dart';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import '../location.dart';
import 'material_table_wip.dart';

enum Status {
  generateLabel,
  scanBundle,
  scanBin,
}
// 100% complete - actual quantity
// partial complete confirmaton
// load material process -
// tracebiltity numner
// bundle qty
// no data in material show msg
// -- move to rejection
// --save and print
// label id
// printer status
// partail compltion reason

// partail compltion reason
// printer status
// -- move to rejection
// bundle qty --error
//partial complete button

class GenerateLabel extends StatefulWidget {
  Schedule schedule;
  MachineDetails machine;
  Employee employee;
  String method;
  Function reload;
  Function sendData;
  Function fullcomplete;
  Function partialComplete;
  bool processStarted;
  Function startprocess;
  MatTrkPostDetail matTrkPostDetail;
  int toalQuantity;
  Function updateQty;
  Function transfer;
  GenerateLabel(
      {required this.transfer,
      required this.machine,
      required this.schedule,
      required this.sendData,
      required this.employee,
      required this.method,
      required this.matTrkPostDetail,
      required this.partialComplete,
      required this.fullcomplete,
      required this.processStarted,
      required this.startprocess,
      required this.toalQuantity,
      required this.updateQty,
      required this.reload});
  @override
  _GenerateLabelState createState() => _GenerateLabelState();
}

class _GenerateLabelState extends State<GenerateLabel> {
  // Text Editing Controller for all rejection cases
  TextEditingController maincontroller = new TextEditingController();
  TextEditingController _bundleScanController = new TextEditingController();
  TextEditingController _binController = new TextEditingController();
  TextEditingController bundleQty = new TextEditingController();

  // All Quantity Contolle
  TextEditingController endWireController = new TextEditingController();
  TextEditingController endTerminalControllerFrom = new TextEditingController();
  TextEditingController endTerminalControllerTo = new TextEditingController();
  TextEditingController setupRejectionsControllerCable =
      new TextEditingController();
  TextEditingController setupRejectionsControllerFrom =
      new TextEditingController();
  TextEditingController setupRejectionsControllerTo =
      new TextEditingController();
  TextEditingController cvmRejectionsControllerCable =
      new TextEditingController();
  TextEditingController cvmRejectionsControllerTo = new TextEditingController();
  TextEditingController cvmRejectionsControllerFrom =
      new TextEditingController();
  TextEditingController cfmRejectionsControllerCable =
      new TextEditingController();
  TextEditingController cfmRejectionsControllerTo = new TextEditingController();
  TextEditingController cfmRejectionsControllerFrom =
      new TextEditingController();
  TextEditingController cableDamageController = new TextEditingController();
  TextEditingController lengthvariationController = new TextEditingController();
  TextEditingController rollerMarkController = new TextEditingController();
  TextEditingController stripLengthVariationController =
      new TextEditingController();
  TextEditingController nickMarkController = new TextEditingController();

  TextEditingController terminalDamageController = new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController windowGapController = new TextEditingController();
  TextEditingController crimpOnInsulationController =
      new TextEditingController();
  TextEditingController bellMoutherrorController = new TextEditingController();
  TextEditingController cutoffBarController = new TextEditingController();
  TextEditingController exposureStrandsController = new TextEditingController();
  TextEditingController strandsCutController = new TextEditingController();
  TextEditingController brushLengthLessorMoreController =
      new TextEditingController();
  TextEditingController halfCurlingController = new TextEditingController();
  TextEditingController wrongTerminalController = new TextEditingController();
  TextEditingController wrongcableController = new TextEditingController();
  TextEditingController seamOpenController = new TextEditingController();
  TextEditingController wrongCutLengthController = new TextEditingController();
  TextEditingController missCrimpController = new TextEditingController();
  TextEditingController extrusionBurrController = new TextEditingController();

  /// Main Content
  FocusNode keyboardFocus = new FocusNode();

  bool labelGenerated = false;
  String _output = '';
  late String binState;
  late String binId;
  late String bundleId;
  bool hasBin = false;
  Status status = Status.generateLabel;
  TransferBundle transferBundle = new TransferBundle();
  late PostGenerateLabel postGenerateLabel;
  static const platform = const MethodChannel('com.impereal.dev/tsc');
  String _printerStatus = 'Waiting';
  List<GeneratedBundle> generatedBundleList = [];
  bool showtable = false;
  bool loading = false;

  FocusNode _bundleFocus = new FocusNode();

  late ApiService apiService;
  late CableTerminalA terminalA;
  late CableTerminalB terminalB;
  getTerminal() {
    ApiService apiService = new ApiService();
    apiService
        .getCableTerminalA(
            fgpartNo: widget.schedule.finishedGoodsNumber,
            cablepartno: widget.schedule.cablePartNumber,
            length: widget.schedule.length,
            color: widget.schedule.color,
            awg: widget.schedule.awg)
        .then((termiA) {
      apiService
          .getCableTerminalB(
              fgpartNo: widget.schedule.finishedGoodsNumber,
              cablepartno: widget.schedule.cablePartNumber,
              length: widget.schedule.length,
              color: widget.schedule.color,
              awg: widget.schedule.awg)
          .then((termiB) {
        setState(() {
          terminalA = termiA!;
          terminalB = termiB!;
          getBundles();
        });
      });
    });
  }

  getBundles() {
    List<GeneratedBundle> bundleList = [];
    ApiService apiService = new ApiService();
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      scheduleId: int.parse(widget.schedule.scheduledId),
      binId: 0,
      bundleId: '',
      location: '',
      status: '',
      finishedGoods: 0,
      cablePartNumber: 0,
      orderId: "",
    );
    apiService
        .getBundlesInSchedule(
            postgetBundleMaster: postgetBundleMaste,
            scheduleID: widget.schedule.scheduledId)
        .then((value) {
      List<BundlesRetrieved> bundles = value ?? [];
      log("bun1 ${bundles}");
      for (BundlesRetrieved bundle in bundles) {
        bundleList.add(GeneratedBundle(
            rejectedQty: '',
            bundleDetail: bundle,
            bundleQty: bundle.bundleQuantity.toString(),
            transferBundleToBin: TransferBundleToBin(
                binIdentification: bundle.binId.toString(),
                locationId: bundle.locationId.toString()),
            label: GeneratedLabel(
              finishedGoods: bundle.finishedGoodsPart ?? 0,
              cablePartNumber: bundle.cablePartNumber ?? 0,
              cutLength: bundle.cutLengthSpecificationInmm ?? 0,
              wireGauge: bundle.awg ?? '',
              bundleId: bundle.bundleIdentification ?? '',
              routeNo: "${widget.schedule.route}",
              status: 0,
              bundleQuantity: bundle.bundleQuantity ?? 0,
              terminalFrom: terminalA.terminalPart,
              terminalTo: terminalB.terminalPart,
              //  terminalFrom: bundle.t
              //todo terminal from,terminal to
              //todo route no
              //
            )));
      }
      setState(() {
        generatedBundleList = bundleList;
        widget.sendData(generatedBundleList.length);
      });
    });
  }

  late GeneratedLabel label;
  bool printerStatus = false;

  @override
  void initState() {
    apiService = new ApiService();
    getTerminal();

    transferBundle = new TransferBundle();

    transferBundle.cablePartDescription = widget.schedule.cablePartNumber;
    transferBundle.scheduledQuantity =
        int.parse("${widget.schedule.scheduledQuantity}");
    transferBundle.orderIdentification =
        int.parse("${widget.schedule.orderId}");
    transferBundle.machineIdentification = widget.machine.machineNumber;
    transferBundle.scheduledId = widget.schedule.scheduledId == ''
        ? 0
        : int.parse("${widget.schedule.scheduledId}");
    binState = "Scan Bin";
    super.initState();
  }

  void clear() {
    endWireController.clear();
    cableDamageController.clear();
    lengthvariationController.clear();
    rollerMarkController.clear();
    stripLengthVariationController.clear();
    nickMarkController.clear();
    endTerminalControllerFrom.clear();
    endTerminalControllerTo.clear();
    terminalDamageController.clear();
    terminalBendController.clear();
    terminalTwistController.clear();
    windowGapController.clear();
    crimpOnInsulationController.clear();
    bellMoutherrorController..clear();
    cutoffBarController.clear();
    exposureStrandsController.clear();
    strandsCutController.clear();
    brushLengthLessorMoreController.clear();
    halfCurlingController.clear();
    setupRejectionsControllerCable.clear();
    setupRejectionsControllerTo.clear();
    setupRejectionsControllerFrom.clear();
    cvmRejectionsControllerCable.clear();
    cvmRejectionsControllerTo.clear();
    cvmRejectionsControllerFrom.clear();
    cfmRejectionsControllerCable.clear();
    cfmRejectionsControllerTo.clear();
    cfmRejectionsControllerFrom.clear();
    wrongTerminalController.clear();
    wrongcableController.clear();
    seamOpenController.clear();
    wrongCutLengthController.clear();
    missCrimpController.clear();
    extrusionBurrController.clear();
  }

  @override
  void dispose() {
    keyboardFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              quantity(),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Material(
                    elevation: 10,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        main(status),
                        widget.processStarted
                            ? KeyPad(
                                controller: maincontroller,
                                buttonPressed: (buttonText) {
                                  if (buttonText == 'X') {
                                    _output = '';
                                  } else {
                                    _output = _output + buttonText;
                                  }

                                  print(_output);
                                  setState(() {
                                    maincontroller.text = _output;
                                    // output = int.parse(_output).toStringAsFixed(2);
                                  });
                                })
                            // ? keypad(maincontroller)
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        printerStatus
            ? Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              ),
                            ),
                            Text("Printing",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Widget main(Status status) {
    // Future.delayed(
    //   const Duration(milliseconds: 50),
    //   () {
    //     SystemChannels.textInput.invokeMethod('TextInput.hide');
    //   },
    // );
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    switch (status) {
      case Status.generateLabel:
        return widget.processStarted
            ? Container(
                child: widget.machine.category == "Automatic Cut & Crimp"
                    ? generateLabelAutoCut()
                    : generateLabelMannualCut(),
              )
            : Container(
                width: (MediaQuery.of(context).size.width * 0.75) - 5,
                height: MediaQuery.of(context).size.height * 0.5,
              );

        break;
      case Status.scanBin:
        return binScan();
        break;
      case Status.scanBundle:
        return bundleScan();
      default:
        return Container();
    }
  }

  Widget quantity() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialtableWIP(
            matTrkPostDetail: widget.matTrkPostDetail,
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Material(
              elevation: 2,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.transparent)),
              child: Container(
                  padding: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width * 0.635,
                  height: 135,
                  child: widget.processStarted
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Quantity Feild
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        width: 200,
                                        height: 60,
                                        child: TextField(
                                          readOnly: true,
                                          textAlign: TextAlign.center,
                                          controller: bundleQty,
                                          onEditingComplete: () {
                                            setState(() {
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');

                                              labelGenerated = !labelGenerated;
                                              status = Status.generateLabel;
                                            });
                                          },
                                          onTap: () {
                                            setState(() {
                                              _output = '';
                                              maincontroller = bundleQty;
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');
                                            });
                                          },
                                          showCursor: false,
                                          keyboardType: TextInputType.number,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: fonts.openSans),
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 3),
                                            labelText: "  Bundle Qty (SPQ)",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                          height: 40,
                                          width: 120,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  side: BorderSide(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.pressed))
                                                    return Colors.red.shade200;
                                                  return Colors.red
                                                      .shade500; // Use the component's default.
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              showBundles();
                                              setState(() {
                                                showtable = !showtable;
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Bundles",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  // padding: EdgeInsets.all(6),
                                                  // width: 25,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red[800],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100))),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        '${generatedBundleList.length > 0 ? generatedBundleList.length : "0"}',
                                                        // bundlePrint.length.toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            quantityDisp(),
                            ProcessTimer(
                                startTime: DateTime.now(),
                                endTime: "${widget.schedule.shiftEnd}"),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                height: 130,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        widget.toalQuantity ==
                                                int.parse(
                                                    "${widget.schedule.scheduledQuantity}")
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 45,
                                                  width: 200,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .transparent))),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed))
                                                            return Colors
                                                                .green.shade200;
                                                          return Colors.green
                                                              .shade500; // Use the component's default.
                                                        },
                                                      ),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed))
                                                            return Colors.green;
                                                          return Colors.green
                                                              .shade500; // Use the component's default.
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      getBundles();
                                                      checkMapping()
                                                          .then((value) {
                                                        if (value) {
                                                          widget.toalQuantity >
                                                                  (int.parse(widget
                                                                          .schedule
                                                                          .scheduledQuantity) *
                                                                      (0.9))
                                                              ? widget
                                                                  .fullcomplete()
                                                              : fullycompleteDialog();
                                                        }
                                                      });
                                                    },
                                                    child: Text(
                                                      "100% Complete",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            fonts.openSans,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        //partially complete
                                        generatedBundleList.length > 0 &&
                                                widget.toalQuantity !=
                                                    int.parse(widget.schedule
                                                        .scheduledQuantity)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 45,
                                                  width: 200,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .green))),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                                          if (states.contains(
                                                              MaterialState
                                                                  .pressed))
                                                            return Colors.white;
                                                          return Colors
                                                              .white; // Use the component's default.
                                                        },
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      widget.partialComplete();
                                                      // setState(() {
                                                      //   rightside = "partial";
                                                      // });
                                                    },
                                                    child: Text(
                                                      "Partially  Complete",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            fonts.openSans,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 34,
                                                width: 160,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          child: Center(
                              child: Container(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          side: BorderSide(
                                              color: Colors.transparent))),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green.shade200;
                                      return Colors.green
                                          .shade500; // Use the component's default.
                                    },
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.green;
                                      return Colors.green
                                          .shade500; // Use the component's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  if (widget.method == '') {
                                    AlertController.show(
                                      "Select Process Type To Start",
                                      "",
                                      TypeAlert.error,
                                    );
                                  } else {
                                    widget.startprocess();
                                  }
                                },
                                child: Text("Start Process",
                                    style: TextStyle(
                                        fontFamily: fonts.openSans,
                                        fontSize: 16))),
                          )),
                        )),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkMapping() async {
    for (GeneratedBundle bundle in generatedBundleList) {
      log("bundleloc ${bundle.bundleDetail!.locationId.toString()}");
      if (bundle.bundleDetail!.locationId.toString() == "null" ||
          bundle.bundleDetail!.binId.toString() == "null") {
        showMappingAlert(generatedBundleList);
        return false;
      }
    }
    return true;
  }

  Future<void> showMappingAlert(List<GeneratedBundle> bundles) {
    getBundles();
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
            // contentPadding: EdgeInsets.all(0),
            // titlePadding: EdgeInsets.all(0),
            title: Text(
              "Incomplete Bundle Mapping",
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        "Map all bundles to Bin and Location to Complete Schedule"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.transparent))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green.shade200;
                                  return Colors.green
                                      .shade500; // Use the component's default.
                                },
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.green;
                                  return Colors.green
                                      .shade500; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context2);
                              widget.reload();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Location(
                                    locationType: LocationType.partialTransfer,
                                    type: "process",
                                    employee: widget.employee,
                                    machine: widget.machine,
                                  ),
                                ),
                              ).then((value) {
                                log("came Back");
                                getBundles();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Map Bin & Location",
                                style: TextStyle(
                                    fontFamily: fonts.openSans, fontSize: 16),
                              ),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget generateLabelAutoCut() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: (MediaQuery.of(context).size.width * 0.78) - 10,
        height: MediaQuery.of(context).size.height * 0.49,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('     WireCutting & Crimping Rejection Cases',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                fontFamily: fonts.openSans)),
                        // Text(' Rejecttion Quantity: ${total()}',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 12,
                        //     ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                doubleQuantityCell(
                                  name: "End Terminal ",
                                  quantity: 10,
                                  textEditingControllerFrom:
                                      endTerminalControllerFrom,
                                  textEditingControllerTo:
                                      endTerminalControllerTo,
                                ),
                                tripleQuantityCell(
                                  name: "CFM  Rejections ",
                                  quantity: 10,
                                  textEditingControllerFrom:
                                      cfmRejectionsControllerFrom,
                                  textEditingControllerCable:
                                      cfmRejectionsControllerCable,
                                  textEditingControllerTo:
                                      cfmRejectionsControllerTo,
                                ),
                                tripleQuantityCell(
                                  name: "CVM  Rejections ",
                                  quantity: 10,
                                  textEditingControllerFrom:
                                      cvmRejectionsControllerFrom,
                                  textEditingControllerCable:
                                      cvmRejectionsControllerCable,
                                  textEditingControllerTo:
                                      cvmRejectionsControllerTo,
                                ),
                                tripleQuantityCell(
                                  name: "Setup  Rejection ",
                                  quantity: 10,
                                  textEditingControllerFrom:
                                      setupRejectionsControllerFrom,
                                  textEditingControllerCable:
                                      setupRejectionsControllerCable,
                                  textEditingControllerTo:
                                      setupRejectionsControllerTo,
                                ),

                                // quantitycell(
                                //   name: "Blade Mark	",
                                //   quantity: 10,
                                //   textEditingController: bladeMarkController,
                                // ),
                                // quantitycell(
                                //   name: "Cable Damage",
                                //   quantity: 10,
                                //   textEditingController: cableDamageController,
                                // ),
                                // quantitycell(
                                //   name: "Length Variation",
                                //   quantity: 10,
                                //   textEditingController: lengthvariationController,
                                // ),
                              ],
                            ),
                            Column(
                              children: [
                                quantitycell(
                                  name: "End Wire",
                                  quantity: 10,
                                  textEditingController: endWireController,
                                ),
                                quantitycell(
                                  name: "Cable Damage",
                                  quantity: 10,
                                  textEditingController: cableDamageController,
                                ),
                                quantitycell(
                                  name: "Length Variation",
                                  quantity: 10,
                                  textEditingController:
                                      lengthvariationController,
                                ),
                                quantitycell(
                                  name: "Roller Mark",
                                  quantity: 10,
                                  textEditingController: rollerMarkController,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                quantitycell(
                                  name: "Strip Length Variation",
                                  quantity: 10,
                                  textEditingController:
                                      stripLengthVariationController,
                                ),
                                quantitycell(
                                  name: "Nick Mark",
                                  quantity: 10,
                                  textEditingController: nickMarkController,
                                ),
                                quantitycell(
                                  name: "Terminal Damage",
                                  quantity: 10,
                                  textEditingController:
                                      terminalDamageController,
                                ),
                                quantitycell(
                                  name: "Teminal Bend	",
                                  quantity: 10,
                                  textEditingController: terminalBendController,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                quantitycell(
                                    name: "Terminal Twist",
                                    quantity: 10,
                                    textEditingController:
                                        terminalTwistController),
                                quantitycell(
                                  name: "Window Gap",
                                  quantity: 10,
                                  textEditingController: windowGapController,
                                ),
                                quantitycell(
                                  name: "Crimp On Insulation",
                                  quantity: 10,
                                  textEditingController:
                                      crimpOnInsulationController,
                                ),
                                quantitycell(
                                    name: "Bellmouth Error",
                                    quantity: 10,
                                    textEditingController:
                                        bellMoutherrorController),
                              ],
                            ),
                            Column(
                              children: [
                                quantitycell(
                                  name: "Cut Off Bar",
                                  quantity: 10,
                                  textEditingController: cutoffBarController,
                                ),
                                quantitycell(
                                  name: "Exposure Strands",
                                  quantity: 10,
                                  textEditingController:
                                      exposureStrandsController,
                                ),
                                quantitycell(
                                  name: "Strands Cut",
                                  quantity: 10,
                                  textEditingController: strandsCutController,
                                ),
                                quantitycell(
                                  name: "Brush Length Less/More",
                                  quantity: 10,
                                  textEditingController:
                                      brushLengthLessorMoreController,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                quantitycell(
                                  name: "Half Curling",
                                  quantity: 10,
                                  textEditingController: halfCurlingController,
                                ),
                                quantitycell(
                                  name: "Wrong terminal",
                                  quantity: 10,
                                  textEditingController:
                                      wrongTerminalController,
                                ),
                                quantitycell(
                                  name: "Wrong Cable",
                                  quantity: 10,
                                  textEditingController: wrongcableController,
                                ),
                                quantitycell(
                                  name: "Seam Open",
                                  quantity: 10,
                                  textEditingController: seamOpenController,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                quantitycell(
                                  name: "Extrusion Burr",
                                  quantity: 10,
                                  textEditingController:
                                      extrusionBurrController,
                                ),
                                quantitycell(
                                  name: "Wrong Cut-length",
                                  quantity: 10,
                                  textEditingController:
                                      wrongCutLengthController,
                                ),
                                quantitycell(
                                  name: "Miss Crimp",
                                  quantity: 10,
                                  textEditingController: missCrimpController,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  child: Center(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Bundle Qty :  ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${bundleQty.text}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Rejected Qty :  ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "${total()}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Other Rejections :  ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "${otherTotal()}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.26,
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                loading
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent))),
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed))
                                                return Colors.green.shade200;
                                              return Colors.green
                                                  .shade500; // Use the component's default.
                                            },
                                          ),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed))
                                                return Colors.green.shade200;
                                              return Colors.green
                                                  .shade500; // Use the component's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircularProgressIndicator(
                                            // color: Colors.white
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ))
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent))),
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed))
                                                return Colors.green.shade200;
                                              return Colors.green
                                                  .shade500; // Use the component's default.
                                            },
                                          ),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed))
                                                return Colors.green.shade200;
                                              return Colors.green
                                                  .shade500; // Use the component's default.
                                            },
                                          ),
                                        ),
                                        child: Container(
                                          height: 100,
                                          width: 200,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Save & Print",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            fonts.openSans,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
                                          if (bundleQty.text.length > 0 &&
                                              bundleQty.text != "0") {
                                            if (widget.toalQuantity +
                                                    int.parse(bundleQty.text) <=
                                                int.parse(
                                                    "${widget.schedule.scheduledQuantity}")) {
                                              setState(() {
                                                loading = true;
                                              });
                                              // if (int.parse(total()) <
                                              //     int.parse(bundleQty.text)) {
                                              log("${postGenerateLabelToJson(getPostGeneratelabel())}");
                                              apiService
                                                  .postGeneratelabel(
                                                      getPostGeneratelabel(),
                                                      bundleQty.text)
                                                  .then((value) {
                                                if (value != null) {
                                                  DateTime now = DateTime.now();
                                                  GeneratedLabel label1 = value;
                                                  setState(() {
                                                    printerStatus = true;
                                                  });
                                                  _print(
                                                    ipaddress:
                                                        "${widget.machine.printerIp}",
                                                    // ipaddress: "172.25.16.53",
                                                    bq: bundleQty.text,
                                                    qr: "${label1.bundleId}",
                                                    routenumber1:
                                                        "${label1.routeNo}",
                                                    date: now.day.toString() +
                                                        "-" +
                                                        now.month.toString() +
                                                        "-" +
                                                        now.year.toString(),
                                                    orderId:
                                                        "${widget.schedule.orderId}",
                                                    fgPartNumber:
                                                        "${widget.schedule.finishedGoodsNumber}",
                                                    cutlength:
                                                        "${widget.schedule.length}",
                                                    cablepart:
                                                        "${widget.schedule.cablePartNumber}",
                                                    wireGauge:
                                                        "${label1.wireGauge}",
                                                    terminalfrom:
                                                        "${label1.terminalFrom}",
                                                    terminalto:
                                                        "${label1.terminalTo}",
                                                    userid:
                                                        "${widget.employee.empId}",
                                                    shift:
                                                        "${widget.schedule.shiftNumber}",
                                                    machine:
                                                        "${widget.machine.machineNumber}",
                                                  ).then((value) {
                                                    Future.delayed(
                                                      const Duration(
                                                          milliseconds: 1000),
                                                      () {
                                                        setState(() {
                                                          printerStatus = false;
                                                        });
                                                      },
                                                    );
                                                  });
                                                  setState(() {
                                                    loading = false;
                                                  });

                                                  setState(() {
                                                    widget.reload();
                                                    widget.sendData(
                                                        generatedBundleList
                                                            .length);
                                                    SystemChannels.textInput
                                                        .invokeMethod(
                                                            'TextInput.hide');
                                                    widget.updateQty(widget
                                                            .toalQuantity +
                                                        int.parse(
                                                            bundleQty.text));
                                                    labelGenerated =
                                                        !labelGenerated;
                                                    status = Status.scanBin;
                                                    label = value;
                                                  });
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                              AlertController.show(
                                                "Actual Quantity is Greater than Schedule Quantity",
                                                "",
                                                TypeAlert.error,
                                              );

                                              Fluttertoast.showToast(
                                                msg:
                                                    "Actual Quantity is Greater than Schedule Quantity",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          } else {
                                            AlertController.show(
                                              "Enter Bundle Qty",
                                              "",
                                              TypeAlert.error,
                                            );
                                            Fluttertoast.showToast(
                                              msg: "Enter Bundle Qty",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          }
                                        }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget generateLabelMannualCut() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.49,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cutting Rejection Cases',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: fonts.openSans)),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          quantitycell(
                            name: "End Wire",
                            quantity: 10,
                            textEditingController: endWireController,
                          ),
                          quantitycell(
                            name: "Cable Damage",
                            quantity: 10,
                            textEditingController: cableDamageController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Length variation",
                            quantity: 10,
                            textEditingController: lengthvariationController,
                          ),
                          quantitycell(
                            name: "Roller Mark",
                            quantity: 10,
                            textEditingController: rollerMarkController,
                          ),
                          quantitycell(
                            name: "Strip Length Variation",
                            quantity: 10,
                            textEditingController:
                                stripLengthVariationController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Nick Mark",
                            quantity: 10,
                            textEditingController: nickMarkController,
                          ),
                          quantitycell(
                            name: "Wrong Cable",
                            quantity: 10,
                            textEditingController: wrongcableController,
                          ),
                          quantitycell(
                            name: "Wrong Cut Length",
                            quantity: 10,
                            textEditingController: wrongCutLengthController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Strands Cut",
                            quantity: 10,
                            textEditingController: strandsCutController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              child: Center(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Bundle Qty :  ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: fonts.openSans,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${bundleQty.text}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: fonts.openSans,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Rejected Qty :  ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: fonts.openSans,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${total()}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: fonts.openSans,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          )),
                      Row(
                        children: [
                          // ElevatedButton(
                          //     style: ButtonStyle(
                          //       shape: MaterialStateProperty.all<
                          //               RoundedRectangleBorder>(
                          //           RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(20.0),
                          //               side: BorderSide(color: Colors.green))),
                          //       backgroundColor:
                          //           MaterialStateProperty.resolveWith<Color>(
                          //         (Set<MaterialState> states) {
                          //           if (states.contains(MaterialState.pressed))
                          //             return Colors.white;
                          //           return Colors
                          //               .white; // Use the component's default.
                          //         },
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //       setState(() {
                          //         SystemChannels.textInput
                          //             .invokeMethod('TextInput.hide');
                          //         status = Status.generateLabel;
                          //       });
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Icon(Icons.keyboard_arrow_left,
                          //             color: Colors.green),
                          //         Text(
                          //           "Back",
                          //           style: TextStyle(color: Colors.green),
                          //         ),
                          //       ],
                          //     )),
                          SizedBox(width: 10),
                          Container(
                            height: 50,
                            child: loading
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              side: BorderSide(
                                                  color: Colors.transparent))),
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.green.shade200;
                                          return Colors.green
                                              .shade500; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      log("printing");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    ))
                                : Container(
                                    width: 200,
                                    height: 55,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.transparent))),
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed))
                                                return Colors.green.shade200;
                                              return Colors.green
                                                  .shade500; // Use the component's default.
                                            },
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                            "Save & Print",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            loading = true;
                                          });

                                          if (bundleQty.text.length > 0 &&
                                              bundleQty.text != "0") {
                                            log("${postGenerateLabelToJson(getPostGeneratelabel())}");
                                            if (widget.toalQuantity +
                                                    int.parse(bundleQty.text) <=
                                                int.parse(widget.schedule
                                                    .scheduledQuantity)) {
                                              apiService
                                                  .postGeneratelabel(
                                                      getPostGeneratelabel(),
                                                      bundleQty.text)
                                                  .then((value) {
                                                if (value != null) {
                                                  DateTime now = DateTime.now();
                                                  GeneratedLabel label1 = value;
                                                  _print(
                                                    ipaddress:
                                                        "${widget.machine.printerIp}",
                                                    // ipaddress: "172.25.16.53",
                                                    bq: bundleQty.text,
                                                    qr: "${label1.bundleId}",
                                                    routenumber1:
                                                        "${label1.routeNo}",
                                                    date: now.day.toString() +
                                                        "-" +
                                                        now.month.toString() +
                                                        "-" +
                                                        now.year.toString(),
                                                    orderId:
                                                        "${widget.schedule.orderId}",
                                                    fgPartNumber:
                                                        "${widget.schedule.finishedGoodsNumber}",
                                                    cutlength:
                                                        "${widget.schedule.length}",
                                                    cablepart:
                                                        "${widget.schedule.cablePartNumber}",
                                                    wireGauge:
                                                        "${label1.wireGauge}",
                                                    terminalfrom:
                                                        "${label1.terminalFrom}",
                                                    terminalto:
                                                        "${label1.terminalTo}",
                                                    userid:
                                                        "${widget.employee.empId}",
                                                    shift:
                                                        "${widget.schedule.shiftNumber}",
                                                    machine:
                                                        "${widget.machine.machineNumber}",
                                                  );
                                                  setState(() {
                                                    loading = false;
                                                  });

                                                  setState(() {
                                                    widget.reload();
                                                    labelGenerated =
                                                        !labelGenerated;
                                                    status = Status.scanBin;
                                                    label = value;
                                                    widget.updateQty(widget
                                                            .toalQuantity +
                                                        int.parse(
                                                            bundleQty.text));
                                                    SystemChannels.textInput
                                                        .invokeMethod(
                                                            'TextInput.hide');
                                                  });
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }
                                              });
                                              // } else {
                                              //   setState(() {
                                              //     loading = false;
                                              //   });
                                              //   Fluttertoast.showToast(
                                              //     msg:
                                              //         "Rejected Quantity is greater than Bundle Quantity",
                                              //     toastLength: Toast.LENGTH_SHORT,
                                              //     gravity: ToastGravity.BOTTOM,
                                              //     timeInSecForIosWeb: 1,
                                              //     backgroundColor: Colors.red,
                                              //     textColor: Colors.white,
                                              //     fontSize: 16.0,
                                              //   );
                                              // }
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                              AlertController.show(
                                                "Actual Quantity is Greater than Schedule Quantity",
                                                "",
                                                TypeAlert.error,
                                              );
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Actual Quantity is Greater than Schedule Quantity",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          } else {
                                            setState(() {
                                              loading = false;
                                            });
                                            AlertController.show(
                                              "Enter bundle Qty",
                                              "",
                                              TypeAlert.error,
                                            );
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Rejected Quantity is greater than Bundle Quantity",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          }
                                        }),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // emu-m/c-004w

  PostGenerateLabel getPostGeneratelabel() {
    String getprocesstype() {
      String process = "";
      if (widget.method.contains("a")) {
        process = process + "crimp from,";
      }
      if (widget.method.contains("c")) {
        process = process + "cutlength";
      }
      if (widget.method.contains("b")) {
        process = process + ",Crimp to";
      }
      return process;
    }

    return PostGenerateLabel(
      //Schedule Detail
      cablePartNumber: int.parse(widget.schedule.cablePartNumber ?? '0'),
      purchaseorder: int.parse(widget.schedule.orderId ?? '0'),
      orderIdentification: int.parse(widget.schedule.orderId ?? '0'),
      finishedGoods: int.parse(widget.schedule.finishedGoodsNumber ?? '0'),
      color: widget.schedule.color,
      cutLength: int.parse(widget.schedule.length ?? '0'),
      scheduleIdentification: int.parse(widget.schedule.scheduledId ?? '0'),
      scheduledQuantity: int.parse(widget.schedule.scheduledQuantity ?? '0'),
      machineIdentification: widget.machine.machineNumber,
      operatorIdentification: widget.employee.empId,
      bundleIdentification: _bundleScanController.text,
      crimpFromSchId:
          widget.method.contains("a") ? "${widget.schedule.scheduledId}" : "",
      crimpToSchId:
          widget.method.contains("b") ? "${widget.schedule.scheduledId}" : "",
      preparationCompleteFlag: "0",
      viCompleted: "0",
      processType: getprocesstype(),

      rejectedQuantity: int.parse(total()),

      // Rejected Quantity
      endWire: int.parse(
          endWireController.text == '' ? "0" : endWireController.text),
      rejectionsTerminalFrom: int.parse(endTerminalControllerFrom.text == ''
          ? "0"
          : endTerminalControllerFrom.text),
      rejectionsTerminalTo: int.parse(endTerminalControllerTo.text == ''
          ? "0"
          : endTerminalControllerTo.text),
      setUpRejections: int.parse(setupRejectionsControllerCable.text == ''
          ? "0"
          : setupRejectionsControllerCable.text),
      setUpRejectionTerminalFrom: int.parse(
          setupRejectionsControllerFrom.text == ''
              ? "0"
              : setupRejectionsControllerFrom.text),
      setUpRejectionTerminalTo: int.parse(setupRejectionsControllerTo.text == ''
          ? "0"
          : setupRejectionsControllerTo.text),
      cvmRejectionsCable: int.parse(cvmRejectionsControllerCable.text == ''
          ? "0"
          : cvmRejectionsControllerCable.text),
      cvmRejectionsCableTerminalFrom: int.parse(
          cvmRejectionsControllerFrom.text == ''
              ? "0"
              : cvmRejectionsControllerFrom.text),
      cvmRejectionsCableTerminalTo: int.parse(
          cvmRejectionsControllerTo.text == ''
              ? "0"
              : cvmRejectionsControllerTo.text),
      cfmRejectionsCable: int.parse(cfmRejectionsControllerCable.text == ''
          ? "0"
          : cfmRejectionsControllerCable.text),
      cfmRejectionsCableTerminalFrom: int.parse(
          cfmRejectionsControllerFrom.text == ''
              ? "0"
              : cfmRejectionsControllerFrom.text),
      cfmRejectionsCableTerminalTo: int.parse(
          cfmRejectionsControllerTo.text == ''
              ? "0"
              : cfmRejectionsControllerTo.text),

      cableDamage: int.parse(
          cableDamageController.text == '' ? "0" : cableDamageController.text),
      lengthVariation: int.parse(lengthvariationController.text == ''
          ? "0"
          : lengthvariationController.text),
      rollerMark: int.parse(
          rollerMarkController.text == '' ? "0" : rollerMarkController.text),
      stringLengthVariation: int.parse(stripLengthVariationController.text == ''
          ? "0"
          : stripLengthVariationController.text),
      nickMark: int.parse(
          nickMarkController.text == '' ? "0" : nickMarkController.text),
      terminalDamage: int.parse(terminalDamageController.text == ''
          ? "0"
          : terminalDamageController.text),

      terminalBend: int.parse(terminalBendController.text == ''
          ? "0"
          : terminalBendController.text),
      terminalTwist: int.parse(terminalTwistController.text == ''
          ? "0"
          : terminalTwistController.text),
      windowGap: int.parse(
          windowGapController.text == '' ? "0" : windowGapController.text),
      crimpOnInsulationC: int.parse(crimpOnInsulationController.text == ''
          ? "0"
          : crimpOnInsulationController.text),
      bellMouthError: int.parse(bellMoutherrorController.text == ''
          ? "0"
          : bellMoutherrorController.text),
      cutOffBurr: int.parse(
          cutoffBarController.text == '' ? "0" : cutoffBarController.text),
      exposureStrands: int.parse(exposureStrandsController.text == ''
          ? "0"
          : exposureStrandsController.text),

      strandsCut: int.parse(
          strandsCutController.text == '' ? "0" : strandsCutController.text),

      brushLengthLessorMore: int.parse(
          brushLengthLessorMoreController.text == ''
              ? "0"
              : brushLengthLessorMoreController.text),

      halfCurlingA: int.parse(
          halfCurlingController.text == '' ? "0" : halfCurlingController.text),
      wrongTerminal: int.parse(wrongTerminalController.text == ''
          ? "0"
          : wrongTerminalController.text),
      wrongCable: int.parse(
          wrongcableController.text == '' ? "0" : wrongcableController.text),
      seamOpen: int.parse(
          seamOpenController.text == '' ? "0" : seamOpenController.text),
      wrongCutLength: int.parse(wrongCutLengthController.text == ''
          ? "0"
          : wrongCutLengthController.text),
      missCrimp: int.parse(
          missCrimpController.text == '' ? "0" : missCrimpController.text),
      extrusionBurr: int.parse(extrusionBurrController.text == ''
          ? "0"
          : extrusionBurrController.text),

      //TODO

      method: widget.method,
      terminalFrom: int.parse('${terminalA.terminalPart ?? '0'}'),
      terminalTo: int.parse('${terminalB.terminalPart ?? '0'}'),
      awg: "${widget.schedule.awg}",
    );
  }
  // 8765607  500 900 RD 369100004 84671404

  PostGenerateLabel calculateTotal(PostGenerateLabel label) {
    int? total = label.terminalDamage! +
        label.brushLengthLessOrMoreC! +
        label.setupRejections! +
        label.insulationDamage! +
        label.improperCrimping! +
        label.terminalBackOut! +
        label.terminalSeamOpen! +
        label.exposureStrands! +
        label.crimpingPositionOutOrMissCrimp! +
        label.terminalBend! +
        label.cableDamage! +
        label.bellMouthLessOrMore! +
        label.tabBendOrTabOpen! +
        label.exposureStrands! +
        label.entangledCable! +
        label.rollerMark! +
        label.cameraPositionOutE! +
        label.terminalTwist! +
        label.halfCurlingA! +
        label.conductorCurlingUpDown! +
        label.cutOffLessOrMore! +
        label.strandsCut! +
        label.troubleShootingRejections! +
        label.lengthLessOrLengthMore! +
        label.windowGap! +
        label.endWire! +
        label.insulationCurlingUpDown! +
        label.cutOffBurr! +
        label.brushLengthLessOrMoreC! +
        label.wireOverLoadRejectionsJam! +
        label.gripperMark! +
        label.cablePositionMovementG! +
        label.endTerminal! +
        label.conductorBurr! +
        label.cutOffBend! +
        label.terminalCoppermark! +
        label.crimpingPositionOutOrMissCrimp! +
        label.crimpOnInsulation! +
        label.crimpPositionOut! +
        label.stripPositionOut! +
        label.offCurling! +
        label.cFmPfmRejections! +
        label.incomingIssue! +
        label.crossCut! +
        label.insulationBarrel!;

    label.rejectedQuantity = total;
    return label;
  }

  Future<void> fullycompleteDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              title: Text('Not Enough Quantity to Complete Process'),
              actions: <Widget>[
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.green),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(
                        const Duration(milliseconds: 50),
                        () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                      );
                    },
                    child: Text('     Ok    ')),
              ]);
        });
  }

  Future<void> partiallyCompleteDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              title: Text('Not Enough Quantity to Complete Process'),
              actions: <Widget>[
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.redAccent),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Future.delayed(
                        const Duration(milliseconds: 50),
                        () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                      );
                    },
                    child: Text('     Ok    ')),
              ]);
        });
  }

  Future<void> showBundles() {
    getBundles();
    ApiService apiService = new ApiService();
    PostgetBundleMaster postgetBundleMaste = new PostgetBundleMaster(
      binId: 0,
      scheduleId: int.parse(widget.schedule.scheduledId),
      bundleId: '',
      location: '',
      status: '',
      finishedGoods: int.parse(widget.schedule.finishedGoodsNumber),
      cablePartNumber: int.parse(widget.schedule.cablePartNumber),
      orderId: widget.schedule.orderId.toString(),
    );
    TextStyle style = TextStyle(
        fontSize: 16, fontFamily: fonts.openSans, fontWeight: FontWeight.bold);

    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context2) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            title: Container(
              height: 700,
              width: 800,
              color: Colors.white,
              child: Stack(
                children: [
                  FutureBuilder(
                      future: apiService.getBundlesInSchedule(
                          postgetBundleMaster: postgetBundleMaste,
                          scheduleID: widget.schedule.scheduledId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<BundlesRetrieved>? bundles =
                              snapshot.data as List<BundlesRetrieved>;
                          List<GeneratedBundle> genbundles =
                              bundles.map((bundle) {
                            return GeneratedBundle(
                                bundleDetail: bundle,
                                bundleQty: bundle.bundleQuantity.toString(),
                                transferBundleToBin: TransferBundleToBin(
                                    binIdentification: bundle.binId.toString(),
                                    locationId: bundle.locationId.toString()),
                                label: GeneratedLabel(
                                  finishedGoods: bundle.finishedGoodsPart ?? 0,
                                  cablePartNumber: bundle.cablePartNumber ?? 0,
                                  cutLength:
                                      bundle.cutLengthSpecificationInmm ?? 0,
                                  wireGauge: bundle.awg ?? '',
                                  bundleId: bundle.bundleIdentification ?? '',
                                  routeNo: "${widget.schedule.route}",
                                  status: 0,
                                  bundleQuantity: bundle.bundleQuantity ?? 0,
                                  terminalFrom: terminalA.terminalPart,
                                  terminalTo: terminalB.terminalPart,
                                  //  terminalFrom: bundle.t
                                  //todo terminal from,terminal to
                                  //todo route no
                                  //
                                ),
                                rejectedQty: '');
                          }).toList();

                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              child: CustomTable(
                                height: 650,
                                width: 800,
                                colums: [
                                  CustomCell(
                                    width: 100,
                                    child: Text('Bundle ID', style: style),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'Bin ID',
                                      style: style,
                                    ),
                                  ),
                                  CustomCell(
                                    width: 120,
                                    child: Text(
                                      'Location ID',
                                      style: style,
                                    ),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'Qty',
                                      style: style,
                                    ),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'Reprint',
                                      style: style,
                                    ),
                                  ),
                                  CustomCell(
                                    width: 100,
                                    child: Text(
                                      'info',
                                      style: style,
                                    ),
                                  ),
                                ],
                                rows: genbundles
                                    .map((e) => CustomRow(cells: [
                                          CustomCell(
                                            width: 100,
                                            child: Text(
                                              e.label.bundleId.toString(),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          CustomCell(
                                            width: 100,
                                            color: e.bundleDetail.binId == null
                                                ? Colors.red[100]
                                                : Colors.transparent,
                                            child: Text(
                                              "${e.bundleDetail.binId ?? "-"}",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          CustomCell(
                                            width: 100,
                                            color: e.bundleDetail.locationId ==
                                                    null
                                                ? Colors.red[100]
                                                : Colors.transparent,
                                            child: Text(
                                              e.bundleDetail.locationId ?? "-",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          CustomCell(
                                            width: 100,
                                            child: Text(
                                              "${e.bundleQty}",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          CustomCell(
                                            width: 130,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            Colors.green),
                                              ),
                                              onPressed: () {
                                                DateTime now = DateTime.now();
                                                //TODO
                                                _print(
                                                  ipaddress:
                                                      "${widget.machine.printerIp}",
                                                  // ipaddress: "172.26.59.14",
                                                  bq: e.bundleQty,
                                                  qr: "${e.label.bundleId}",
                                                  routenumber1:
                                                      "${e.label.routeNo}",
                                                  date: now.day.toString() +
                                                      "-" +
                                                      now.month.toString() +
                                                      "-" +
                                                      now.year.toString(),
                                                  orderId:
                                                      "${widget.schedule.orderId}",
                                                  fgPartNumber:
                                                      "${widget.schedule.finishedGoodsNumber}",
                                                  cutlength:
                                                      "${widget.schedule.length}",
                                                  cablepart:
                                                      "${widget.schedule.cablePartNumber}",
                                                  wireGauge:
                                                      "${e.label.wireGauge}",
                                                  terminalfrom:
                                                      "${e.label.terminalFrom}",
                                                  terminalto:
                                                      "${e.label.terminalTo}",

                                                  userid:
                                                      "${widget.employee.empId}",
                                                  shift:
                                                      "${widget.schedule.shiftNumber}",
                                                  machine:
                                                      "${widget.machine.machineNumber}",
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  ' Reprint',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomCell(
                                            width: 100,
                                            child: GestureDetector(
                                                onTap: () {
                                                  showBundleDetail(e);
                                                },
                                                child: Icon(
                                                  Icons.info_outline,
                                                  color: Colors.blue,
                                                )),
                                          )
                                        ]))
                                    .toList(),
                              ),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context2);
                          },
                          icon:
                              Icon(Icons.close, size: 20, color: Colors.red))),
                ],
              ),
            ),
          );
        });
  }

  Widget tripleQuantityCell({
    required String name,
    required int quantity,
    required TextEditingController textEditingControllerFrom,
    required TextEditingController textEditingControllerCable,
    required TextEditingController textEditingControllerTo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 100,
              child: Text(
                "$name",
                style: TextStyle(fontSize: 16, fontFamily: fonts.openSans),
              ),
            ),
            Container(
              width: 410,
              child: Row(
                mainAxisAlignment: textEditingControllerCable != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: [
                  Container(
                      height: 50,
                      width: 140,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerFrom,
                        onTap: () {
                          setState(() {
                            _output = '';
                            maincontroller = textEditingControllerFrom;
                          });
                        },
                        style:
                            TextStyle(fontSize: 16, fontFamily: fonts.openSans),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: "From Terminal",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                  textEditingControllerCable != null
                      ? Container(
                          height: 50,
                          width: 120,
                          child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            controller: textEditingControllerCable,
                            onTap: () {
                              setState(() {
                                _output = '';
                                maincontroller = textEditingControllerCable;
                              });
                            },
                            style: TextStyle(
                                fontSize: 16, fontFamily: fonts.openSans),
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration(
                              labelText: "Cable",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ))
                      : Container(),
                  Container(
                      height: 50,
                      width: 140,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerTo,
                        onTap: () {
                          setState(() {
                            _output = '';
                            maincontroller = textEditingControllerTo;
                          });
                        },
                        style:
                            TextStyle(fontSize: 16, fontFamily: fonts.openSans),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: "To Terminal",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doubleQuantityCell({
    required String name,
    required int quantity,
    required TextEditingController textEditingControllerFrom,
    required TextEditingController textEditingControllerTo,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 35,
              width: 100,
              child: Text(
                "",
                style: TextStyle(fontSize: 16, fontFamily: fonts.openSans),
              ),
            ),
            Container(
              width: 410,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 50,
                      width: 200,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerFrom,
                        onTap: () {
                          setState(() {
                            _output = '';
                            maincontroller = textEditingControllerFrom;
                          });
                        },
                        style:
                            TextStyle(fontSize: 16, fontFamily: fonts.openSans),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: " $name From ",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                  Container(
                      height: 50,
                      width: 200,
                      child: TextFormField(
                        readOnly: true,
                        showCursor: false,
                        controller: textEditingControllerTo,
                        onTap: () {
                          setState(() {
                            _output = '';
                            maincontroller = textEditingControllerTo;
                          });
                        },
                        style:
                            TextStyle(fontSize: 16, fontFamily: fonts.openSans),
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          labelText: "$name To",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quantitycell({
    required String name,
    required int quantity,
    required TextEditingController textEditingController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 50,
                width: 200,
                child: TextFormField(
                  readOnly: true,
                  showCursor: false,
                  controller: textEditingController,
                  onTap: () {
                    setState(() {
                      _output = '';
                      maincontroller = textEditingController;
                    });
                  },
                  style: TextStyle(fontSize: 16, fontFamily: fonts.openSans),
                  keyboardType: TextInputType.multiline,
                  decoration: new InputDecoration(
                    labelText: name,
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget quantityDisp() {
    double percent =
        widget.toalQuantity / int.parse(widget.schedule.scheduledQuantity);
    return Container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Quantity",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ))
          ],
        ),
        Stack(
          children: [
            Container(
              height: 80,
              width: 80,
              child: Center(
                  child: Text(
                "${(percent * 100).round()}%",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: fonts.openSans,
                    color: percent >= 0.9 ? Colors.green : Colors.red),
              )),
            ),
            Container(
              height: 80,
              width: 80,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  value: percent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      percent >= 0.9 ? Colors.greenAccent : Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
        Text("${widget.toalQuantity}/${widget.schedule.scheduledQuantity}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            )),
      ],
    ));
  }

  Widget binScan() {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Container(
      width: MediaQuery.of(context).size.width * 0.75 - 4,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child:  TextField(
                    autofocus: true,
                    controller: _binController,
                    onSubmitted: (value) {
                      Future.delayed(
                        const Duration(milliseconds: 50),
                        () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                      );
                      if (_binController.text.length > 0) {
                        setState(() {
                          status = Status.scanBundle;
                        });
                      } else {
                        AlertController.show(
                          "Bin not Scanned",
                          "",
                          TypeAlert.error,
                        );
                        Fluttertoast.showToast(
                          msg: "Bin not Scanned",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    onTap: () {
                      _binController.clear();
                      setState(() {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      });
                    },
                    style: TextStyle(fontFamily: fonts.openSans, fontSize: 20),
                    onChanged: (value) {
                      setState(() {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        binId = value;
                      });
                    },
                    decoration: new InputDecoration(
                        suffix: _binController.text.length > 0
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    _binController.clear();
                                  });
                                },
                                child: Icon(Icons.clear,
                                    size: 18, color: Colors.red))
                            : Container(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 2.0),
                        ),
                        labelText: 'Scan bin',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 20))),
              ),
            ),
         
          //Scan Bin Button
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 140,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      side: BorderSide(color: Colors.red))),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.white;
                              return Colors
                                  .white; // Use the component's default.
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            '  Skip  ',
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: fonts.openSans,
                                fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            // generatedBundleList.add(GeneratedBundle(
                            //     bundleQty: bundleQty.text,
                            //     label: label,
                            //     transferBundleToBin: getpostBundletoBin(),
                            //     rejectedQty: total(),
                            //     bundleDetial: null, bundleDetail: null));
                            clear();
                            widget.sendData(generatedBundleList.length);
                            status = Status.generateLabel;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 140,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  side: BorderSide(color: Colors.transparent))),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green.shade200;
                              return Colors
                                  .red.shade400; // Use the component's default.
                            },
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            '  Scan Bin  ',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: fonts.openSans,
                                fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          Future.delayed(
                            const Duration(milliseconds: 50),
                            () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            },
                          );
                          if (_binController.text.length > 0) {
                            setState(() {
                              status = Status.scanBundle;
                            });
                          } else {
                            AlertController.show(
                              "Bin not Scanned",
                              "",
                              TypeAlert.error,
                            );
                            Fluttertoast.showToast(
                              msg: "Bin not Scanned",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget bundleScan() {
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Bundle ID: ${getpostBundletoBin().bundleId}",
                style: TextStyle(
                    fontFamily: fonts.openSans,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )),
        Container(
          width: MediaQuery.of(context).size.width * 0.75 - 4,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextField(
                        autofocus: true,
                        focusNode: _bundleFocus,
                        controller: _bundleScanController,
                        style:
                            TextStyle(fontFamily: fonts.openSans, fontSize: 20),
                        onSubmitted: (value) {
                          if (_bundleScanController.text.length > 0) {
                            if (_bundleScanController.text ==
                                getpostBundletoBin().bundleId) {
                              apiService.postTransferBundletoBin(
                                  transferBundleToBin: [
                                    getpostBundletoBin()
                                  ]).then((value) {
                                if (value != null) {
                                  BundleTransferToBin
                                      bundleTransferToBinTracking = value[0];
                                  AlertController.show(
                                    "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                    "",
                                    TypeAlert.success,
                                  );
                                  Fluttertoast.showToast(
                                      msg:
                                          "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  setState(() {
                                    // generatedBundleList.add
                                    // (GeneratedBundle(
                                    //     bundleQty: bundleQty.text,
                                    //     label: label,
                                    //     transferBundleToBin:
                                    //         getpostBundletoBin(),
                                    //     rejectedQty: total()));
                                    widget.sendData(generatedBundleList.length);
                                    clear();
                                    _bundleScanController.clear();
                                    _binController.clear();

                                    status = Status.generateLabel;
                                  });
                                } else {
                                  _bundleFocus.requestFocus();
                                  _bundleScanController.clear();
                                  AlertController.show(
                                    "Unable to transfer Bundle to Bin",
                                    "",
                                    TypeAlert.error,
                                  );
                                  Fluttertoast.showToast(
                                    msg: "Unable to transfer Bundle to Bin",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              });
                            } else {
                              _bundleFocus.requestFocus();
                              _bundleScanController.clear();
                              AlertController.show(
                                "Wrong Bundle Id",
                                "",
                                TypeAlert.error,
                              );
                              Fluttertoast.showToast(
                                msg: "Wrong Bundle Id",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          } else {
                            _bundleScanController.clear();
                            _bundleFocus.requestFocus();
                            AlertController.show(
                              "Bundle Not Scanned",
                              "",
                              TypeAlert.error,
                            );
                            Fluttertoast.showToast(
                              msg: "Bundle Not Scanned",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        onTap: () {
                          setState(() {});
                        },
                        onChanged: (value) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          setState(() {
                            bundleId = value;
                          });
                        },
                        decoration: new InputDecoration(
                            suffix: _bundleScanController.text.length > 0
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _bundleScanController.clear();
                                      });
                                    },
                                    child: Icon(Icons.clear,
                                        size: 18, color: Colors.red))
                                : Container(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 2.0),
                            ),
                            labelText: 'Scan Bundle',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 20))),
                  ),
                ),
            
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: BorderSide(color: Colors.red))),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.green.shade200;
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              '  Back  ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: fonts.openSans,
                                  fontSize: 16),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              status = Status.scanBin;
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.green.shade200;
                                return Colors
                                    .red; // Use the component's default.
                              },
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Save & Scan Next',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: fonts.openSans,
                                  fontSize: 16),
                            ),
                          ),
                          onPressed: () {
                            if (_bundleScanController.text.length > 0) {
                              if (_bundleScanController.text ==
                                  getpostBundletoBin().bundleId) {
                                apiService.postTransferBundletoBin(
                                    transferBundleToBin: [
                                      getpostBundletoBin()
                                    ]).then((value) {
                                  if (value != null) {
                                    BundleTransferToBin
                                        bundleTransferToBinTracking = value[0];
                                    AlertController.show(
                                      "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                      "",
                                      TypeAlert.success,
                                    );
                                    Fluttertoast.showToast(
                                        msg:
                                            "Transfered Bundle-${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text ?? ''}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    setState(() {
                                      // generatedBundleList.add(GeneratedBundle(
                                      //     bundleQty: bundleQty.text,
                                      //     label: label,
                                      //     transferBundleToBin:
                                      //         getpostBundletoBin(),
                                      //     rejectedQty: total()));
                                      getBundles();
                                      widget
                                          .sendData(generatedBundleList.length);
                                      clear();
                                      _bundleScanController.clear();
                                      _binController.clear();
                                      // label = new GeneratedLabel();
                                      status = Status.generateLabel;
                                    });
                                  } else {
                                    AlertController.show(
                                      "Unable to transfer Bundle to Bin",
                                      "",
                                      TypeAlert.error,
                                    );
                                    Fluttertoast.showToast(
                                      msg: "Unable to transfer Bundle to Bin",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                });
                              } else {
                                AlertController.show(
                                  "Wrong Bundle Id",
                                  "",
                                  TypeAlert.error,
                                );
                                Fluttertoast.showToast(
                                  msg: "Wrong Bundle Id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            } else {
                              AlertController.show(
                                "Bundle Not Scanned",
                                "",
                                TypeAlert.warning,
                              );
                              Fluttertoast.showToast(
                                msg: "Bundle Not Scanned",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        side: BorderSide(color: Colors.red))),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.red.shade200;
                                    return Colors
                                        .white; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  printerStatus = true;
                                });
                                DateTime now = DateTime.now();
                                _print(
                                  ipaddress: "${widget.machine.printerIp}",
                                  // ipaddress: "172.26.59.14",
                                  bq: label.bundleQuantity.toString(),
                                  qr: "${label.bundleId}",
                                  routenumber1: "${label.routeNo}",
                                  date: now.day.toString() +
                                      "-" +
                                      now.month.toString() +
                                      "-" +
                                      now.year.toString(),
                                  orderId: "${widget.schedule.orderId}",
                                  fgPartNumber:
                                      "${widget.schedule.finishedGoodsNumber}",
                                  cutlength: "${widget.schedule.length}",
                                  cablepart:
                                      "${widget.schedule.cablePartNumber}",
                                  wireGauge: "${label.wireGauge}",
                                  terminalfrom: "${label.terminalFrom}",
                                  terminalto: "${label.terminalTo}",
                                  userid: "${widget.employee.empId}",
                                  shift: "${widget.schedule.shiftNumber}",
                                  machine: "${widget.machine.machineNumber}",
                                ).then((value) {
                                  setState(() {
                                    printerStatus = false;
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.print,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              )),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }



  TransferBundleToBin getpostBundletoBin() {
    TransferBundleToBin bundleToBin = TransferBundleToBin(
        binIdentification: _binController.text, bundleId: label.bundleId);
    return bundleToBin;
  }

  String otherTotal() {
    int getTotalint(List<TextEditingController> textList) {
      int total = 0;
      for (int i = 0; i < textList.length; i++) {
        total = total +
            int.parse(textList[i].text.length > 0 ? textList[i].text : '0');
      }
      return total;
    }

    return getTotalint([
      endWireController,
      endTerminalControllerFrom,
      endTerminalControllerTo,
      cfmRejectionsControllerCable,
      cfmRejectionsControllerFrom,
      cfmRejectionsControllerTo,
      cvmRejectionsControllerCable,
      cvmRejectionsControllerTo,
      cvmRejectionsControllerFrom,
      setupRejectionsControllerCable,
      setupRejectionsControllerFrom,
      setupRejectionsControllerTo
    ]).toString();
  }

  String total() {
    int total = int.parse(cableDamageController.text.length > 0
            ? cableDamageController.text
            : '0') +
        int.parse(lengthvariationController.text.length > 0
            ? lengthvariationController.text
            : '0') +
        int.parse(rollerMarkController.text.length > 0
            ? rollerMarkController.text
            : '0') +
        int.parse(stripLengthVariationController.text.length > 0
            ? stripLengthVariationController.text
            : '0') +
        int.parse(nickMarkController.text.length > 0
            ? nickMarkController.text
            : '0') +
        int.parse(terminalDamageController.text.length > 0
            ? terminalDamageController.text
            : '0') +
        int.parse(terminalBendController.text.length > 0
            ? terminalBendController.text
            : '0') +
        int.parse(terminalTwistController.text.length > 0
            ? terminalTwistController.text
            : '0') +
        int.parse(windowGapController.text.length > 0
            ? windowGapController.text
            : '0') +
        int.parse(crimpOnInsulationController.text.length > 0
            ? crimpOnInsulationController.text
            : '0') +
        int.parse(bellMoutherrorController.text.length > 0
            ? bellMoutherrorController.text
            : '0') +
        int.parse(
            cutoffBarController.text.length > 0 ? cutoffBarController.text : '0') +
        int.parse(exposureStrandsController.text.length > 0 ? exposureStrandsController.text : '0') +
        int.parse(strandsCutController.text.length > 0 ? strandsCutController.text : '0') +
        int.parse(brushLengthLessorMoreController.text.length > 0 ? brushLengthLessorMoreController.text : '0') +
        int.parse(halfCurlingController.text.length > 0 ? halfCurlingController.text : '0') +
        int.parse(wrongTerminalController.text.length > 0 ? wrongTerminalController.text : '0') +
        int.parse(wrongcableController.text.length > 0 ? wrongcableController.text : '0') +
        int.parse(seamOpenController.text.length > 0 ? seamOpenController.text : '0') +
        int.parse(wrongCutLengthController.text.length > 0 ? wrongCutLengthController.text : '0') +
        int.parse(missCrimpController.text.length > 0 ? missCrimpController.text : '0') +
        int.parse(extrusionBurrController.text.length > 0 ? extrusionBurrController.text : '0');
    return total == null ? '0' : total.toString();
  }

  Future<void> showBundleDetail(GeneratedBundle generatedBundle) async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {},
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context1) {
        return Center(
          child: AlertDialog(
            title: Container(
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context1);
                          },
                          icon: Icon(Icons.close),
                          color: Colors.red)),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Bundle Detail"),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  field(
                                      title: "Bundle ID",
                                      data:
                                          "${generatedBundle.label.bundleId}"),
                                  field(
                                      title: "Bundle Qty",
                                      data:
                                          generatedBundle.bundleQty.toString()),
                                  field(
                                      title: "Bundle Status",
                                      data: "${generatedBundle.label.status}"),
                                  field(
                                      title: "Cut Length",
                                      data:
                                          "${generatedBundle.label.cutLength}"),
                                  field(
                                      title: "Color",
                                      data:
                                          "${generatedBundle.bundleDetail.color}"),
                                ],
                              ),
                              Column(
                                children: [
                                  field(
                                      title: "Cable Part Number",
                                      data: generatedBundle
                                          .bundleDetail.cablePartNumber
                                          .toString()),
                                  field(
                                    title: "Cable part Description",
                                    data: generatedBundle
                                        .bundleDetail.cablePartDescription,
                                  ),
                                  field(
                                    title: "Finished Goods",
                                    data: generatedBundle
                                        .bundleDetail.finishedGoodsPart
                                        .toString(),
                                  ),
                                  field(
                                    title: "Order Id",
                                    data:
                                        "${generatedBundle.bundleDetail.orderId}",
                                  ),
                                  field(
                                    title: "Update From",
                                    data:
                                        "${generatedBundle.bundleDetail.updateFromProcess}",
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  field(
                                    title: "Machine Id",
                                    data:
                                        "${generatedBundle.bundleDetail.machineIdentification}",
                                  ),
                                  field(
                                    title: "Schedule ID",
                                    data: generatedBundle
                                        .bundleDetail.scheduledId
                                        .toString(),
                                  ),
                                  field(
                                    title: "Finished Goods",
                                    data: generatedBundle
                                        .bundleDetail.finishedGoodsPart
                                        .toString(),
                                  ),
                                  field(
                                    title: "Bin Id",
                                    data: generatedBundle.bundleDetail.binId
                                        .toString(),
                                  ),
                                  field(
                                    title: "Location Id",
                                    data:
                                        "${generatedBundle.bundleDetail.locationId}",
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget field({String? title, required String data}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "$title",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  "$data",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class GeneratedBundle {
  String bundleQty;
  TransferBundleToBin transferBundleToBin;
  GeneratedLabel label;
  String rejectedQty;
  BundlesRetrieved bundleDetail;
  GeneratedBundle(
      {required this.rejectedQty,
      required this.bundleQty,
      required this.label,
      required this.transferBundleToBin,
      required this.bundleDetail,
      bundleDetial});
}

Future<bool> _print({
  required String ipaddress,
  required String bq,
  required String qr,
  required String routenumber1,
  required String date,
  required String orderId,
  required String fgPartNumber,
  required String cutlength,
  required String cablepart,
  required String wireGauge,
  required String terminalfrom,
  required String terminalto,
  required String userid,
  required String shift,
  required String machine,
}) async {
  log("ipaddress  $ipaddress");
  log("bq  $bq");
  log("qr  $qr");
  log("routenumber1  $routenumber1");
  log("date  $date");
  log("orderId  $orderId");
  log("fgPartNumber  $fgPartNumber");
  log("cutlength  $cutlength");
  log("cablepart  $cablepart");
  log("wireGauge  $wireGauge");
  log("terminalfrom  $terminalfrom");
  log("terminalto  $terminalto");
  log("userid  $userid");
  log("shift  $shift");
  log("machine  $machine");

  DynamicLibrary tsclib = DynamicLibrary.open("TSCLIB.dll");

  //openport
  Pointer<Utf8> Function(Pointer<Utf8> str) openport = tsclib
      .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8> str)>>(
          "openport")
      .asFunction();
  //cloaseport
  int Function() closeport =
      tsclib.lookup<NativeFunction<Int32 Function()>>("closeport").asFunction();
  //barcode
  Pointer<Utf8> Function(
          Pointer<Utf8> x,
          Pointer<Utf8> y,
          Pointer<Utf8> type,
          Pointer<Utf8> height,
          Pointer<Utf8> readable,
          Pointer<Utf8> rotation,
          Pointer<Utf8> narrow,
          Pointer<Utf8> wide,
          Pointer<Utf8> code) barcode =
      tsclib
          .lookup<
              NativeFunction<
                  Pointer<Utf8> Function(
                      Pointer<Utf8> x,
                      Pointer<Utf8> y,
                      Pointer<Utf8> type,
                      Pointer<Utf8> height,
                      Pointer<Utf8> readable,
                      Pointer<Utf8> rotation,
                      Pointer<Utf8> narrow,
                      Pointer<Utf8> wide,
                      Pointer<Utf8> code)>>("barcode")
          .asFunction();
  //clearbuffer
  Pointer<Utf8> Function() clearbuffer = tsclib
      .lookup<NativeFunction<Pointer<Utf8> Function()>>("clearbuffer")
      .asFunction();
  // sendcommand
  Pointer<Utf8> Function(Pointer<Utf8> printercommand) sendcommand = tsclib
      .lookup<
          NativeFunction<
              Pointer<Utf8> Function(
                  Pointer<Utf8> printercommand)>>("sendcommand")
      .asFunction();
  //setup
  Pointer<Utf8> Function(
    Pointer<Utf8> width,
    Pointer<Utf8> height,
    Pointer<Utf8> speed,
    Pointer<Utf8> density,
    Pointer<Utf8> sensor,
    Pointer<Utf8> vertical,
    Pointer<Utf8> offset,
  ) setup = tsclib
      .lookup<
          NativeFunction<
              Pointer<Utf8> Function(
        Pointer<Utf8> width,
        Pointer<Utf8> height,
        Pointer<Utf8> speed,
        Pointer<Utf8> density,
        Pointer<Utf8> sensor,
        Pointer<Utf8> vertical,
        Pointer<Utf8> offset,
      )>>("setup")
      .asFunction();

  //printlabel
  int Function(Pointer<Utf8> se, Pointer<Utf8> copy) printlabel = tsclib
      .lookup<
          NativeFunction<
              Int32 Function(
                  Pointer<Utf8> se, Pointer<Utf8> copy)>>("printlabel")
      .asFunction();
  Pointer<Utf8> Function(Pointer<Utf8> str) usbprintername = tsclib
      .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8> str)>>(
          "usbprintername")
      .asFunction();
  String b1 = "20080101";
  String wt1 = "TSC Printers";
  String printerStatus;
  openport("$ipaddress".toNativeUtf8());
  setup(
      "101".toNativeUtf8(),
      "50".toNativeUtf8(),
      "4".toNativeUtf8(),
      "4".toNativeUtf8(),
      "0".toNativeUtf8(),
      "3".toNativeUtf8(),
      "0".toNativeUtf8());
  clearbuffer();
  sendcommand("SET TEAR ON\n".toNativeUtf8());
  sendcommand("CLS\n".toNativeUtf8());
  sendcommand(
      "BITMAP 403,1,1,400,1,ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ\n"
          .toNativeUtf8());
  sendcommand("QRCODE 772,282,L,8,A,180,M2,S7,\"${qr}\"\n".toNativeUtf8());
  sendcommand("CODEPAGE 1252\n".toNativeUtf8());
  sendcommand("TEXT 514,13,\"0\",90,7,7,\"ROUTE NO\"\n".toNativeUtf8());
  sendcommand("TEXT 487,13,\"0\",90,8,8,\"${routenumber1}\"\n".toNativeUtf8());
  // TscEthernetDll.sendcommand("TEXT 773,40,\"0\",180,9,9,\"\"\n");
  sendcommand("TEXT 315,384,\"0\",180,9,9,\"FG PART NO:\"\n".toNativeUtf8());
  sendcommand("TEXT 315,69,\"0\",180,9,9,\"TERMINAL P/N \\[\"]TO\\[\"]:\"\n"
      .toNativeUtf8());
  sendcommand("TEXT 315,325,\"0\",180,9,9,\"ORDER ID:\"\n".toNativeUtf8());
  sendcommand("TEXT 315,292,\"0\",180,9,9,\"CUT LENGTH:\"\n".toNativeUtf8());
  sendcommand("TEXT 315,195,\"0\",180,9,9,\"WIRE GAUGE:\"\n".toNativeUtf8());
  sendcommand("TEXT 316,131,\"0\",180,9,9,\"TERMINAL P/N \\[\"] FROM\\[\"]:\"\n"
      .toNativeUtf8());
  sendcommand("TEXT 315,259,\"0\",180,9,9,\"CABLE PART#:\"\n".toNativeUtf8());
  sendcommand(
      "TEXT 315,356,\"0\",180,9,9,\"${fgPartNumber}\"\n".toNativeUtf8());
  sendcommand("TEXT 315,37,\"0\",180,9,9,\"${terminalto}\"\n".toNativeUtf8());
  sendcommand("TEXT 205,325,\"0\",180,9,9,\"${orderId}\"\n".toNativeUtf8());
  sendcommand("TEXT 173,292,\"0\",180,9,9,\"${cutlength}\"\n".toNativeUtf8());
  sendcommand("TEXT 315,168,\"0\",180,9,9,\"${wireGauge}\"\n".toNativeUtf8());
  sendcommand(
      "TEXT 315,103,\"0\",180,9,9,\"${terminalfrom}\"\n".toNativeUtf8());
  sendcommand("TEXT 315,231,\"0\",180,9,9,\"${cablepart}\"\n".toNativeUtf8());
  sendcommand("TEXT 773,67,\"0\",180,8,8,\"BUNDLE QTY:\"\n".toNativeUtf8());
  sendcommand("TEXT 633,67,\"0\",180,8,8,\"${bq}\"\n".toNativeUtf8());
  sendcommand("TEXT 773,34,\"0\",180,8,8,\"${date}\"\n".toNativeUtf8());
  sendcommand("TEXT 774,379,\"0\",180,8,8,\"BUNDLE ID:\"\n".toNativeUtf8());
  sendcommand("TEXT 773,315,\"0\",180,8,8,\"MC ID:\"\n".toNativeUtf8());
  sendcommand("TEXT 644,34,\"0\",180,8,8,\"SHIFT:\"\n".toNativeUtf8());
  sendcommand("TEXT 579,34,\"0\",180,8,8,\"${shift}\"\n".toNativeUtf8());
  sendcommand("TEXT 683,345,\"0\",180,8,8,\"${userid}\"\n".toNativeUtf8());
  sendcommand("TEXT 653,379,\"0\",180,8,8,\"${qr}\"\n".toNativeUtf8());
  sendcommand("TEXT 773,345,\"0\",180,8,8,\"USER ID:\"\n".toNativeUtf8());
  sendcommand("TEXT 706,315,\"0\",180,8,8,\"${machine}\"\n".toNativeUtf8());
  sendcommand("PRINT 1,1\"\n".toNativeUtf8());
  sendcommand("PUTBMP 100,520,\"Triangle.bmp\"\n".toNativeUtf8());
  int a = printlabel("1".toNativeUtf8(), "1".toNativeUtf8());
  log('print label : $a   $ipaddress');

  //TSCLIB::sendBinaryData(binary, (DWORD)strlen(binary));
  closeport();
  printerStatus = 'Printer status : $a  .';
  log("terminal : $terminalfrom");

  if (a == 0) {
    AlertController.show(
      "Failed to get printer",
      "status code : '${a}'",
      TypeAlert.error,
    );
    return false;
  } else {
    AlertController.show(
      "$printerStatus",
      "",
      TypeAlert.warning,
    );
    return true;
  }
}
