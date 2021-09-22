import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/model_api/postrawmatList_model.dart';
import 'package:molex_desktop/model_api/rawMaterial_modal.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/models/materialItem.dart';
import 'package:molex_desktop/screens/operator/process/process.dart';
import 'package:molex_desktop/screens/widgets/loading_button.dart';
import 'package:molex_desktop/screens/widgets/time.dart';

import 'package:flutter_osk/flutter_osk.dart';
import 'package:molex_desktop/service/api_service.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

enum MaterialPickType {
  newload,
  reload,
}

class MaterialPick extends StatefulWidget {
  @required
  final Schedule schedule;
  @required
  final Employee employee;
  @required
  final MachineDetails machine;
  @required
  final MaterialPickType materialPickType;
  Function reload;
  MaterialPick(
      {required this.employee,
      required this.machine,
      required this.schedule,
      required this.materialPickType,
      required this.reload});
  @override
  _MaterialPickState createState() => _MaterialPickState();
}

class _MaterialPickState extends State<MaterialPick> {
  TextEditingController _partNumberController = new TextEditingController();
  TextEditingController _trackingNumberController = new TextEditingController();
  TextEditingController _qtyFocusController = new TextEditingController();
  TextEditingController mainController = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  FocusNode _trackingNumber = new FocusNode();
  FocusNode _qtyFocus = new FocusNode();
  FocusNode keyboardfocus = new FocusNode();
  // late String? partNumber;
  // late String? trackingNumber="";
  // late String? qty;
  List<ItemPart> items = [];
  List<ItemPart> selectditems = [];
  List<PostRawMaterial> selectdItems = [];
  List<RawMaterial> rawMaterial = [];
  bool isCollapsedRawMaterial = false;
  bool isCollapsedScannedMaterial = false;
  DateTime selectedDate = DateTime.now();
  late ApiService apiService;
  bool keyBoard = true;
  late List<RawMaterial> rawmaterial1;
  bool nextPageLoading = false;

  bool shiftEnabled = false;

  Future<List<RawMaterial>> getRawmaterialFut(List<RawMaterial> rawMat) async {
    return rawMat;
  }

  Future<List<MaterialDetail>> getmatTrkDetail(
      List<MaterialDetail> mattrack) async {
    return mattrack;
  }

  @override
  void initState() {
    _qtyFocus = new FocusNode();
    initializeDateFormatting('az');

    apiService = new ApiService();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _textNode.requestFocus();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(
      const Duration(milliseconds: 100),
      () {},
    );
    super.initState();
  }

  triggerCollapseRawMaterial() {
    setState(() {
      isCollapsedRawMaterial = !isCollapsedRawMaterial;
    });
  }

