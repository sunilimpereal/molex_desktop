import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/model_api/Transfer/binToLocation_model.dart';
import 'package:molex_desktop/model_api/Transfer/getBinDetail.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/screens/widgets/showBundles.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/api_service.dart';

import '../../main.dart';
import 'Homepage.dart';
import 'ReBinMap.dart';

enum LocationType {
  finaTtransfer,
  partialTransfer,
}

class Location extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  String type;
  LocationType locationType;
  Location(
      {required this.employee,
      required this.machine,
      required this.type,
      required this.locationType});
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _binController = new TextEditingController();
  FocusNode _binFocus = new FocusNode();
  FocusNode _locationFocus = new FocusNode();
  List<TransferBinToLocation> transferList = [];

  late String locationId;
  late String binId;
  bool hasLocation = false;
  ApiService apiService = new ApiService();

  late TabController _controller;

  bool loadingtransfer = false;
  @override
  void initState() {
    apiService = new ApiService();
    _controller = new TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
    SystemChrome.setEnabledSystemUIOverlays([]);
    _locationFocus.requestFocus();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  bool completeLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey1,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.red,
            ),
            title: Text(
              'Transfer',
              style:
                  GoogleFonts.openSans(textStyle: TextStyle(color: Colors.red)),
            ),
            elevation: 2,
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
                            color: Colors.grey.shade100,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
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
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                            ],
                          )),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
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
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        fontSize: 13, color: Colors.black)),
                              ),
                            ],
                          )),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              TimeDisplay(),
            ],
            bottom: TabBar(
              controller: _controller,
              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  child: Text("Bin Map",
                      style: TextStyle(
                          fontFamily: fonts.openSans,
                          fontSize: 18,
                          color: Colors.red)),
                ),
                Tab(
                  child: Text("Location Map",
                      style: TextStyle(
                          fontFamily: fonts.openSans,
                          fontSize: 18,
                          color: Colors.red)),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
          floatingActionButton: completeTransfer(),
          body: TabBarView(
            controller: _controller,
            children: [
              ReMapBin(
                userId: widget.employee.empId,
                machine: widget.machine,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              location(),
                              bin(),
                              confirmTransfer(),
                              // completeTransfer(),
                            ]),
                      ),
                      Container(
                          child: SingleChildScrollView(child: dataTable())),
                    ]),
              ),
            ],
          )),
    );
  }

  Widget location() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 400,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:  TextField(
                            focusNode: _locationFocus,
                            autofocus: true,
                            controller: _locationController,
                            onTap: () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            },
                            onSubmitted: (value) {},
                            onChanged: (value) {
                              setState(() {
                                locationId = value;
                              });
                            },
                            style: TextStyle(
                                fontFamily: fonts.openSans, fontSize: 20),
                            decoration: new InputDecoration(
                                suffix: _locationController.text.length > 1
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _locationController.clear();
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
                                labelText: 'Scan Location',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 5.0))),
                      ),
                    ),
                  ),
               
              ],
            ),
          ]),
    );
  }

  Widget confirmTransfer() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.20,
        child: loadingtransfer
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.greenAccent,
              ))
            : ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.green),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.green.shade200;
                      return Colors
                          .green.shade400; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () {
                  setState(() {
                    loadingtransfer = true;
                  });

                  ApiService apiService = new ApiService();
                  apiService.getBundlesinBin(binId).then((value) {
                    log("bin1s $value");
                    if (value != null) {
                      setState(() {
                        loadingtransfer = false;
                      });
                      List<BundleDetail> bundleist = value;
                      log("bin1s $bundleist");
                      if (bundleist.length > 0) {
                        for (BundleDetail bundle in value) {
                          if (!transferList
                              .map((e) => e.bundleId)
                              .toList()
                              .contains(bundle.bundleIdentification)) {
                            setState(() {
                              transferList.add(TransferBinToLocation(
                                  userId: widget.employee.empId,
                                  binIdentification: binId,
                                  bundleId: bundle.bundleIdentification,
                                  locationId: locationId));
                            });
                          } else {
                            setState(() {
                              loadingtransfer = false;
                            });
                            AlertController.show(
                              "Bin already Present",
                              "",
                              TypeAlert.error,
                            );
                          }
                        }
                        setState(() {
                          _binController.clear();
                          binId = "";
                        });
                      } else {
                        AlertController.show(
                          "No bundles Found in BIN",
                          "",
                          TypeAlert.error,
                        );
                      }
                    } else {
                      AlertController.show(
                        "Invalid Bin Id",
                        "",
                        TypeAlert.error,
                      );
                    }
                  });
                  setState(() {
                    loadingtransfer = false;
                  });

                  // setState(() {
                  //   _binController.clear();
                  //   binId = null;
                  // });
                },
                child: Text(
                  'Transfer',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: fonts.openSans,
                      color: Colors.white),
                )),
      ),
    );
  }

  Widget completeTransfer() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return transferList.length > 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.20,
                child: completeLoading
                    ? ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green.shade200;
                              return Colors
                                  .green.shade500; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          _controller.index == 0
                              ? _controller.animateTo(1)
                              : postCompleteTransfer();
                          // postCompleteTransfer();
                          // _showConfirmationDialog();
                        },
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ))
                    : ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green.shade200;
                              return Colors.green
                                ..shade500; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          _controller.index == 0
                              ? _controller.animateTo(1)
                              : postCompleteTransfer();
                          // _showConfirmationDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Complete Transfer',style: TextStyle(
                            fontSize: 18,
                            fontFamily:fonts.openSans
                          ),),
                        )),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.23,
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.red.shade200;
                        return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    _controller.index == 0
                        ? _controller.animateTo(1)
                        : postCompleteTransfer();
                    // _showConfirmationDialog();
                  },
                  child: Text(
                    'Complete Transfer',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          );
  }

  Widget bin() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: 400,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                          focusNode: _binFocus,
                          controller: _binController,
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              _binController.clear();
                              binId = "";
                            });
                          },
                          style: TextStyle(
                              fontFamily: fonts.openSans, fontSize: 20),
                          onSubmitted: (value) {},
                          onChanged: (value) {
                            setState(() {
                              binId = value;
                            });
                          },
                          decoration: new InputDecoration(
                              suffix: _binController.text.length > 1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _binController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red))
                                  : Container(
                                      height: 1,
                                      width: 1,
                                    ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.redAccent, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 2.0),
                              ),
                              labelText: 'Scan bin',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 5.0))),
                    ),
                  ),
                ),
              
            ],
          ),
        ]),
      ),
    );
  }

  Widget dataTable() {
    int a = 1;

    return CustomTable(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.67,
        colums: [
          CustomCell(
            width: 100,
            child: Text('No.',
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(fontWeight: FontWeight.w600))),
          ),
          CustomCell(
            width: 130,
            child: Text('Location ID',
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(fontWeight: FontWeight.w600 ,fontSize: 18,
                          fontFamily: fonts.openSans,))),
          ),
          CustomCell(
            width: 100,
            child: Text('Bin ID',
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,
                          fontFamily: fonts.openSans,))),
          ),
          CustomCell(
            width: 100,
            child: Text('Bundles',
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(fontWeight: FontWeight.w600 ,fontSize: 18,
                          fontFamily: fonts.openSans,))),
          ),
          CustomCell(
            width: 100,
            child: Text('Remove',
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,
                          fontFamily: fonts.openSans,))),
          ),
        ],
        rows: transferList
            .map(
              (e) => CustomRow(cells: [
                CustomCell(
                    width: 100,
                    child: Text("${a++}",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: fonts.openSans,
                        )))),
                CustomCell(
                    width: 130,
                    child: Text(e.locationId ?? '',
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: fonts.openSans,
                        )))),
                CustomCell(
                    width: 100,
                    child: Text(e.binIdentification ?? '',
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: fonts.openSans,
                        )))),
                CustomCell(
                    width: 100,
                    child: Text(e.bundleId ?? '',
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: fonts.openSans,
                        )))),
                CustomCell(
                  width: 100,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        transferList.remove(e);
                      });
                    },
                  ),
                ),
              ]),
            )
            .toList());

    // return Container(
    //     height: MediaQuery.of(context).size.height,
    //     child: SingleChildScrollView(
    //       child: DataTable(
    //           columnSpacing: 40,
    //           columns: <DataColumn>[
    //             DataColumn(
    //               label: Text('No.',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Location Id',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Bin Id',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Bundles',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Remove',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //           ],
    //           rows: transferList
    //               .map(
    //                 (e) => DataRow(cells: <DataCell>[
    //                   DataCell(Text("${a++}",
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text(e.locationId ?? '',
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text(e.binIdentification ?? '',
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text(e.bundleId ?? '',
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(
    //                     IconButton(
    //                       icon: Icon(
    //                         Icons.delete,
    //                         color: Colors.red,
    //                       ),
    //                       onPressed: () {
    //                         setState(() {
    //                           transferList.remove(e);
    //                         });
    //                       },
    //                     ),
    //                   ),
    //                 ]),
    //               )
    //               .toList()),
    //     ));
  }

  void addBundles(
      String locationId, String binId, List<BundleDetail> bundleList) {}

  Future<void> _showConfirmationDialog() async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Center(child: Text('Confirm Transfer of BIN\'s')),
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
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      },
                    );
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.green),
                  ),
                  onPressed: () {
                    ApiService apiService = new ApiService();

                    Future.delayed(
                      const Duration(milliseconds: 50),
                      () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      },
                    );
                    apiService
                        .postTransferBinToLocation(transferList)
                        .then((value) {
                      print("inside: ${widget.type}");
                      if (value != null) {
                        if (widget.type == 'process') {
                          apiService
                              .getmachinedetails(widget.machine.machineNumber)
                              .then((value) {
                            // Navigator.pop(context);
                            MachineDetails machineDetails = value![0];
                            AlertController.show(
                              "${widget.machine.machineNumber}",
                              "",
                              TypeAlert.success,
                            );

                            print("machineID:${widget.machine.machineNumber}");
                            switch (machineDetails.category) {
                              case "Manual Cutting":
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage(
                                            employee: widget.employee,
                                            machine: machineDetails,
                                          )),
                                );
                                break;
                              case "Automatic Cut & Crimp":
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage(
                                            employee: widget.employee,
                                            machine: machineDetails,
                                          )),
                                );
                                break;
                              case "Semi Automatic Strip and Crimp machine":
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage(
                                            employee: widget.employee,
                                            machine: machineDetails,
                                          )),
                                );
                                break;
                              case "Automatic Cutting":
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage(
                                            employee: widget.employee,
                                            machine: machineDetails,
                                          )),
                                );
                                break;
                              default:
                                AlertController.show(
                                  "Machine not Found",
                                  "",
                                  TypeAlert.error,
                                );
                            }
                          });
                        }
                      } else {
                        AlertController.show(
                          "Transfer Failed",
                          "",
                          TypeAlert.error,
                        );
                      }
                    });
                  },
                  child: Text('Confirm')),
            ],
          ),
        );
      },
    );
  }

  postCompleteTransfer() {
    ApiService apiService = new ApiService();
    setState(() {
      completeLoading = true;
    });
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    apiService.postTransferBinToLocation(transferList).then((value) {
      print("inside: ${widget.type}");
      if (value != null) {
        if (widget.locationType == LocationType.partialTransfer) {
          Navigator.pop(context);
          return 0;
        }
        setState(() {
          completeLoading = false;
        });

        if (widget.type == 'process') {
          apiService
              .getmachinedetails(widget.machine.machineNumber)
              .then((value) {
            // Navigator.pop(context);
            MachineDetails machineDetails = value![0];
            AlertController.show(
              "${widget.machine.machineNumber}",
              "",
              TypeAlert.success,
            );

            print("machineID:${widget.machine.machineNumber}");
            switch (machineDetails.category) {
              case "Manual Cutting":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              case "Automatic Cut & Crimp":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              case "Semi Automatic Strip and Crimp machine":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              case "Automatic Cutting":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                            employee: widget.employee,
                            machine: machineDetails,
                          )),
                );
                break;
              default:
                AlertController.show(
                  "Machine not Found",
                  "",
                  TypeAlert.error,
                );
            }
          });
        }
      } else {
        // Fluttertoast.showToast(
        //   "Transfer Failed",
        //
        //
        //
        //
        //
        //   fontSize: 16.0,
        // );
      }
    });
  }

  skipTransfer() {
    if (widget.locationType == LocationType.partialTransfer) {
      Navigator.pop(context);
      return 0;
    }

    if (widget.type == 'process') {
      apiService.getmachinedetails(widget.machine.machineNumber).then((value) {
        // Navigator.pop(context);
        MachineDetails machineDetails = value![0];
        AlertController.show(
          "${widget.machine.machineNumber}",
          "",
          TypeAlert.success,
        );

        print("machineID:${widget.machine.machineNumber}");
        switch (machineDetails.category) {
          case "Manual Cutting":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          case "Automatic Cut & Crimp":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          case "Semi Automatic Strip and Crimp machine":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          case "Automatic Cutting":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                        employee: widget.employee,
                        machine: machineDetails,
                      )),
            );
            break;
          default:
            AlertController.show(
              "Machine not Found",
              "",
              TypeAlert.error,
            );
        }
      });
    }
  }
}
