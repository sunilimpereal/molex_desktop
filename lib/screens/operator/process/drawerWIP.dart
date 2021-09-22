import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/schedular_model.dart';
import 'package:molex_desktop/screens/utils/showBundleDetail.dart';

import '../Homepage.dart';

class DrawerWidgetWIP extends StatefulWidget {
  Employee employee;
  MachineDetails machineDetails;
  Schedule schedule;
  Function reloadmaterial;
  Function transfer;
  Function returnmaterial;
  String type;
  DrawerWidgetWIP(
      {required this.employee,
      required this.schedule,
      required this.machineDetails,
      required this.type,
      required this.returnmaterial,
      required this.reloadmaterial,
      required this.transfer});
  @override
  _DrawerWidgetWIPState createState() => _DrawerWidgetWIPState();
}

class _DrawerWidgetWIPState extends State<DrawerWidgetWIP> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.2,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Stack(
          children: [
            Column(
              children: [profileView()],
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "v 1.0.1+4",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: Colors.red,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget profileView() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.all(Radius.circular(500))),
                  child: Center(
                    child: Text(
                      "${widget.employee.employeeName!.substring(0, 2).toUpperCase()}", // TODO
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 170,
                          child: Text(
                            "${widget.employee.employeeName}",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 170,
                          child: Text(
                            "${widget.employee.empId}",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                widget.transfer();
              },
              title: Text(
                'Location & Bin Map',
                style: TextStyle(
                    fontFamily: fonts.openSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.transfer_within_a_station_outlined,
                color: Colors.red[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                // Navigator.pop(context);
                widget.reloadmaterial();
              },
              title: Text(
                'Realod Material',
                style: TextStyle(
                    fontFamily: fonts.openSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.add_box,
                color: Colors.red[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                widget.returnmaterial();
              },
              title: Text(
                'Return Material',
                style: TextStyle(
                    fontFamily: fonts.openSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.repeat_rounded,
                color: Colors.red[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                showBundleDetail(context);
              },
              title: Text(
                'Bundle Detail',
                style: TextStyle(
                    fontFamily: fonts.openSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.book_online_rounded,
                color: Colors.red[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              focusColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);

                switch (widget.machineDetails.category) {
                  case "Manual Cutting":
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homepage(
                                employee: widget.employee,
                                machine: widget.machineDetails,
                              )),
                    );
                    break;
                  case "Automatic Cut & Crimp":
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homepage(
                                employee: widget.employee,
                                machine: widget.machineDetails,
                              )),
                    );
                    break;
                  case "Semi Automatic Strip and Crimp machine":
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homepage(
                                employee: widget.employee,
                                machine: widget.machineDetails,
                              )),
                    );
                    break;
                  case "Automatic Cutting":
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homepage(
                                employee: widget.employee,
                                machine: widget.machineDetails,
                              )),
                    );
                    break;
                  default:
                    Fluttertoast.showToast(
                        msg: "Machine not Found",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                }
              },
              title: Text(
                'Return',
                style: TextStyle(
                    fontFamily: fonts.openSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.exit_to_app,
                color: Colors.red[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
