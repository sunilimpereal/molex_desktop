import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/Transfer/bundleToBin_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/screens/widgets/showBundles.dart';
import 'package:molex_desktop/service/api_service.dart';

class ReMapBin extends StatefulWidget {
  String? userId;
  MachineDetails machine;
  ReMapBin({this.userId, required this.machine});

  @override
  _ReMapBinState createState() => _ReMapBinState();
}

class _ReMapBinState extends State<ReMapBin> {
  TextEditingController binIdController = new TextEditingController();
  TextEditingController bundleIdController = new TextEditingController();
  FocusNode _binFocus = new FocusNode();
  TextEditingController _binController = new TextEditingController();
  String? binId;
  TextEditingController _bundleController = new TextEditingController();
  FocusNode _bundleFocus = new FocusNode();

  String? bundleId;
  List<BundleTransferToBin> transferList = [];

  ApiService apiService = new ApiService();
  @override
  void initState() {
    apiService = new ApiService();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _bundleFocus.requestFocus();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              bundle(),
              bin(),
              confirmTransfer(),
            ]),
          ),
          Container(child: SingleChildScrollView(child: dataTable())),
        ],
      ),
    );
  }

  Widget bundle() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
            mainAxisSize: MainAxisSize.min,
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
                          focusNode: _bundleFocus,
                          autofocus: true,
                          controller: _bundleController,
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                          onSubmitted: (value) {},
                          onChanged: (value) {
                            setState(() {
                              bundleId = value;
                            });
                          },
                          style: TextStyle(
                              fontFamily: fonts.openSans, fontSize: 18),
                          decoration: new InputDecoration(
                              suffix: _bundleController.text.length > 1
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _bundleController.clear();
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
                                  vertical: 20, horizontal: 5.0))),
                    ),
                  ),
                ),
              
            ]),
      ),
    );
  }

  Widget bin() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          style: TextStyle(
                              fontFamily: fonts.openSans, fontSize: 18),
                          focusNode: _binFocus,
                          controller: _binController,
                          onTap: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              _binController.clear();
                              binId = null;
                            });
                          },
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
                                  vertical: 25, horizontal: 5.0))),
                    ),
                  ),
                ),
             
            ]),
      ),
    );
  }

  Widget dataTable() {
    int a = 1;

    return CustomTable(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.6,
      colums: [
        CustomCell(
          width: 40,
          child: Text('No.',
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      fontFamily: fonts.openSans,
                      fontSize: 16,
                      fontWeight: FontWeight.w600))),
        ),

        CustomCell(
          width: 130,
          child: Text('Location ID',
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      fontFamily: fonts.openSans,
                      fontSize: 16,
                      fontWeight: FontWeight.w600))),
        ),
        CustomCell(
          width: 100,
          child: Text('Bin ID',
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      fontFamily: fonts.openSans,
                      fontSize: 16,
                      fontWeight: FontWeight.w600))),
        ),
        CustomCell(
          width: 100,
          child: Text('Bundle ID',
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      fontFamily: fonts.openSans,
                      fontSize: 16,
                      fontWeight: FontWeight.w600))),
        ),
        // DataColumn(
        //   label: Text('Remove',
        //       style: GoogleFonts.openSans(
        //           textStyle: TextStyle(fontWeight: FontWeight.w600))),
        // ),
      ],
      rows: transferList
          .map(
            (e) => CustomRow(cells: [
              CustomCell(
                  width: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${a++}",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontFamily: fonts.openSans, fontSize: 16))),
                  )),
              CustomCell(
                  width: 130,
                  child: Text("${e.locationId}",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontFamily: fonts.openSans, fontSize: 16)))),
              CustomCell(
                  width: 100,
                  child: Text("${e.binId}",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontFamily: fonts.openSans, fontSize: 16)))),
              CustomCell(
                  width: 100,
                  child: Text("${e.bundleIdentification}",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontFamily: fonts.openSans, fontSize: 16)))),
              // DataCell(
              //   IconButton(
              //     icon: Icon(
              //       Icons.delete,
              //       color: Colors.red,
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         transferList.remove(e);
              //       });
              //     },
              //   ),
              // ),
            ]),
          )
          .toList(),
    );

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
    //               label: Text('Location ID',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Bin ID',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             DataColumn(
    //               label: Text('Bundle ID',
    //                   style: GoogleFonts.openSans(
    //                       textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             ),
    //             // DataColumn(
    //             //   label: Text('Remove',
    //             //       style: GoogleFonts.openSans(
    //             //           textStyle: TextStyle(fontWeight: FontWeight.w600))),
    //             // ),
    //           ],
    //           rows: transferList
    //               .map(
    //                 (e) => DataRow(cells: <DataCell>[
    //                   DataCell(Text("${a++}",
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text("${e.locationId}",
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text("${e.binId}",
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   DataCell(Text("${e.bundleIdentification}",
    //                       style: GoogleFonts.openSans(textStyle: TextStyle()))),
    //                   // DataCell(
    //                   //   IconButton(
    //                   //     icon: Icon(
    //                   //       Icons.delete,
    //                   //       color: Colors.red,
    //                   //     ),
    //                   //     onPressed: () {
    //                   //       setState(() {
    //                   //         transferList.remove(e);
    //                   //       });
    //                   //     },
    //                   //   ),
    //                   // ),
    //                 ]),
    //               )
    //               .toList()),
    //     ));
  }

  Widget confirmTransfer() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 60,
        width: 380,
        child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.green))),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.green.shade200;
                  return Colors.green.shade400; // Use the component's default.
                },
              ),
            ),
            onPressed: () {
              if (_bundleController.text.length > 0) {
                if (_bundleController.text == getpostBundletoBin().bundleId) {
                  apiService.postTransferBundletoBin(transferBundleToBin: [
                    getpostBundletoBin()
                  ]).then((value) {
                    if (value != null) {
                      BundleTransferToBin bundleTransferToBinTracking =
                          value[0];
                      AlertController.show(
                        "Transfered Bundle",
                        "${bundleTransferToBinTracking.bundleIdentification} to Bin- ${_binController.text}",
                        TypeAlert.success,
                      );

                      setState(() {
                        transferList.add(bundleTransferToBinTracking);
                        _binController.clear();
                        _bundleController.clear();
                      });
                    } else {
                      AlertController.show(
                        "Unable to transfer Bundle to Bin",
                        "Trandfer Failed",
                        TypeAlert.error,
                      );
                    }
                  });
                } else {
                  AlertController.show(
                    "Wrong Bundle Id",
                    "Trandfer Failed",
                    TypeAlert.error,
                  );
                }
              } else {
                AlertController.show(
                  "Bundle Not Scanned",
                  "Trandfer Failed",
                  TypeAlert.error,
                );
              }
            },
            child: Text('Transfer',style: TextStyle(fontSize: 18,fontFamily: fonts.openSans),)),
      ),
    );
  }

  TransferBundleToBin getpostBundletoBin() {
    TransferBundleToBin bundleToBin = TransferBundleToBin(
      binIdentification: _binController.text,
      bundleId: _bundleController.text,
      userId: widget.userId ?? '',
    );
    return bundleToBin;
  }


}
