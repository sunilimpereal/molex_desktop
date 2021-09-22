import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/partiallyComplete_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/screens/widgets/keypad.dart';
import 'package:molex_desktop/service/api_service.dart';

import '../location.dart';


class PartiallyComplete extends StatefulWidget {
  MachineDetails machine;
  Schedule schedule;
  Employee employee;
  Function continueProcess;
  PartiallyComplete(
      {required this.machine, required this.employee, required this.continueProcess, required this.schedule});
  @override
  _PartiallyCompleteState createState() => _PartiallyCompleteState();
}

class _PartiallyCompleteState extends State<PartiallyComplete> {
  String _output = '';

  TextEditingController mainController = new TextEditingController();
  TextEditingController firstPatrolController = new TextEditingController();
  TextEditingController spareChangeoverController = new TextEditingController();
  TextEditingController crimpHeightSettingController =
      new TextEditingController();
  TextEditingController resettingCFMProgramController =
      new TextEditingController();
  TextEditingController newProgramSettingCVMCFMController =
      new TextEditingController();
  TextEditingController airPressureLowController = new TextEditingController();
  TextEditingController machineTakenforRemovingCVMController =
      new TextEditingController();
  TextEditingController noMaterialController = new TextEditingController();
  TextEditingController applicatorChangeoverController =
      new TextEditingController();
  TextEditingController sinkHeightAdjustmentController =
      new TextEditingController();
  TextEditingController feedingAdjustmentController =
      new TextEditingController();
  TextEditingController applicatorPositionSettingController =
      new TextEditingController();
  TextEditingController validationController = new TextEditingController();
  TextEditingController cFACrimpingFaultController =
      new TextEditingController();
  TextEditingController cableEntangleController = new TextEditingController();
  TextEditingController jobTicketIssueController = new TextEditingController();
  TextEditingController lengthChangeoverController =
      new TextEditingController();
  TextEditingController terminalBendController = new TextEditingController();
  TextEditingController cutOffBurrIssueController = new TextEditingController();
  TextEditingController cVMErrorCorrectionController =
      new TextEditingController();
  TextEditingController cableFeedingFrontUnitProblemController =
      new TextEditingController();
  TextEditingController driftLimitReachedController =
      new TextEditingController();
  TextEditingController machineSlowController = new TextEditingController();
  TextEditingController noPlanforMachineController =
      new TextEditingController();
  TextEditingController terminalChangeoverController =
      new TextEditingController();
  TextEditingController terminalTwistController = new TextEditingController();
  TextEditingController extrusionBurrIssueController =
      new TextEditingController();
  TextEditingController cFMErrorController = new TextEditingController();
  TextEditingController supplierTakenforMaintenanceController =
      new TextEditingController();
  TextEditingController rollerChangeoverController =
      new TextEditingController();
  TextEditingController gripenUnitProblemController =
      new TextEditingController();
  TextEditingController technicianNotAvailableController =
      new TextEditingController();
  TextEditingController coilChangeoverController = new TextEditingController();
  TextEditingController bellmouthAdjustmentController =
      new TextEditingController();
  TextEditingController cameraSettingController = new TextEditingController();
  TextEditingController cVMErrorController = new TextEditingController();
  TextEditingController lengthVariationsController =
      new TextEditingController();
  TextEditingController powerFailureController = new TextEditingController();
  TextEditingController machineCleaningController = new TextEditingController();
  TextEditingController noOperatorController = new TextEditingController();
  TextEditingController lastPieceController = new TextEditingController();
  TextEditingController curlingAdjustmentController =
      new TextEditingController();
  TextEditingController wireFeedingAdjustmentController =
      new TextEditingController();
  TextEditingController cVMProgramReloadingController =
      new TextEditingController();
  TextEditingController sensorNotWorkingController =
      new TextEditingController();
  TextEditingController preventiveMaintenanceController =
      new TextEditingController();
  TextEditingController meetingController = new TextEditingController();
  TextEditingController systemFaultController = new TextEditingController();
  List<String> reasonList = [
    "Spare Changeover",
    "Sink Height Adjustment",
    "Terminal Bend",
    "Terminal Twist",
    "Bellmouth Adjustment",
    "Curling Adjustment",
    "Crimp Height Setting",
    "Feeding Adjustment",
    "Cut Off Burr Issue",
    "Extrusion Burr Issue",
    "Camera Setting",
    "Wire Feeding Adjustment",
    "Resetting CFM Program",
    "Applicator Position Setting",
    "CVM Error Correction",
    "CFM Error",
    "CVM Error",
    "CVM Program Reloading",
    "New Program Setting CVM/CFM",
    "Cable Feeding Front Unit Problem",
    "Supplier Taken for Maintenance",
    "Length Variations",
    "Sensor Not Working",
    "Air Pressure Low",
    "CFA Crimping Fault",
    "Drift Limit Reached",
    "Roller Changeover",
    "Power Failure",
    "Preventive Maintenance",
    "Machine Taken for Removing CVM",
    "Cable Entangle",
    "Machine Slow",
    "Gripen Unit Problem",
    "Machine Cleaning",
    "Meeting",
    "No Material",
    "Job Ticket Issue",
    "No Plan for Machine",
    "Technician Not Available",
    "No Operator",
    "System Fault",
  ];
  List<String> selectedreasons = [];
  late ApiService apiService;
  @override
  void initState() {
    apiService = new ApiService();
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        showReasons();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
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
                children: [
                  partialCompletion(),
                  KeyPad(
                      controller: mainController,
                      buttonPressed: (buttonText) {
                        if (buttonText == 'X') {
                          _output = '';
                        } else {
                          _output = _output + buttonText;
                        }

                        print(_output);
                        setState(() {
                          mainController.text = _output;
                          // output = int.parse(_output).toStringAsFixed(2);
                        });
                      })
                ],
              ),
            )));
  }

  Widget keypad(TextEditingController controller) {
    // print('NickMark ${windowGapController.text}');
    // print('End wire ${endWireController.text}');
    buttonPressed(String buttonText) {
      if (buttonText == 'X') {
        _output = '';
      } else {
        _output = _output + buttonText;
      }

      print(_output);
      setState(() {
        controller.text = _output;
        // output = int.parse(_output).toStringAsFixed(2);
      });
    }

    Widget buildbutton(String buttonText) {
      return new Expanded(
          child: Container(
        decoration: new BoxDecoration(),
        width: 27,
        height: 50,
        child: new ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: Colors.grey.shade50))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.grey.shade100;

                return Colors.white; // Use the component's default.
              },
            ),
          ),
          child: buttonText == "X"
              ? Container(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      color: Colors.red[400],
                    ),
                    onPressed: () => {buttonPressed(buttonText)},
                  ))
              : new Text(
                  buttonText,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ),
          onPressed: () => {buttonPressed(buttonText)},
        ),
      ));
    }

    return Material(
      elevation: 2,
      shadowColor: Colors.grey.shade200,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.red.withOpacity(0.1),
          //     spreadRadius: 2,
          //     blurRadius: 2,
          //     offset: Offset(0, 0), // changes position of shadow
          //   ),
          // ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                buildbutton("7"),
                buildbutton('8'),
                buildbutton('9'),
              ],
            ),
            Row(
              children: [
                buildbutton('4'),
                buildbutton('5'),
                buildbutton('6'),
              ],
            ),
            Row(
              children: [
                buildbutton('1'),
                buildbutton('2'),
                buildbutton('3'),
              ],
            ),
            Row(
              children: [
                buildbutton('00'),
                buildbutton('0'),
                buildbutton('X'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget partialCompletion() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75 - 4,
      height:  MediaQuery.of(context).size.height * 0.63,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Column(
                    children: [
                      Container(
                        width: 310,
                        child: Row(
                          children: [
                            Text('Partial Completion Reason',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: fonts.openSans,
                                )),
                          ],
                        ),
                      ),
                      Text('Note: Update Reason in terms of minutes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: fonts.openSans,
                          )),
                    ],
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showReasons();
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.red))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.red.shade50;
                        return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(
                          'Reason',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.red,
                                  fontFamily: fonts.openSans,
                                  fontSize: 14)),
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.red,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
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
                          name: "First Piece & Patrol",
                          quantity: 10,
                          textEditingController: firstPatrolController,
                        ),
                        quantitycell(
                          name: "Spare Changeover",
                          quantity: 10,
                          textEditingController: spareChangeoverController,
                        ),
                        quantitycell(
                          name: "Crimp Height Setting",
                          quantity: 10,
                          textEditingController: crimpHeightSettingController,
                        ),
                        quantitycell(
                          name: "Resetting CFM Program",
                          quantity: 10,
                          textEditingController: resettingCFMProgramController,
                        ),
                        quantitycell(
                          name: "New Program Setting CVM/CFM	",
                          quantity: 10,
                          textEditingController:
                              newProgramSettingCVMCFMController,
                        ),
                         quantitycell(
                          name: "Air Pressure Low",
                          quantity: 10,
                          textEditingController: airPressureLowController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                       
                        quantitycell(
                          name: "Machine Taken for Removing CVM	",
                          quantity: 10,
                          textEditingController: machineCleaningController,
                        ),
                        quantitycell(
                          name: "No Material",
                          quantity: 10,
                          textEditingController: noMaterialController,
                        ),
                        quantitycell(
                          name: "Applicator Changeover	",
                          quantity: 10,
                          textEditingController: applicatorChangeoverController,
                        ),
                        quantitycell(
                          name: "Sink Height Adjustment",
                          quantity: 10,
                          textEditingController: sinkHeightAdjustmentController,
                        ),
                        quantitycell(
                          name: "Feeding Adjustment	",
                          quantity: 10,
                          textEditingController: feedingAdjustmentController,
                        ),
                        quantitycell(
                          name: "Applicator Position Setting		",
                          quantity: 10,
                          textEditingController:
                              applicatorPositionSettingController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        
                        quantitycell(
                          name: "Validation",
                          quantity: 10,
                          textEditingController: validationController,
                        ),
                        quantitycell(
                          name: "CFA Crimping Fault",
                          quantity: 10,
                          textEditingController: cFACrimpingFaultController,
                        ),
                        quantitycell(
                          name: "Cable Entangle",
                          quantity: 10,
                          textEditingController: cableEntangleController,
                        ),
                         quantitycell(
                          name: "Job Ticket Issue	",
                          quantity: 10,
                          textEditingController: jobTicketIssueController,
                        ),
                        quantitycell(
                          name: "Length Changeover",
                          quantity: 10,
                          textEditingController: lengthChangeoverController,
                        ),
                        quantitycell(
                          name: "Terminal Bend",
                          quantity: 10,
                          textEditingController: terminalBendController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                       
                        quantitycell(
                          name: "Cut Off Burr Issue",
                          quantity: 10,
                          textEditingController: cutOffBurrIssueController,
                        ),
                        quantitycell(
                          name: "CVM Error Correction",
                          quantity: 10,
                          textEditingController: cVMErrorCorrectionController,
                        ),
                        quantitycell(
                          name: "Cable Feeding Front Unit Problem",
                          quantity: 10,
                          textEditingController:
                              cableFeedingFrontUnitProblemController,
                        ),
                        quantitycell(
                          name: "Drift Limit Reached	",
                          quantity: 10,
                          textEditingController: driftLimitReachedController,
                        ),
                        quantitycell(
                          name: "Machine Slow	",
                          quantity: 10,
                          textEditingController: machineSlowController,
                        ),
                        quantitycell(
                          name: "No Plan for Machine	",
                          quantity: 10,
                          textEditingController: noPlanforMachineController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        
                        quantitycell(
                          name: "Terminal Changeover",
                          quantity: 10,
                          textEditingController: terminalChangeoverController,
                        ),
                           quantitycell(
                          name: "Terminal Twist",
                          quantity: 10,
                          textEditingController: terminalTwistController,
                        ),
                        quantitycell(
                          name: "Extrusion Burr Issue",
                          quantity: 10,
                          textEditingController: extrusionBurrIssueController,
                        ),
                        quantitycell(
                          name: "CFM Error",
                          quantity: 10,
                          textEditingController: cFMErrorController,
                        ),
                        quantitycell(
                          name: "Supplier Taken for Maintenance	",
                          quantity: 10,
                          textEditingController:
                              supplierTakenforMaintenanceController,
                        ),
                        quantitycell(
                          name: "Roller Changeover",
                          quantity: 10,
                          textEditingController: rollerChangeoverController,
                        ),
                      ],
                    ),
                   
                    Column(
                      children: [
                        quantitycell(
                          name: "Gripen Unit Problem",
                          quantity: 10,
                          textEditingController: gripenUnitProblemController,
                        ),
                        quantitycell(
                          name: "Technician Not Available	",
                          quantity: 10,
                          textEditingController:
                              technicianNotAvailableController,
                        ),
                        quantitycell(
                          name: "Coil Changeover	",
                          quantity: 10,
                          textEditingController: coilChangeoverController,
                        ),
                        quantitycell(
                          name: "Bellmouth Adjustment",
                          quantity: 10,
                          textEditingController: bellmouthAdjustmentController,
                        ),
                        quantitycell(
                          name: "Camera Setting	",
                          quantity: 10,
                          textEditingController: cameraSettingController,
                        ),
                         quantitycell(
                          name: "CVM Error",
                          quantity: 10,
                          textEditingController: cVMErrorController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                       
                        quantitycell(
                          name: "Length Variations	",
                          quantity: 10,
                          textEditingController: lengthVariationsController,
                        ),
                        quantitycell(
                          name: "Power Failure",
                          quantity: 10,
                          textEditingController: powerFailureController,
                        ),
                        quantitycell(
                          name: "Machine Cleaning",
                          quantity: 10,
                          textEditingController: machineCleaningController,
                        ),
                        quantitycell(
                          name: "No Operator",
                          quantity: 10,
                          textEditingController: noOperatorController,
                        ),
                          quantitycell(
                          name: "Last Piece	",
                          quantity: 10,
                          textEditingController: lastPieceController,
                        ),
                        quantitycell(
                          name: "Curling Adjustment",
                          quantity: 10,
                          textEditingController: curlingAdjustmentController,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                      
                        quantitycell(
                          name: "Wire Feeding Adjustment",
                          quantity: 10,
                          textEditingController:
                              wireFeedingAdjustmentController,
                        ),
                        quantitycell(
                          name: "CVM Program Reloading",
                          quantity: 10,
                          textEditingController: cVMProgramReloadingController,
                        ),
                        quantitycell(
                          name: "Sensor Not Working",
                          quantity: 10,
                          textEditingController: sensorNotWorkingController,
                        ),
                           quantitycell(
                          name: "Preventive Maintenance	",
                          quantity: 10,
                          textEditingController:
                              preventiveMaintenanceController,
                        ),
                        quantitycell(
                          name: "Meeting	",
                          quantity: 10,
                          textEditingController: meetingController,
                        ),
                        quantitycell(
                          name: "System Fault	",
                          quantity: 10,
                          textEditingController: systemFaultController,
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 250,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: Colors.green))),
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
                        child: Text("Accept and Continue Process",
                            style: TextStyle(
                                color: Colors.green,
                                fontFamily: fonts.openSans,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          PostpartiallyComplete postpartiallyComplete =
                              new PostpartiallyComplete(
                                  finishedGoods: int.parse(
                                      widget.schedule.finishedGoodsNumber),
                                  purchaseOrder: widget.schedule.orderId,
                                  orderIdentification: widget.schedule.orderId,
                                  cablePartNumber:
                                      widget.schedule.cablePartNumber,
                                  cutLength: widget.schedule.length,
                                  color: widget.schedule.color,
                                  scheduleIdentification:
                                      int.parse(widget.schedule.scheduledId));
                          apiService
                              .postpartialComplete(
                                  postpartiallyComplete, widget.schedule.awg)
                              .then((value) {
                            if (value) {
                              widget.continueProcess("label");
                            } else {
                              // Fluttertoast.showToast(
                              //     msg: "Post Partial Completion data failed",
                              //     toastLength: Toast.LENGTH_LONG,
                              //     gravity: ToastGravity.CENTER,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.red,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  height: 50,
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 250,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(color: Colors.transparent))),
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
                        child: Text(
                          "Save & End Process",
                          style: TextStyle(
                              fontFamily: fonts.openSans,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          PostpartiallyComplete postpartiallyComplete =
                              new PostpartiallyComplete(
                                  finishedGoods: int.parse(
                                      widget.schedule.finishedGoodsNumber),
                                  purchaseOrder: widget.schedule.orderId,
                                  orderIdentification: widget.schedule.orderId,
                                  cablePartNumber:
                                      widget.schedule.cablePartNumber,
                                  cutLength: widget.schedule.length,
                                  color: widget.schedule.color,
                                  scheduleIdentification:
                                      int.parse(widget.schedule.scheduledId));
                          apiService
                              .postpartialComplete(
                                  postpartiallyComplete, widget.schedule.awg)
                              .then((value) {
                            if (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Location(
                                          type: "process",
                                          employee: widget.employee,
                                          machine: widget.machine,
                                          locationType:
                                              LocationType.finaTtransfer,
                                        )),
                              );
                            } else {
                              // Fluttertoast.showToast(
                              //     msg: "Post Partial Completion data failed",
                              //     toastLength: Toast.LENGTH_LONG,
                              //     gravity: ToastGravity.CENTER,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.red,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget quantitycell(
      {required String name,
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
                child: TextField(
                  readOnly: true,
                  controller: textEditingController,
               
                  onTap: () {
                    setState(() {
                      if (textEditingController.text.length > 0) {
                        _output = textEditingController.text;
                      } else {
                        _output = '';
                      }

                      mainController = textEditingController;
                    });
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  style: TextStyle(fontSize: 14,fontFamily: fonts.openSans),
                  keyboardType: TextInputType.name,
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

  Future<void> showReasons() async {
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
            child: ReasonSelection(
          selectedList: selectedreasons,
          onChanged: (value) {
            setState(() {
              selectedreasons = value;
            });
          },
        ));
      },
    );
  }
}

class ReasonSelection extends StatefulWidget {
  Function onChanged;
  List<String> selectedList;
  ReasonSelection({required this.onChanged, required this.selectedList});
  @override
  _ReasonSelectionState createState() => _ReasonSelectionState();
}

class _ReasonSelectionState extends State<ReasonSelection> {
  List<String> reasonList = [
    'Air Pressure Low	',
    'Applicator Changeover',
    'Applicator Position Settings',
    'Bellmouth Adjustment',
    'Cable Entangle	check full name',
    "Cable Feeding Front Unit",
    'Camera Setting',
    'CFA Crimping Fault',
    'CFM Error',
    'Coil Changeover',
    'Crimp Height Settings',
    'Curling Adjustment',
    'Cut Off Burr Issue',
    'CVF Error Correction',
    'CVM Error',
    'CVM Program Reloading',
    'Drift Limit Reached',
    'Extrusion Burr Issue',
    'Feeding Adjustment',
    'First Piece & Patrol',
    'Gripen Unit Problem',
    'Job Ticket Issue',
    'Last Piece',
    'Length Changeover',
    'Length Variations',
    'Machine Cleaning',
    'Machine Slow	check full name',
    'Machine Taken from',
    'Meeting	check full name',
    'New Program Settings CVM',
    'No Material',
    'No Operator',
    'No Plan For Machine',
    'Power Failure',
    'Preventive maintainence',
    'Resetting CFM Program',
    'Roller Changeover',
    'Sensor Not Working',
    'Sink Height Adjustment',
    'Spare Changeover	check full name',
    'Supplier Taken For',
    'System Fault',
    'Technician Not Available',
    'Terminal Bend',
    'Terminal Changeover',
    'Terminal Twist',
    'Validation',
    'Wire Feeding Adjustment',
  ];
  List<String> selectedreasons = [];
  @override
  void initState() {
    selectedreasons = widget.selectedList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Container(
      height: 600,
      width: 500,
      child: Column(
        children: [
          Row(
            children: [
              Text('Reason'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selectedreasons
                      .map((e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Container(
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Text(
                                      e,
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedreasons.remove(e);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.close,
                                          size: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          Container(
            height: 480,
            child: ListView.builder(
              itemCount: reasonList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  onTap: () {
                    setState(() {
                      selectedreasons.add(reasonList[index]);
                    });
                  },
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    reasonList[index],
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 13,
                    )),
                  ),
                  trailing: selectedreasons.contains(reasonList[index])
                      ? Icon(
                          Icons.check_rounded,
                          color: Colors.green,
                        )
                      : Icon(Icons.add),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      widget.onChanged(selectedreasons);
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(color: Colors.transparent))),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.green.shade200;
                          return Colors
                              .green.shade500; // Use the component's default.
                        },
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.green.shade200;
                          return Colors
                              .green.shade500; // Use the component's default.
                        },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Save"),
                    )),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