  triggerCollapseScannedMaterial() {
    setState(() {
      isCollapsedScannedMaterial = !isCollapsedScannedMaterial;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('true1 _qty focus has A focus ${_qtyFocus.hasFocus} ');
    print('true1 keyboard  has focus ${keyBoard} ');

    if (!_qtyFocus.hasFocus && !keyBoard) {
      print('true has focus ${_qtyFocus.hasFocus} ');
    }
    print("key $keyBoard");
    if (!keyBoard) {
      if (!_qtyFocus.hasFocus) {}
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          title: const Text(
            'Raw Material Loading',
            style: TextStyle(color: Colors.red),
          ),
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
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        )),
                      ),
                      Container(
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
                    ],
                  )
                ],
              ),
            ),

            TimeDisplay(),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
         
              SingleChildScrollView(
                child: Column(
                  children: [
                    
                    //Shift and machineId
                    Divider(
                      color: Colors.redAccent,
                      thickness: 2,
                    ),
                    scheduleDetail(schedule: widget.schedule),

                    //Raw material
                    buildDataRawMaterial(),
                    widget.materialPickType == MaterialPickType.newload
                        ? scannerInput()
                        : scannerInputreload(),
                    //Selected material
                    showSelectedRawMaterial(),

                    //Proceed to Process Button
                    Container(
                      height: 100,
                    ),
                  ],
                ),
              ),
              // Wrap the keyboard with Container to set background color.
             keyBoard? Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 350,
                          width: MediaQuery.of(context).size.width * 0.7,
                          // Keyboard is transparent
                          color: Colors.grey,
                          child: VirtualKeyboard(
                              // Default height is 300
                              height: 350,
                              // Default is black
                              textColor: Colors.white,
                              // Default 14
                              fontSize: 20,
                              // [A-Z, 0-9]
                              type: VirtualKeyboardType.Alphanumeric,

                              // Callback for key press event

                              onKeyPress: _onKeyPress),
                        ),
                      ],
                    ),
                  ),
                ),
              ):Container()
            ],
          ),
        ));
  }

  // Just local variable. Use Text widget or similar to show in UI.
  late String text;

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      mainController.text = mainController.text + (shiftEnabled ? key.capsText : key.text);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (mainController.text.length == 0) return;
          mainController.text = mainController.text.substring(0, mainController.text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          mainController.text = mainController.text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          mainController.text = mainController.text + key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
// Update the screen
    setState(() {});
  }

  Widget scannerInputreload() {
    double width = MediaQuery.of(context).size.width * 0.79;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        shadowColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Container(
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Part Number
 Container(
                          height: 40,
                          width: width * 0.25,
                          child: TextField(
                             showCursor: false,
                            textInputAction: TextInputAction.newline,
                            controller: _partNumberController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 16),
                            autofocus: true,
                            onSubmitted: (value) {
                              for (RawMaterial ip in rawMaterial) {
                                if (ip.partNunber.toString() == value) {
                                  if (!rawMaterial.contains(ip)) {
                                    _trackingNumber.requestFocus();
                                  }
                                }
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                // partNumber = value;
                              });
                            },
                            onTap: () {
                              setState(() {
                                mainController = _partNumberController;
                              });
                            },
                            decoration: new InputDecoration(
                              suffix: _partNumberController.text.length > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _partNumberController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red))
                                  : Container(),
                              labelText: "Part No.",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          )),
                    
                    // Tracking Number
                    Container(
                          height: 40,
                          width: width * 0.25,
                          child: TextField(
                            showCursor: false,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _trackingNumberController,
                            onSubmitted: (value) async {
                              // trackingNumber = value;
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate, // Refer step 1
                                  firstDate: DateTime(2000),
                                  // lastDate: DateTime.now().add(Duration(days:1)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 0)));
                              if (picked != null && picked != selectedDate)
                                setState(() {
                                  selectedDate = picked;
                                });
                              _qtyFocus.requestFocus();
                            },
                            onTap: () {
                              setState(() {
                                mainController= _trackingNumberController;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                // trackingNumber = value;
                              });
                            },
                            focusNode: _trackingNumber,
                            decoration: new InputDecoration(
                              suffix: _trackingNumberController.text.length > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _trackingNumberController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red))
                                  : Container(),
                              labelText: "Tracebility Number",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          )),
                  
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            WindowsOSK.show();
                            keyBoard = !keyBoard;
                          });
                        },
                        child: Icon(
                          Icons.keyboard,
                          color: keyBoard ? Colors.green : Colors.grey,
                          size: 35,
                        )),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate, // Refer step 1
                            firstDate: DateTime(2000),
                            // lastDate: DateTime.now().add(Duration(days:1)),
                            lastDate: DateTime.now().add(Duration(days: 0)));
                        if (picked != null && picked != selectedDate)
                          setState(() {
                            selectedDate = picked;
                          });
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: Colors.grey,
                              size: 25,
                            ),
                            Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 40,
                        width: width * 0.15,
                        child: TextField(
                           showCursor: false,
                          controller: _qtyFocusController,
                          onTap: () {
                            setState(() {
                              mainController = _qtyFocusController;
                            });
                          },
                          autofocus: true,
                          focusNode: _qtyFocus,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              // qty = value;
                            });
                          },
                          decoration: new InputDecoration(
                            labelText: "Qty",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                   
                    Container(
                      height: 45,
                      width: width * 0.12,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            primary: Colors.blue, // background
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            print('rawmaterial = $rawMaterial');
                            setState(() {
                              if (rawMaterial
                                  .map((e) => e.partNunber)
                                  .toList()
                                  .contains(_partNumberController.text)) {
                                for (RawMaterial ip in rawMaterial) {
                                  if (ip.partNunber == _partNumberController.text) {
                                    if (!selectdItems.contains(ip)) {
                                      print('loop ${ip.partNunber.toString()}');
                                      PostRawMaterial postRawmaterial =
                                          new PostRawMaterial(
                                              partDescription: ip.description,
                                              existingQuantity: 0,
                                              schedulerIdentification:
                                                  widget.schedule.scheduledId,
                                              date: DateFormat("dd-MM-yyyy")
                                                  .format(selectedDate), //ODO
                                              machineIdentification:
                                                  widget.machine.machineNumber,
                                              finishedGoodsNumber: int.parse(
                                                  widget.schedule
                                                      .finishedGoodsNumber),
                                              orderidentification: int.parse(
                                                  widget.schedule.orderId),
                                              partNumber:
                                                  int.parse("${ip.partNunber}"),
                                              requiredQuantityOrPiece:
                                                  double.parse(
                                                      "${ip.requireQuantity}"),
                                              totalScheduledQuantity: double.parse(
                                                  "${ip.toatalScheduleQuantity}"),
                                              unitOfMeasurement: ip.uom,
                                              traceabilityNumber:
                                                  _trackingNumberController.text,
                                              scannedQuantity:
                                                  double.parse("${_qtyFocusController.text}"),
                                              cablePartNumber:
                                                  int.parse(widget.schedule.cablePartNumber),
                                              length: int.parse(widget.schedule.length),
                                              color: widget.schedule.color,
                                              process: widget.schedule.process,
                                              status: 'SUCCESS');
                                      selectdItems.add(postRawmaterial);
                                      _partNumberController.clear();
                                      _trackingNumberController.clear();
                                      _qtyFocusController.clear();
                                      // partNumber = null;
                                      // trackingNumber = null;
                                      // qty = null;
                                      _textNode.requestFocus();
                                    }
                                  } else {}
                                }
                              } else {
                                AlertController.show(
                                  "Part No. not present in reqired raw material",
                                  "",
                                  TypeAlert.error,
                                );
                              }
                            });
                          },
                          child: Text('Add')),
                    ),
                  ],
                ),
              ),
              Container(
                height: 45,
                width: width * 0.22,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    primary: Colors.green, // background
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    log("${postRawMaterialListToJson(selectdItems)}");
                    // if (setEquals(rawPartNo.toSet(), scannedPartNo.toSet())) {
                    MatTrkPostDetail matTrkPostDetail = new MatTrkPostDetail(
                      machineId: widget.machine.machineNumber,
                      schedulerId: widget.schedule.scheduledId,
                      cablePartNumbers: rawMaterial
                          .map((e) => e.partNunber.toString())
                          .toList(),
                    );
                    apiService.postRawmaterial(selectdItems).then((value) {
                      if (value) {
                        widget.reload(matTrkPostDetail);
                        widget.materialPickType == MaterialPickType.newload
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProcessPage(
                                          schedule: widget.schedule,
                                          employee: widget.employee,
                                          machine: widget.machine,
                                          matTrkPostDetail: matTrkPostDetail,
                                          rightside: '',
                                        )),
                              )
                            : Navigator.pop(context);
                      } else {
                        AlertController.show(
                          "Failed To Add Raw Material",
                          "",
                          TypeAlert.error,
                        );
                      }
                    });
                  },
                  child: Text(
                    'Continue Process',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scannerInput() {
    double width = MediaQuery.of(context).size.width * 0.79;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        shadowColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Container(
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Part Number
                    Container(
                          height: 40,
                          width: width * 0.25,
                          child: TextField(
                             showCursor: false,
                            textInputAction: TextInputAction.newline,
                            controller: _partNumberController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 16),
                            autofocus: true,
                            focusNode: _textNode,
                            onSubmitted: (value) {
                              for (RawMaterial ip in rawMaterial) {
                                if (ip.partNunber.toString() == value) {
                                  if (!rawMaterial.contains(ip)) {
                                    _trackingNumber.requestFocus();
                                    Future.delayed(
                                      const Duration(milliseconds: 100),
                                      () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                      },
                                    );
                                  }
                                }
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                // partNumber = value;
                              });
                            },
                            onTap: () {
                              setState(() {
                                mainController = _partNumberController;
                              });
                            },
                            decoration: new InputDecoration(
                              suffix: _partNumberController.text.length > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _partNumberController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red))
                                  : Container(),
                              labelText: "Part No.",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          )),
                 
                    // Tracking Number
                Container(
                          height: 45,
                          width: width * 0.25,
                          child: TextField(
                             showCursor: false,
                            keyboardType: TextInputType.visiblePassword,
                            controller: _trackingNumberController,
                            onSubmitted: (value) async {
                              // trackingNumber = value;
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate, // Refer step 1
                                  firstDate: DateTime(2000),
                                  // lastDate: DateTime.now().add(Duration(days:1)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 0)));
                              if (picked != null && picked != selectedDate)
                                setState(() {
                                  selectedDate = picked;
                                });
                              _qtyFocus.requestFocus();
                            },
                            onTap: () {
                              setState(() {
                                mainController = _trackingNumberController;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                // trackingNumber = value;
                              });
                            },
                            focusNode: _trackingNumber,
                            decoration: new InputDecoration(
                              suffix: _trackingNumberController.text.length > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _trackingNumberController.clear();
                                        });
                                      },
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.red))
                                  : Container(),
                              labelText: "Tracebility Number",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          )),
                   
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            WindowsOSK.show();
                            keyBoard = !keyBoard;
                          });
                        },
                        child: Icon(
                          Icons.keyboard,
                          color: keyBoard ? Colors.green : Colors.grey,
                          size: 35,
                        )),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate, // Refer step 1
                            firstDate: DateTime(2000),
                            // lastDate: DateTime.now().add(Duration(days:1)),
                            lastDate: DateTime.now().add(Duration(days: 0)));
                        if (picked != null && picked != selectedDate)
                          setState(() {
                            selectedDate = picked;
                            Future.delayed(
                              const Duration(milliseconds: 100),
                              () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              },
                            );
                          });
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: Colors.grey,
                              size: 25,
                            ),
                            Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 40,
                        width: width * 0.15,
                        child: TextField(
                           showCursor: false,
                          controller: _qtyFocusController,
                          onTap: () {
                            setState(() {
                              mainController = _qtyFocusController;
                            });
                          },
                          focusNode: _qtyFocus,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              // qty = value;
                            });
                          },
                          decoration: new InputDecoration(
                            labelText: "Qty",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                   
                    Container(
                      height: 45,
                      width: width * 0.12,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            primary: Colors.blue, // background
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            print('rawmaterial = $rawMaterial');
                            setState(() {
                              if (rawmaterial1
                                  .map((e) => e.partNunber)
                                  .toList()
                                  .contains(_partNumberController.text)) {
                                for (RawMaterial ip in rawMaterial) {
                                  if (ip.partNunber == _partNumberController.text) {
                                    if (!selectdItems.contains(ip)) {
                                      print('loop ${ip.partNunber.toString()}');
                                      PostRawMaterial postRawmaterial =
                                          new PostRawMaterial(
                                              partDescription: ip.description,
                                              existingQuantity: 0,
                                              schedulerIdentification:
                                                  widget.schedule.scheduledId,
                                              date: DateFormat("dd-MM-yyyy")
                                                  .format(selectedDate), //ODO
                                              machineIdentification:
                                                  widget.machine.machineNumber,
                                              finishedGoodsNumber: int.parse(
                                                  widget.schedule
                                                      .finishedGoodsNumber),
                                              orderidentification: int.parse(
                                                  widget.schedule.orderId),
                                              partNumber:
                                                  int.parse("${ip.partNunber}"),
                                              requiredQuantityOrPiece:
                                                  double.parse(
                                                      "${ip.requireQuantity}"),
                                              totalScheduledQuantity: double.parse(
                                                  "${ip.toatalScheduleQuantity}"),
                                              unitOfMeasurement: ip.uom,
                                              traceabilityNumber:
                                                  _trackingNumberController.text,
                                              scannedQuantity:
                                                  double.parse("${_qtyFocusController.text}"),
                                              cablePartNumber:
                                                  int.parse(widget.schedule.cablePartNumber),
                                              length: int.parse(widget.schedule.length),
                                              color: widget.schedule.color,
                                              process: widget.schedule.process,
                                              status: 'SUCCESS');
                                      selectdItems.add(postRawmaterial);
                                      _partNumberController.clear();
                                      _trackingNumberController.clear();
                                      _qtyFocusController.clear();
                                      // partNumber = null;
                                      // trackingNumber = null;
                                      // qty = null;
                                      _textNode.requestFocus();
                                      Future.delayed(
                                        const Duration(milliseconds: 100),
                                        () {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                        },
                                      );
                                    }
                                  } else {}
                                }
                              } else {
                                AlertController.show(
                                  "Part No. not present in reqired raw material",
                                  "",
                                  TypeAlert.error,
                                );
                                Fluttertoast.showToast(
                                    msg:
                                        "Part No. not present in reqired raw material",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            });
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontFamily: fonts.openSans,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                height: 45,
                width: width * 0.22,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    primary: Colors.green, // background
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  child: Text(
                    'Start Process',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  // to Show the raw material required
  Widget buildDataRawMaterial() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Container(
          padding: EdgeInsets.all(3),
          child: FutureBuilder(
              future: rawMaterial.length == 0
                  ? apiService.rawMaterial(
                      machineId: widget.machine.machineNumber,
                      fgNo: widget.schedule.finishedGoodsNumber,
                      type: widget.machine.category,
                      scheduleId: widget.schedule.scheduledId)
                  : getRawmaterialFut(rawMaterial),
              // 'EMU-M/C-038B', '367760913', '367870011', '1223445'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<RawMaterial> rawmaterial =
                      snapshot.data as List<RawMaterial>;
                  rawmaterial1 = snapshot.data as List<RawMaterial>;

                  rawMaterial = snapshot.data as List<RawMaterial>;
                  MatTrkPostDetail matTrkPostDetail = new MatTrkPostDetail(
                    machineId: widget.machine.machineNumber,
                    schedulerId: widget.schedule.scheduledId,
                    cablePartNumbers: rawMaterial
                        .map((e) => e.partNunber.toString())
                        .toList(),
                  );

                  return FutureBuilder(
                      future: apiService
                          .getMaterialTrackingCableDetail(matTrkPostDetail),
                      builder: (context, snapshot1) {
                        List<MaterialDetail> matDetail = [];
                        matDetail = snapshot1.data as List<MaterialDetail>;
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              children: [
                                // heading
                                SizedBox(height: 0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        triggerCollapseRawMaterial();
                                      },
                                      child: Text(
                                        'Required Raw Material',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              triggerCollapseRawMaterial();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(isCollapsedRawMaterial
                                                  ? Icons.keyboard_arrow_down
                                                  : Icons.keyboard_arrow_up),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                                // scrollView
                                (() {
                                  if (!isCollapsedRawMaterial) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(2),
                                      child: DataTable(
                                          columnSpacing: 20,
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'Part No.',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fonts.openSans),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Description',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fonts.openSans),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'UOM',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fonts.openSans),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Req. Per Unit',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fonts.openSans),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Req Schedule Unit',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fonts.openSans),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Available',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fonts.openSans),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Loaded',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: fonts.openSans),
                                              ),
                                            ),
                                          ],
                                          rows: rawmaterial
                                              .map(
                                                  (e) => DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  _partNumberController
                                                                          .text =
                                                                      "${e.partNunber}";
                                                                  // partNumber = e
                                                                  //     .partNunber;
                                                                  _qtyFocusController
                                                                          .text =
                                                                      e.toatalScheduleQuantity
                                                                          .toString();
                                                                  // qty = e
                                                                  //     .toatalScheduleQuantity
                                                                  //     .toString();
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5),
                                                                child: Text(
                                                                  e.partNunber
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          fonts
                                                                              .openSans),
                                                                ),
                                                              ),
                                                            )),
                                                            DataCell(Text(
                                                              "${e.description}",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: fonts
                                                                      .openSans),
                                                            )),
                                                            DataCell(Text(
                                                              "${e.uom}",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: fonts
                                                                      .openSans),
                                                            )),
                                                            DataCell(Text(
                                                              e.requireQuantity
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: fonts
                                                                      .openSans),
                                                            )),
                                                            DataCell(Text(
                                                              e.toatalScheduleQuantity
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: fonts
                                                                      .openSans),
                                                            )),
                                                            DataCell(Text(
                                                              matDetail?.length !=
                                                                      0
                                                                  ? matDetail
                                                                          ?.firstWhere(
                                                                              (element) => element.cablePartNo == e.partNunber,
                                                                              orElse: () => MaterialDetail(availableQty: '0'))
                                                                          ?.availableQty ??
                                                                      '0'.toString()
                                                                  : '0',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: fonts
                                                                      .openSans),
                                                            )),
                                                            DataCell(Text(
                                                              matDetail?.length !=
                                                                      0
                                                                  ? matDetail
                                                                          ?.firstWhere(
                                                                              (element) => element.cablePartNo == e.partNunber,
                                                                              orElse: () => MaterialDetail(loadedQty: '0'))
                                                                          ?.loadedQty ??
                                                                      '0'.toString()
                                                                  : '0',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily: fonts
                                                                      .openSans),
                                                            )),
                                                          ]))
                                              .toList()),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }()),
                              ],
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
  // {"finishedGoods":369100004,"purchaseorder":"846714504","orderIdentification":846714504,"cablePartNumber":884513001,"cutLength":2435,"color":"BK","scheduleIdentification":80069,"scheduledQuantity":900,"machineIdentification":"EMU-M/C-038I","operatorIdentification":"21027541","bundleIdentification":"","rejectedQuantity":0,"terminalDamage":0,"terminalBend":0,"terminalTwist":0,"conductorCurlingUpDown":0,"insulationCurlingUpDown":0,"conductorBurr":0,"windowGap":0,"crimpOnInsulation":0,"improperCrimping":0,"tabBendOrTabOpen":0,"bellMouthLessOrMore":0,"cutOffLessOrMore":0,"cutOffBurr":0,"cutOffBend":0,"insulationDamage":0,"exposureStrands":0,"strandsCut":0,"brushLengthLessorMore":0,"terminalCoppermark":0,"setupRejections":0,"terminalBackOut":0,"cableDamage":0,"crimpingPositionOutOrMissCrimp":0,"terminalSeamOpen":0,"rollerMark":0,"lengthLessOrLengthMore":0,"gripperMark":0,"endWire":0,"endTerminal":0,"entangledCable":0,"troubleShootingRejections":0,"wireOverLoadRejectionsJam":0,"halfCurling_A":0,"brushLengthLessOrMore_C":0,"exposureStrands_D":0,"cameraPositionOut_E":0,"crimpOnInsulation_F":0,"cablePositionMovement_G":0,"crimpOnInsulation_C":0,"crimpingPositionOutOrMissCrimp_D":0,"crimpPositionOut":0,"stripPositionOut":0,"offCurling":0,"cFM_PFM_Rejections":0,"incomingIssue":0,"bladeMark":0,"crossCut":0,"insulationBarrel":0,"method":"a-b-c","terminalFrom":367760188,"terminalTo":39000048,"awg":"22"}

  // To Show the scanned products with quantity
  Widget showSelectedRawMaterial() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        shadowColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Container(
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              // scannerInput(),
              //Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      triggerCollapseScannedMaterial();
                    },
                    child: Text(
                      'Scanned Materials',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            triggerCollapseScannedMaterial();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(isCollapsedScannedMaterial
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up),
                          ))

                      // IconButton(
                      //     icon: isCollapsedScannedMaterial
                      //         ? Icon(Icons.keyboard_arrow_down)
                      //         : Icon(Icons.keyboard_arrow_up),
                      //     onPressed: () {

                      //     })
                    ],
                  )
                ],
              ),

              // Table
              (() {
                if (!isCollapsedScannedMaterial) {
                  return Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4),
                    child: DataTable(
                        columnSpacing: 20,
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Part No.',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: fonts.openSans),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: fonts.openSans),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tracebility',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: fonts.openSans),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: fonts.openSans),
                            ),
                          ),
                          // DataColumn(
                          //   label: Text(
                          //     'UOM',
                          //     style: TextStyle(fontSize: 14),
                          //   ),
                          // ),
                          DataColumn(
                            label: Text(
                              'Exist Qty	',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: fonts.openSans),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Scanned Qty',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: fonts.openSans),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: fonts.openSans),
                            ),
                          ),
                        ],
                        rows: selectdItems
                            .map((e) => DataRow(cells: <DataCell>[
                                  DataCell(Text(
                                    e.partNumber.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    "${e.partDescription}",
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    e.traceabilityNumber.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    "${e.date}".split(' ')[0],
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  // DataCell(Text(e.n.toString())),
                                  DataCell(Text(e.existingQuantity.toString())),
                                  DataCell(Text(e.scannedQuantity.toString())),
                                  DataCell(IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectdItems.remove(e);
                                      });
                                    },
                                  )),
                                ]))
                            .toList()),
                  );
                } else {
                  return Container();
                }
              }())
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    Future.delayed(
      const Duration(milliseconds: 50),
      () {},
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      useRootNavigator: true,
      builder: (BuildContext context1) {
        return Center(
          child: AlertDialog(
            title: Text('Proceed to Process'),
            content: selectdItems.length > 0
                ? Container(
                    height: 0,
                  )
                : Text("no raw material is sleceted"),
            actions: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.redAccent),
                  ),
                  onPressed: () {
                    Navigator.pop(context1);
                    Future.delayed(
                      const Duration(milliseconds: 50),
                      () {},
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('       Cancel      '),
                  )),
              LoadingButton(
                loading: nextPageLoading,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.green),
                ),
                loadingChild: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('       Confirm      '),
                ),
                onPressed: () async {
                  log("${postRawMaterialListToJson(selectdItems)}");
                  // if (setEquals(rawPartNo.toSet(), scannedPartNo.toSet())) {
                  // _showConfirmationDialog();
                  MatTrkPostDetail matTrkPostDetail = new MatTrkPostDetail(
                    machineId: widget.machine.machineNumber,
                    schedulerId: widget.schedule.scheduledId,
                    selectedRawMaterial: selectdItems,
                    cablePartNumbers: rawMaterial
                        .map((e) => e.partNunber.toString())
                        .toList(),
                  );
                  apiService.postRawmaterial(selectdItems).then((value) {
                    if (value) {
                      Navigator.pop(context1);
                      widget.materialPickType == MaterialPickType.newload
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProcessPage(
                                        schedule: widget.schedule,
                                        employee: widget.employee,
                                        machine: widget.machine,
                                        matTrkPostDetail: matTrkPostDetail,
                                        rightside: '',
                                      )),
                            )
                          : Future.delayed(
                              const Duration(milliseconds: 2000),
                              () {
                                Navigator.pop(context);
                              },
                            );
                    } else {
                      Navigator.pop(context1);
                      AlertController.show(
                        "Failed To Add Raw Material",
                        "",
                        TypeAlert.error,
                      );
                      Fluttertoast.showToast(
                          msg: "Failed To Add Raw Material",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return true;
                    }
                  });
                },
              ),
              // nextPageLoading
              //     ? ElevatedButton(
              //         style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.resolveWith(
              //               (states) => Colors.green),
              //         ),
              //         onPressed: () {},
              //         child: Container(
              //           height: 25,
              //           width: 25,
              //           child: CircularProgressIndicator(
              //             valueColor:
              //                 AlwaysStoppedAnimation<Color>(Colors.white),
              //           ),
              //         ))
              //     : ElevatedButton(
              //         style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.resolveWith(
              //               (states) => Colors.green),
              //         ),
              //         onPressed: () {
              //           setState(() {
              //             nextPageLoading = true;
              //           });

              //           log(postRawMaterialListToJson(selectdItems));
              //           // if (setEquals(rawPartNo.toSet(), scannedPartNo.toSet())) {
              //           // _showConfirmationDialog();
              //           MatTrkPostDetail matTrkPostDetail =
              //               new MatTrkPostDetail(
              //             machineId: widget.machine.machineNumber,
              //             schedulerId: widget.schedule.scheduledId,
              //             cablePartNumbers: rawMaterial
              //                 .map((e) => e.partNunber.toString())
              //                 .toList(),
              //           );
              //           apiService.postRawmaterial(selectdItems).then((value) {
              //             if (value) {
              //                  Navigator.pop(context1);
              //               widget.materialPickType == MaterialPickType.newload
              //                   ? Navigator.pushReplacement(
              //                       context,
              //                       MaterialPageRoute(
              //                           builder: (context) => ProcessPage(
              //                                 schedule: widget.schedule,
              //                                 employee: widget.employee,
              //                                 machine: widget.machine,
              //                                 matTrkPostDetail:
              //                                     matTrkPostDetail,
              //                               )),
              //                     )
              //                   : Future.delayed(
              //                       const Duration(milliseconds: 2000),
              //                       () {
              //                         Navigator.pop(context);
              //                       },
              //                     );
              //             } else {
              //               setState(() {
              //                 nextPageLoading = false;
              //               });
              //                  Navigator.pop(context1);
              //               Fluttertoast.showToast(
              //                   msg: "Failed To Add Raw Material",
              //                   toastLength: Toast.LENGTH_SHORT,
              //                   gravity: ToastGravity.BOTTOM,
              //                   timeInSecForIosWeb: 1,
              //                   backgroundColor: Colors.red,
              //                   textColor: Colors.white,
              //                   fontSize: 16.0);
              //             }
              //           });
              //         },
              //         child: Text('       Confirm      ')),
            ],
          ),
        );
      },
    );
  }

  Widget scheduleDetail({required Schedule schedule, int? c}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        shadowColor: Colors.white,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tableHeading(),
              buildDataRow(schedule: widget.schedule),
            ],
          ),
        ),
      ),
    );
  }

  Widget tableHeading() {
    double width = MediaQuery.of(context).size.width;
    Widget cell(String name, double d) {
      return Container(
        width: width * d,
        height: 15,
        child: Center(
          child: Text(
            name,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
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
              cell("Process", 0.12),
              cell("Cut Length(mm)", 0.1),
              cell("Color", 0.1),
              cell("Scheduled Qty", 0.1),
              cell("Date", 0.1)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDataRow({required Schedule schedule, int? c}) {
    double width = MediaQuery.of(context).size.width;

    Widget cell(String name, double d) {
      return Container(
        width: width * d,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 20,
      color: Colors.white,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // orderId
            cell(schedule.orderId, 0.1),
            //Fg Part
            cell(schedule.finishedGoodsNumber, 0.1),
            //Schudule ID
            cell(schedule.scheduledId, 0.1),

            //Cable Part
            cell(schedule.cablePartNumber, 0.1),
            //Process
            cell(schedule.process, 0.12),
            // Cut length
            cell(schedule.length, 0.1),
            //Color
            cell(schedule.color, 0.1),
            //Scheduled Qty
            cell(schedule.scheduledQuantity, 0.1),
            //Schudule
            Container(
              width: width * 0.1,
              child: Center(
                child: Text(
                  schedule.currentDate == null
                      ? ""
                      : DateFormat("dd-MM-yyyy").format(schedule.currentDate),
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

  Widget materialtrackingDetail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Container(),
      ),
    );
  }
}

class ScanInputRawMat extends StatefulWidget {
  Function update;
  ScanInputRawMat({required this.update});
  @override
  _ScanInputRawMatState createState() => _ScanInputRawMatState();
}

class _ScanInputRawMatState extends State<ScanInputRawMat> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
