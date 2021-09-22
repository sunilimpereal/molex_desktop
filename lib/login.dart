import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'
    show FlutterBarcodeScanner, ScanMode;
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/screens/utils/changeIp.dart';
import 'package:molex_desktop/screens/utils/customKeyboard.dart';
import 'package:molex_desktop/screens/utils/updateApp.dart';
import 'package:molex_desktop/service/api_service.dart';
import 'package:molex_desktop/test_barcode.dart';

import 'Machine_Id.dart';
import 'model_api/login_model.dart';

class LoginScan extends StatefulWidget {
  @override
  _LoginScanState createState() => _LoginScanState();
}

class _LoginScanState extends State<LoginScan> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textNode = new FocusNode();
  FocusNode _textListnerNode = new FocusNode();
  String? userId='';
  late ApiService apiService;
  late Employee employee;
  late bool loading;

  late String? _barcode;
  //test


  @override
  void initState() {
    _barcode = null;
    loading = false;
    apiService = new ApiService();
    employee = new Employee();
    _textNode.requestFocus();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _textNode.dispose();
    super.dispose();
  }

  TextEditingController scanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      backgroundColor: Color(0xffE2BDA6),
      body: GestureDetector(
        onTap: () {
          _textListnerNode.requestFocus();
          log("message");
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Stack(children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 0),
                    Material(
                      elevation: 10,
                      shadowColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: []),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Login",
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
                                          color: Colors.red,
                                        ),
                                      )
                                    : Container(
                                        width: 280,
                                      ),
                                Lottie.asset('assets/lottie/scan-barcode.json',
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    fit: BoxFit.cover),
                                Text(
                                  'Scan Id Card to Login',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                userId != ''
                                    ? Text(
                                        userId ?? '',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 10,
                                      ),
                                SizedBox(height: 10),
                                  newMethod(),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        shadowColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.white;
                                            return Colors
                                                .white; // Use the component's default.
                                          },
                                        ),
                                        elevation: MaterialStateProperty
                                            .resolveWith<double?>(
                                                (Set<MaterialState> states) {
                                          return 10;
                                        }),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.pressed))
                                              return Colors.green;
                                            return Colors
                                                .red; // Use the component's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        loginScan(context);
                                      },
                                      child: Text(
                                        'Login',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 10,
                            shadowColor: Colors.white,
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangeIp()),
                                );
                              },
                              splashRadius: 60,
                              tooltip: "Change IP of the app",
                              color: Colors.white,
                              focusColor: Colors.white,
                              splashColor: Colors.red,
                              icon: Icon(
                                Icons.edit,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyApp1(

                                    )),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("v 1.0.1+4"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  RawKeyboardListener newMethod() {
    return RawKeyboardListener(
      focusNode: _textListnerNode,
      autofocus: true,
      includeSemantics: true,
      child: Container(
        width: 5,// child:  TextField(),
        
      ),
      onKey: (value) {
        try {
            setState(() {
            userId =
                "$userId${value.character.toString() == "null" ? '' : value.character.toString()}";  
            });
            
          
          print("1) ${value.data}");
          print("2) ${value.character.toString()}");
          print("3) ${value.toString()}");
          print("4) ${value.physicalKey.debugName}");
          log("5) ${value.logicalKey.keyId}");
          print("6) ${value.isKeyPressed(LogicalKeyboardKey.enter)}");

        
            ///add string to list and clear text or not ?
            value.logicalKey == LogicalKeyboardKey.enter
                ?  print("YES A")
                : print("YES A");
            value.isKeyPressed(LogicalKeyboardKey.enter)
                ?  setState(() {
                    userId = "";
                  })
                : print("loge ${value.toStringShort()}");
        
        } catch (e) {
          log("message $e");
        }
      },
    );
  }

  void loginScan(BuildContext context) {
    setState(() {
      loading = true;
    });
    print('pressed');
    apiService.empIdlogin(userId).then((value) {
      if (value != null) {
        AlertController.show(
          "Logged In",
          "Login ID : $userId",
          TypeAlert.success,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MachineId(
                    employee: value,
                  )),
        );
      } else {
        setState(() {
          _textNode.requestFocus();
          loading = false;
        });
        AlertController.show(
          "Login Failed",
          "Invalid Login ID",
          TypeAlert.error,
        );

        setState(() {
          userId = null;
          _textController.clear();
          scanController.clear();
        });
      }
    });
  }
}
// A KeyRepeatEvent is dispatched, but the state shows that the physical key is not pressed. If this occurs in real application, please report this bug to Flutter. If this occurs in unit tests, please ensure that simulated events follow Flutter's event model as documented in `HardwareKeyboard`. This was the event: KeyRepeatEvent#1a47e(physicalKey: PhysicalKeyboardKey#7002d(usbHidUsage: "0x0007002d", debugName: "Minus"), logicalKey: LogicalKeyboardKey#0002d(keyId: "0x0000002d", keyLabel: "-", debugName: "Minus"), character: "-", timeStamp: 4:45:54.649395)
// 'package:flutter/src/services/hardware_keyboard.dart':
// Failed assertion: line 441 pos 16: '_pressedKeys.containsKey(event.physicalKey)