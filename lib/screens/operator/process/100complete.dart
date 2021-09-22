import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/process1/100Complete_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/model_api/startProcess_model.dart';
import 'package:molex_desktop/screens/widgets/keypad.dart';
import 'package:molex_desktop/service/api_service.dart';

import '../location.dart';

class FullyComplete extends StatefulWidget {
  Employee employee;
  MachineDetails machine;
  Schedule schedule;
  String bundleId;
  Function continueProcess;
  FullyComplete(
      {required this.employee,
      required this.machine,
      required this.schedule,
      required this.bundleId,
      required this.continueProcess});
  @override
  _FullyCompleteState createState() => _FullyCompleteState();
}

class _FullyCompleteState extends State<FullyComplete> {
  late PostStartProcessP1 postStartprocess;
  //Text Eddititing Controller
  TextEditingController mainController = new TextEditingController();
  TextEditingController firsrPeicelastPieceController =
      new TextEditingController();
  TextEditingController crimpheightAdjController = new TextEditingController();
  TextEditingController airPressureLowController = new TextEditingController();
  TextEditingController noRawMaterialController = new TextEditingController();
  TextEditingController applicatorChangeOverController =
      new TextEditingController();
  TextEditingController terminalChangeOverController =
      new TextEditingController();
  TextEditingController technichianNotAvailableController =
      new TextEditingController();
  TextEditingController powerFailureController = new TextEditingController();
  TextEditingController machineCleaningController = new TextEditingController();
  TextEditingController noOperatorController = new TextEditingController();
  TextEditingController sensorNotWorkingController =
      new TextEditingController();
  TextEditingController meetingController = new TextEditingController();
  TextEditingController maintainanceMinorStopageController =
      new TextEditingController();
  TextEditingController minorToolingAjjustmentsController =
      new TextEditingController();

  TextEditingController systemFaultController = new TextEditingController();
  String _output = '';
  late ApiService apiService;
  @override
  void initState() {
    apiService = new ApiService();
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
          child: Container(
          height: MediaQuery.of(context).size.height * 0.62,
            child: Row(
              children: [
                productionReport(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        }),
                    SizedBox(height: 5),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget productionReport() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75 - 4,
    
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('       Production Report',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: fonts.openSans,
                      fontSize: 20,
                    ))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
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
                            name: "FP,LP,Patrolling",
                            quantity: 10,
                            textEditingController:
                                firsrPeicelastPieceController,
                          ),
                          quantitycell(
                            name: "Crimp Height Adjustment",
                            quantity: 10,
                            textEditingController: crimpheightAdjController,
                          ),
                          quantitycell(
                            name: "Air Pressure Low",
                            quantity: 10,
                            textEditingController: airPressureLowController,
                          ),
                          quantitycell(
                            name: "No Raw Material ",
                            quantity: 10,
                            textEditingController: noRawMaterialController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Applicator Change over	",
                            quantity: 10,
                            textEditingController:
                                applicatorChangeOverController,
                          ),
                          quantitycell(
                            name: "Terminal Change over",
                            quantity: 10,
                            textEditingController: terminalChangeOverController,
                          ),
                          quantitycell(
                            name: "Technician Not Available",
                            quantity: 10,
                            textEditingController:
                                technichianNotAvailableController,
                          ),
                          quantitycell(
                            name: "Power Failure",
                            quantity: 10,
                            textEditingController: powerFailureController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
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
                            name: "Sensor Not Working		",
                            quantity: 10,
                            textEditingController: sensorNotWorkingController,
                          ),
                          quantitycell(
                            name: "Meeting",
                            quantity: 10,
                            textEditingController: meetingController,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          quantitycell(
                            name: "Maintenance Minor Stoppage",
                            quantity: 10,
                            textEditingController:
                                maintainanceMinorStopageController,
                          ),
                          quantitycell(
                            name: "Minor Tooling Adjustments",
                            quantity: 10,
                            textEditingController:
                                minorToolingAjjustmentsController,
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
                Container(
                  height: 80,
                  child: Center(
                    child: Container(
                      height: 40,
                      width: 100,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.green))),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.keyboard_arrow_left,
                                  color: Colors.green),
                              Text(
                                "Back",
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          onPressed: () {
                            widget.continueProcess("label");
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.all(0),
                  child: Center(
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.all(2),
                      width: MediaQuery.of(context).size.width * 0.15,
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
                                return Colors.green;
                              return Colors
                                  .green.shade500; // Use the component's default.
                            },
                          ),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green.shade600;
                              return Colors
                                  .green.shade300; // Use the component's default.
                            },
                          ),
                        ),
                        child: Text("Save & Complete Process"),
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            postStartprocess = new PostStartProcessP1(
                              cablePartNumber:
                                  widget.schedule.cablePartNumber ?? "0",
                              color: widget.schedule.color,
                              finishedGoodsNumber:
                                  widget.schedule.finishedGoodsNumber ?? "0",
                              lengthSpecificationInmm:
                                  widget.schedule.length ?? "0",
                              machineIdentification:
                                  widget.machine.machineNumber,
                              orderIdentification:
                                  widget.schedule.orderId ?? "0",
                              scheduledIdentification:
                                  widget.schedule.scheduledId ?? "0",
                              scheduledQuantity:
                                  widget.schedule.scheduledQuantity ?? "0",
                              scheduleStatus: "complete",
                            );
                            FullyCompleteModel fullyComplete =
                                FullyCompleteModel(
                              finishedGoodsNumber: int.parse(
                                  widget.schedule.finishedGoodsNumber),
                              purchaseOrder: int.parse(widget.schedule.orderId),
                              orderId: int.parse(widget.schedule.orderId),
                              cablePartNumber:
                                  int.parse(widget.schedule.cablePartNumber),
                              length: int.parse(widget.schedule.length),
                              color: widget.schedule.color,
                              scheduledStatus: "Complete",
                              scheduledId:
                                  int.parse(widget.schedule.scheduledId),
                              scheduledQuantity:
                                  int.parse(widget.schedule.scheduledQuantity),
                              machineIdentification:
                                  widget.machine.machineNumber,
                              //TODO bundle ID
                              firstPieceAndPatrol:
                                  firsrPeicelastPieceController.text == ''
                                      ? 0
                                      : int.parse(
                                          firsrPeicelastPieceController.text),
                              applicatorChangeover:
                                  applicatorChangeOverController.text == ''
                                      ? 0
                                      : int.parse(
                                          applicatorChangeOverController.text),
                            );
                            apiService
                                .post100Complete(fullyComplete)
                                .then((value) {
                              if (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Location(
                                            type: "process",
                                            employee: widget.employee,
                                            machine: widget.machine, locationType: LocationType.finaTtransfer,
                                          )),
                                );
                              } else {}
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget quantitycell(
      {required String name,
      required int quantity,
      required TextEditingController textEditingController,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.22,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 50,
                width: 220,
                child: TextField(
                  controller: textEditingController,
              
                  onTap: () {
                    setState(() {
                      _output = '';
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
}
