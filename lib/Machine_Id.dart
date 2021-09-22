import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:molex_desktop/screens/kitting_plan/kitting_plan_dash.dart';
import 'package:molex_desktop/screens/operator/Homepage.dart';

import 'package:molex_desktop/service/api_service.dart';

import 'model_api/login_model.dart';
import 'model_api/machinedetails_model.dart';

// ignore: must_be_immutable
class MachineId extends StatefulWidget {
  Employee employee;
  MachineId({required this.employee});
  @override
  _MachineIdState createState() => _MachineIdState();
}

class _MachineIdState extends State<MachineId> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  String? machineId='';
  late ApiService apiService;
  late bool loading;
  FocusNode _textListnerNode = new FocusNode();
    //test
  
  @override
  void initState() {
    loading = false;
    apiService = new ApiService();
    _textNode.requestFocus();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }



  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _textNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
        backgroundColor: Color(0xffE2BDA6),
        body: GestureDetector(
          onTap: (){
              _textListnerNode.requestFocus();
          log("message");
          },
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Material(
                      elevation: 10,
                      shadowColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                          width: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: []),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Scan Machine",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: 30,
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              loading
                                  ? Container(
                                      height: 3,
                                      width: 280,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.grey.shade50,
                                        color: Colors.red.shade600,
                                      ),
                                    )
                                  : Container(
                                      width: 280,
                                    ),
                              Lottie.asset('assets/lottie/scan-barcode.json',
                                  width: 280, fit: BoxFit.cover),
                              // Text(
                              //   'Scan Machine',
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       fontSize: 20,
                              //       color: Colors.black,
                              //     ),
                              //   ),
                              // ),
                              machineId != ''
                                  ? Text(
                                      machineId ?? '',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 10,
                                    ),
                              SizedBox(height: 10),
                              Container(
                                height: 40,
                                width: 230,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shadowColor:
                                        MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Colors.white;
                                        return Colors
                                            .white; // Use the component's default.
                                      },
                                    ),
                                    elevation: MaterialStateProperty.resolveWith<
                                        double?>((Set<MaterialState> states) {
                                      return 10;
                                    }),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Colors.green;
                                        return Colors
                                            .red; // Use the component's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    machinScan();
                                  },
                                  child: Text(
                                    'Machine Login',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                height: 40,
                                width: 230,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.green;
                                          return Colors
                                              .red; // Use the component's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                          msg: "logged In",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => KittingDash(
                                                  employee: widget.employee,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      'Kitting',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              //pREPARATION
                              SizedBox(height: 10),
                              newMethod(),
                              Text(machineId??''),
                              // Container(
                              //   child: Container(
                              //         height: 00,
                              //         width: 0,
                              //         child: TextField(
                                        
                              //           // onSubmitted: (value) {
                              //           //   machinScan();
                              //           // },
                              //           onTap: () {
                              //             SystemChannels.textInput
                              //                 .invokeMethod('TextInput.hide');
                              //           },
                              //           controller: _textController,
                              //           autofocus: true,
                              //           focusNode: _textNode,
                              //           onChanged: (value) {
                              //             setState(() {
                              //               machineId = value;
                              //             });
                              //           },
                              //         ),
                              //       )),
                              
                            ]),
                          )),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: 70,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/image/appiconbg.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 20,
                  right: 30,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Text(
                                  widget.employee.employeeName ?? '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  widget.employee.empId ?? '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          Material(
                            elevation: 5,
                            shadowColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

    RawKeyboardListener newMethod() {
    return RawKeyboardListener(
      focusNode: _textListnerNode,
      autofocus: true,
      includeSemantics: true,
      child: Container(
        // child:  TextField(),
        child: Text(machineId??''),
      ),
      onKey: (value) {
        try {
          setState(() {
            machineId =
                "$machineId${value.character.toString() == "null" ? '' : value.character.toString()}";
          });
          print("1) ${value.data}");
          print("2) ${value.character.toString()}");
          print("3) ${value.toString()}");
          print("4) ${value.physicalKey.debugName}");
          log("5) ${value.logicalKey.keyId}");
          print("6) ${value.isKeyPressed(LogicalKeyboardKey.enter)}");

          setState(() {
            ///add string to list and clear text or not ?
            value.logicalKey == LogicalKeyboardKey.enter
                ?  print("YES A")
                : print("YES A");
            value.isKeyPressed(LogicalKeyboardKey.enter)
                ?  setState(() {
                    machineId = "";
                  })
                : print("loge ${value.toStringShort()}");
          });
        } catch (e) {
          log("message $e");
        }
      },
    );
  }

  void machinScan() {
    setState(() {
      loading = true;
    });

    apiService.getmachinedetails(machineId).then((value) {
      if (value != null) {
        MachineDetails machineDetails = value[0];

        Fluttertoast.showToast(
            msg: machineId ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        print("machineID:$machineId");
        switch (machineDetails.category) {
          case "Manual Cutting":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(
                  employee: widget.employee,
                  machine: machineDetails,
                ),
              ),
            );
            break;
          case "Automatic Cut & Crimp":
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(
                  employee: widget.employee,
                  machine: machineDetails,
                ),
              ),
            );
            break;
          case "Semi Automatic Strip and Crimp Machine":
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
            setState(() {
              loading = false;
            });
            AlertController.show(
              "Machine not Found",
              "Invalid Machine ID",
              TypeAlert.error,
            );

            setState(() {
              machineId = null;
              _textController.clear();
            });
        }
      } else {
        setState(() {
          loading = false;
          machineId = null;
          _textController.clear();
          _textNode.requestFocus();
        });
        AlertController.show(
          "Machine not Found",
          "Invalid Machine ID",
          TypeAlert.error,
        );

        setState(() {});
      }
    });
  }
}
