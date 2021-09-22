import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/cableDetails_model.dart';
import 'package:molex_desktop/model_api/cableTerminalA_model.dart';
import 'package:molex_desktop/model_api/cableTerminalB_model.dart';
import 'package:molex_desktop/model_api/fgDetail_model.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/model_api/process1/100Complete_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/models/bundle_print.dart';
import 'package:molex_desktop/screens/operator/process/partiallyComplete.dart';
import 'package:molex_desktop/screens/operator/process/return_raw_material.dart';
import 'package:molex_desktop/screens/utils/fonts.dart';
import 'package:molex_desktop/screens/widgets/P1_autoCutScheduledetail.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/api_service.dart';
import '../../../main.dart';
import '../location.dart';
import '../materialPick.dart';
import '100complete.dart';
import 'drawerWIP.dart';
import 'generate_label.dart';

class ProcessPage extends StatefulWidget {
  Schedule schedule;
  String rightside;
  Employee employee;
  MachineDetails machine;
  MatTrkPostDetail matTrkPostDetail;
  ProcessPage(
      {required this.schedule,
      required this.rightside,
      required this.machine,
      required this.employee,
      required this.matTrkPostDetail});
  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  late String? _chosenValue;
  late String value;
  String output = '';
  String _output = '';
  TextEditingController _qtyController = new TextEditingController();
  bool processStarted = false;
  List<BundlePrint> bundlePrint = [];
  static const platform = const MethodChannel('com.impereal.dev/tsc');
  String _printerStatus = 'Waiting';
  bool orderDetailExpanded = true;
  String rightside = 'label';
  late ApiService apiService;
  String method = '';
  late List<String> items;
  int bundleQty = 0;
  int totalquantity = 0;
  @override
  void initState() {
    apiService = new ApiService();
    SystemChrome.setEnabledSystemUIOverlays([]);
    items = widget.machine.category!.contains("Cutting")
        ? <String>['Cutlength & both Side Stripping']
        : <String>[
            'Crimp From, Cutlength, Crimp To',
            'Crimp From, Cutlength',
            'Cutlength, Crimp To',
            'Cutlength & both Side Stripping',
          ];
         
    _chosenValue = items.contains(widget.schedule.process)
        ? "${widget.schedule.process}"
        : null;
    getMethod("$_chosenValue");
    // _chosenValue = widget.machine.category.contains("Cutting")
    //     ? 'Cutlength & both side stripping'
    //     : 'Crimp-From,Cutlength,Crimp-To';
    totalquantity = widget.schedule.actualQuantity;
    super.initState();
  }

  getMethod(String value) {
    setState(() {
      if (value == "Crimp From, Cutlength, Crimp To") {
        method = 'a-b-c';
      }
      if (value == "Crimp From, Cutlength") {
        method = 'a-c';
      }
      if (value == "Cutlength, Crimp To") {
        method = 'b-c';
      }
      if (value == "Cutlength & both Side Stripping") {
        method = 'c';
      }
      if (value == "CRIMP-FROM") {
        method = 'a';
      }
      if (value == "CRIMP-TO") {
        method = 'b';
      }
    });
  }

  void continueProcess(String name) {
    setState(() {
      rightside = name;
    });
  }

  void reload(MatTrkPostDetail matTrkPostDetail) {
    setState(() {
      widget.matTrkPostDetail = matTrkPostDetail;
    });
  }

  void reloadlabel() {
    setState(() {
      widget.matTrkPostDetail = widget.matTrkPostDetail;
    });
  }

  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    Timer timer = new Timer(new Duration(seconds: 2), () {
      log("message reload");
      completer.complete();
      setState(() {});
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        title: startProcess(),

        // Text(
        //   '${widget.machine.category}',
        //   style: TextStyle(fontSize: 16, color: Colors.red),
        // ),drop
        elevation: 0,
        actions: [
          //machineID
          Container(
            padding: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            "${widget.employee.empId}",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ],
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        machineDetail(
                            context: context, machineDetails: widget.machine);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.settings,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                            ),
                            Text(
                              widget.machine.machineNumber ?? "",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          TimeDisplay(),
        ],
      ),
      drawer: DrawerWidgetWIP(
        employee: widget.employee,
        machineDetails: widget.machine,
        schedule: widget.schedule,
        returnmaterial: () {
          showReturnMaterial(context, widget.matTrkPostDetail, widget.machine);
        },
        transfer: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Location(
                      locationType: LocationType.partialTransfer,
                      type: "process",
                      employee: widget.employee,
                      machine: widget.machine,
                    )),
          );
        },
        reloadmaterial: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MaterialPick(
                      schedule: widget.schedule,
                      employee: widget.employee,
                      reload: reload,
                      machine: widget.machine,
                      materialPickType: MaterialPickType.reload,
                    )),
          );
        },
        type: '',
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              P1ScheduleDetailWIP(schedule: widget.schedule),
              // startProcess(),
              terminal(),
              Container(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: (() {
                              if (rightside == null) {
                                return Container();
                              } else if (rightside == "label") {
                                return GenerateLabel(
                                  reload: reloadlabel,
                                  schedule: widget.schedule,
                                  machine: widget.machine,
                                  employee: widget.employee,
                                  processStarted: processStarted,
                                  matTrkPostDetail: widget.matTrkPostDetail,
                                  toalQuantity: totalquantity,
                                  transfer: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Location(
                                                locationType: LocationType
                                                    .partialTransfer,
                                                type: "process",
                                                employee: widget.employee,
                                                machine: widget.machine,
                                              )),
                                    );
                                  },
                                  updateQty: (value) {
                                    log("QTYY : $value");
                                    setState(() {
                                      totalquantity = value;
                                    });
                                  },
                                  method: method,
                                  startprocess: () {
                                    setState(() {
                                      processStarted = true;
                                    });
                                  },
                                  fullcomplete: () {
                                    if (widget.machine.category ==
                                            "Manual Cutting" ||
                                            widget.machine.category ==
                                            "Automatic Cutting" ||
                                        widget.schedule.process == "Cutting") {
                                      setState(() {
                                        rightside = 'complete';
                                      });
                                    } else {
                                      print("pushed");
                                      Future.delayed(Duration.zero, () {
                                        FullyCompleteModel fullyComplete =
                                            FullyCompleteModel(
                                          finishedGoodsNumber: int.parse(widget
                                              .schedule.finishedGoodsNumber),
                                          purchaseOrder: int.parse(
                                              widget.schedule.orderId),
                                          orderId: int.parse(
                                              widget.schedule.orderId),
                                          cablePartNumber: int.parse(
                                              widget.schedule.cablePartNumber),
                                          length:
                                              int.parse(widget.schedule.length),
                                          color: widget.schedule.color,
                                          scheduledStatus: "Complete",
                                          scheduledId: int.parse(
                                              widget.schedule.scheduledId),
                                          scheduledQuantity: int.parse(widget
                                              .schedule.scheduledQuantity),
                                          machineIdentification:
                                              widget.machine.machineNumber,
                                          //TODO bundle ID
                                        );
                                        apiService
                                            .post100Complete(fullyComplete)
                                            .then((value) {
                                          if (value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Location(
                                                        type: "process",
                                                        employee:
                                                            widget.employee,
                                                        machine: widget.machine,
                                                        locationType:
                                                            LocationType
                                                                .finaTtransfer,
                                                      )),
                                            ).then((value) {
                                              setState(() {
                                                rightside = 'label';
                                              });
                                            });
                                          } else {}
                                        });
                                      });
                                    }
                                  },
                                  partialComplete: () {
                                    setState(() {
                                      rightside = "partial";
                                    });
                                  },
                                  sendData: (value) {
                                    setState(() {
                                      bundleQty = value;
                                    });
                                  },
                                );
                              } else if (rightside == "complete") {
                                return FullyComplete(
                                  employee: widget.employee,
                                  machine: widget.machine,
                                  schedule: widget.schedule,
                                  continueProcess: continueProcess,
                                  bundleId: '',
                                );
                                // if (widget.machine.category == "Manual Cutting" ||
                                //     widget.schedule.process == "Cutting") {
                                //   return FullyComplete(
                                //     employee: widget.employee,
                                //     machine: widget.machine,
                                //     schedule: widget.schedule,
                                //     continueProcess: continueProcess,
                                //   );
                                // } else {
                                //   print("pushed");
                                //   Future.delayed(Duration.zero, () {
                                //     FullyCompleteModel fullyComplete =
                                //         FullyCompleteModel(
                                //       finishedGoodsNumber: int.parse(
                                //           widget.schedule.finishedGoodsNumber),
                                //       purchaseOrder:
                                //           int.parse(widget.schedule.orderId),
                                //       orderId: int.parse(widget.schedule.orderId),
                                //       cablePartNumber: int.parse(
                                //           widget.schedule.cablePartNumber),
                                //       length: int.parse(widget.schedule.length),
                                //       color: widget.schedule.color,
                                //       scheduledStatus: "Complete",
                                //       scheduledId:
                                //           int.parse(widget.schedule.scheduledId),
                                //       scheduledQuantity: int.parse(
                                //           widget.schedule.scheduledQuantity),
                                //       machineIdentification:
                                //           widget.machine.machineNumber,
                                //       //TODO bundle ID
                                //     );
                                //     apiService
                                //         .post100Complete(fullyComplete)
                                //         .then((value) {
                                //       if (value) {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => Location(
                                //                     type: "process",
                                //                     employee: widget.employee,
                                //                     machine: widget.machine,
                                //                   )),
                                //         ).then((value) {
                                //           setState(() {
                                //             rightside = 'label';
                                //           });
                                //         });
                                //       } else {}
                                //     });
                                //   });
                                // }
                              } else if (rightside == "partial") {
                                return PartiallyComplete(
                                    employee: widget.employee,
                                    machine: widget.machine,
                                    continueProcess: continueProcess,
                                    schedule: widget.schedule);
                              } else if (rightside == "bundle") {
                                return Container();
                              } else {
                                return Container();
                              }
                            }()),
                          ),
                        ),
                      ],
                    ),
                    //buttons
                    // Table for bundles generated
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Bundle table
  // Widget bundleTable() {
  //   // SystemChannels.textInput.invokeMethod('TextInput.hide');
  //   return DataTable(
  //       columnSpacing: 40,
  //       columns: const <DataColumn>[
  //         DataColumn(
  //           label: Text('No.'),
  //         ),
  //         DataColumn(
  //           label: Text('Bundle Id'),
  //         ),
  //         DataColumn(
  //           label: Text('Bundel Qty'),
  //         ),
  //         DataColumn(
  //           label: Text('Action'),
  //         ),
  //       ],
  //       rows: bundlePrint
  //           .map((e) => DataRow(cells: <DataCell>[
  //                 DataCell(Text("1")),
  //                 DataCell(Text("${e.bundelId}")),
  //                 DataCell(Text("${e.bundleQty}")),
  //                 DataCell(ElevatedButton(
  //                   onPressed: () {
  //                     _print();
  //                   },
  //                   style: ButtonStyle(
  //                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                         RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12.0),
  //                             side: BorderSide(color: Colors.red))),
  //                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
  //                       (Set<MaterialState> states) {
  //                         if (states.contains(MaterialState.pressed))
  //                           return Colors.redAccent;
  //                         return Colors.red; // Use the component's default.
  //                       },
  //                     ),
  //                   ),
  //                   child: Text(
  //                     "Print",
  //                     style: TextStyle(color: Colors.white, fontSize: 12),
  //                   ),
  //                 ))
  //               ]))
  //           .toList());
  // }

  Future<void> _showConfirmationDialog() async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        // SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Transfer'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Status ${_printerStatus}')],
            ),
          ),
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
                      // SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                  );
                },
                child: Text('Cancel Transfer')),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.green),
                ),
                onPressed: () {},
                child: Text('Confirm Transfer')),
          ],
        );
      },
    );
  }

  //Material Sheet for qty
  Widget terminal() {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.17,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: widget.machine.category == "Automatic Cutting"
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceEvenly,
          children: [
            // terminal A
            Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: FutureBuilder(
                    future: apiService.getCableTerminalA(
                        fgpartNo: widget.schedule.finishedGoodsNumber,
                        cablepartno: widget.schedule.cablePartNumber ??
                            widget.schedule.finishedGoodsNumber,
                        length: widget.schedule.length,
                        color: widget.schedule.color,
                        awg: widget.schedule.awg),
                    builder: (context, snapshot) {
                      CableTerminalA terminalA =
                          snapshot.data as CableTerminalA;
                      if (snapshot.hasData) {
                        return process(
                            'From Process',
                            '',
                            // 'From Strip Length Spec(mm) - ${terminalA.fronStripLengthSpec}',
                            'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                            '(${terminalA.processType})(${terminalA.stripLength})(${terminalA.terminalPart})(${terminalA.specCrimpLength})(${terminalA.pullforce})(${terminalA.comment})',
                            '',
                            0.35,
                            method.contains('a') ? true : false);
                      } else {
                        return process(
                            'From Process',
                            '',
                            'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                            '(-)()(-)(-)(-)',
                            '',
                            0.325,
                            method.contains('a') ? true : false);
                      }
                    }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder(
                  future: apiService.getCableDetails(
                      fgpartNo: widget.schedule.finishedGoodsNumber,
                      cablepartno: widget.schedule.cablePartNumber ?? "0",
                      length: widget.schedule.length,
                      color: widget.schedule.color,
                      awg: widget.schedule.awg),
                  builder: (context, snapshot) {
                    CableDetails cableDetail = snapshot.data as CableDetails;
                    if (snapshot.hasData) {
                      return cable(
                          cableDetails: cableDetail,
                          width: 0.28,
                          color: method.contains('c') ? true : false);
                      // process(
                      //     'Cable',
                      //     'Cut Length Spec(mm) -${cableDetail.cutLengthSpec}',
                      //     'Cable Part Number(Description)',
                      //     '${cableDetail.cablePartNumber}(${cableDetail.description})',
                      //     'From Strip Length Spec(mm) : ${cableDetail.stripLengthFrom} \n To Strip Length Spec(mm) : ${cableDetail.stripLengthTo}',
                      //     0.28);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder(
                  future: apiService.getCableTerminalB(
                      fgpartNo: widget.schedule.finishedGoodsNumber,
                      cablepartno: widget.schedule.cablePartNumber ??
                          widget.schedule.finishedGoodsNumber,
                      length: widget.schedule.length,
                      color: widget.schedule.color,
                      awg: widget.schedule.awg),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      CableTerminalB cableTerminalB =
                          snapshot.data as CableTerminalB;
                      return process(
                          'To Process',
                          '',
                          'Process(Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                          '(${cableTerminalB.processType})(${cableTerminalB.stripLength})(${cableTerminalB.terminalPart})(${cableTerminalB.specCrimpLength})(${cableTerminalB.pullforce})(${cableTerminalB.comment})',
                          '',
                          0.35,
                          method.contains('b') ? true : false);
                    } else {
                      return process(
                          'To Process',
                          'From Strip Length Spec(mm) - 40}',
                          'Process (Strip Length)(Terminal Part#)Spec-(Crimp Height)(Pull Force)(Cmt)',
                          '(-)()(-)(-)(-)',
                          '',
                          0.35,
                          method.contains('b') ? true : false);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget process(String p1, String p2, String p3, String p4, String p5,
      double width, bool color) {
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.transparent)),
      shadowColor: Colors.grey[100],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        // height: 91,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: color ? Colors.red[50] : Colors.white,
          border: Border.all(
              width: 1.5, color: color ? Colors.red.shade500 : Colors.white),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          p1,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: fonts.openSans),
                        ),
                        SizedBox(width: 20),
                        Text(
                          p2,
                          style: TextStyle(fontSize: 14, fontFamily: ''),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      p3,
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * width,
                      child: Text(p4,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontFamily: fonts.openSans,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    SizedBox(height: 4),
                    Text(
                      p5,
                      style: TextStyle(fontSize: 14, fontFamily: ''),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cable(
      {required CableDetails cableDetails,
      required double width,
      required bool color}) {
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.transparent)),
      shadowColor: Colors.grey[100],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        // // height: 91,
        // width: MediaQuery.of(context).size.width * width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: color ? Colors.red[50] : Colors.white,
          border: Border.all(
              width: 1.5, color: color ? Colors.red.shade500 : Colors.white),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Cable",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: ''),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Cut Length Spec(mm) -${cableDetails.cutLengthSpec}",
                          style: TextStyle(fontSize: 16, fontFamily: ''),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Cable Part Number(Description)",
                      style: TextStyle(fontSize: 10),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * width,
                      child: Text(
                          "${cableDetails.cablePartNumber}(${cableDetails.description})",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontFamily: fonts.openSans,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    SizedBox(height: 1),
                    Container(
                      width: MediaQuery.of(context).size.width * width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "From Strip Length Spec(mm) :",
                                style: TextStyle(
                                    fontSize: 14, fontFamily: fonts.openSans),
                              ),
                              Text(
                                "${cableDetails.stripLengthFrom} ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: fonts.openSans,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "To Strip Length Spec(mm) :  ",
                                style: TextStyle(
                                    fontSize: 14, fontFamily: fonts.openSans),
                              ),
                              Text(
                                "${cableDetails.stripLengthTo}",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: fonts.openSans,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tableHeading() {
    double width = MediaQuery.of(context).size.width;
    Widget cell(String name, double d) {
      return Container(
        color: Colors.white,
        width: width * d,
        height: 15,
        child: Center(
          child: Text(
            name,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
      );
    }

    return Container(
      height: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cell("Order Id", 0.1),
              cell("FG Part", 0.1),
              cell("Schedule ID", 0.1),
              cell("Cable Part No.", 0.1),
              cell("Process", 0.1),
              cell("Cut Length(mm)", 0.1),
              cell("Color", 0.1),
              cell("Scheduled Qty", 0.1),
              cell("Schedule", 0.1)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDataRow({required Schedule schedule, required int c}) {
    double width = MediaQuery.of(context).size.width;

    Widget cell(String name, double d) {
      return Container(
        width: width * d,
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 20,
      color: Colors.grey[100],
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
            color: schedule.scheduledStatus == "Complete"
                ? Colors.green
                : schedule.scheduledStatus == "Pending"
                    ? Colors.red
                    : Colors.green,
            width: 5,
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // orderId
            cell("${schedule.orderId}", 0.1),
            //Fg Part
            cell("${schedule.finishedGoodsNumber}", 0.1),
            //Schudule ID
            cell("${schedule.scheduledId}", 0.1),

            //Cable Part
            cell("${schedule.cablePartNumber}", 0.1),
            //Process
            cell("${schedule.process}", 0.1),
            // Cut length
            cell("${schedule.length}", 0.1),
            //Color
            cell("${schedule.color}", 0.1),
            //Scheduled Qty
            cell("${schedule.scheduledQuantity}", 0.1),
            //Schudule
            Container(
              width: width * 0.1,
              child: Center(
                child: Text(
                  "11:00 - 12:00",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fgDetails() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
          future: apiService.getFgDetails(widget.schedule.finishedGoodsNumber),
          builder: (context, snapshot) {
            print('fg number ${widget.schedule.finishedGoodsNumber}');
            if (snapshot.hasData) {
              FgDetails? fgDetail = snapshot.data as FgDetails?;
              return Container(
                decoration: BoxDecoration(),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          boxes(
                              "FG Description", fgDetail!.fgDescription ?? ''),
                          boxes("FG Scheduled", fgDetail.fgScheduleDate ?? ''),
                          boxes("Customer", fgDetail.customer ?? ''),
                          boxes("Drg Rev", fgDetail.drgRev ?? ''),
                          boxes("Cable #", "${fgDetail.cableSerialNo ?? ''}"),
                          boxes('Tolerance ',
                              '± ${fgDetail.tolrance} / ±${fgDetail.tolrance}'),
                        ])),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget boxes(
    String str1,
    String str2,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            str1,
            style: TextStyle(fontSize: 10),
          ),
          Text(str2,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Colors.black)),
        ]),
      ),
    );
  }

  //tearmial A b and cable
  Widget startProcess() {
    return _chosenValue == null || !items.contains(widget.schedule.process)
        ? Container(
            child: DropdownButton<String>(
              elevation: 0,
              disabledHint: Icon(Icons.close),
              dropdownColor: Colors.white,
              focusColor: Colors.white,
              value: _chosenValue,
              underline: Container(),
              //elevation: 5,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.red,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 30,
                            width: 130,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/image/$value.png"))),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              hint: Text(
                'Select Process Type',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: fonts.openSans,
                    fontWeight: FontWeight.bold),
              ),
              onChanged: (value) {
                setState(() {
                  _chosenValue = value;
                  if (value == "Crimp From, Cutlength, Crimp To") {
                    method = 'a-b-c';
                  }
                  if (value == "Crimp From, Cutlength") {
                    method = 'a-c';
                  }
                  if (value == "Cutlength, Crimp To") {
                    method = 'b-c';
                  }
                  if (value == "Cutlength & both Side Stripping") {
                    method = 'c';
                  }
                  if (value == "CRIMP-FROM") {
                    method = 'a';
                  }
                  if (value == "CRIMP-TO") {
                    method = 'b';
                  }
                });
              },
            ),
          )
        : Container(
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$_chosenValue",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 6,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 30,
                    width: 130,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/image/$_chosenValue.png"))),
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> machineDetail(
      {required BuildContext context,
      required MachineDetails machineDetails}) async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {},
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Container(
                child: Row(
              children: [
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text("Machine Detail",
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Machine Id : ',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 16)),
                          ),
                          Text(
                            '${machineDetails.machineNumber}',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Printer Id : ',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                          Text(
                            '${machineDetails.printerIp}',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Machine Location :',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                          Text(
                            " ${machineDetails.machineLocation}",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text("", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Model Name : ',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 16)),
                          ),
                          Text(
                            '${machineDetails.modelName}',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
  }
}
