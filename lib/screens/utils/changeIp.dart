import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:molex_desktop/main.dart';
import '../../login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeIp extends StatefulWidget {
  @override
  _ChangeIpState createState() => _ChangeIpState();
}

class _ChangeIpState extends State<ChangeIp> {
  late String baseip = sharedPref.baseIp ?? "";
  List<String> ipList1 = [
    "http://10.221.46.10:8080/wipts/", //client
    "http://10.221.46.8:8080/wipts/",
    "http://justerp.in:8080/wipts/",
  ];
  // List<String> ipList = [
  //   "http://justerp.in:8080/wipts/",
  //   "http://10.221.46.8:8080/wipts/",//client
  //   "http://192.168.1.252:8080/wipts/",//just
  //   "http://mlxbngvwqwip01.molex.com:8080/wipts/",
  //   "http://mlxbngvwqwip01.molex.com:8080/wiptst/",
  //   "http://10.221.46.8:8080/wiptst/",
  // ];
  late String newIp;
  late List<String> ipList;

  @override
  void initState() {
    super.initState();
    ipList = sharedPref.ipList ?? ipList1;
  }

  bool delOption = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Ip "),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  delOption = !delOption;
                });
              },
              icon: !delOption ? Icon(Icons.delete) : Icon(Icons.cancel))
        ],
      ),
      body: Container(
        child: Container(
          child: ListView.builder(
              itemCount: ipList.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ListTile(
                      tileColor: baseip == ipList[index]
                          ? Colors.red[200]
                          : Colors.white,
                      title: Text(" ${ipList[index]}"),
                      onLongPress: () {
                        setState(() {
                          delOption = !delOption;
                        });
                      },
                      onTap: () {
                        setState(() {
                          sharedPref.setbaseip(baseip: "${ipList[index]}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScan()),
                          );
                        });
                      },
                      trailing: delOption
                          ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showAlertDialog(context, ipList[index]);
                              },
                            )
                          : Container(
                              height: 8,
                              width: 9,
                            ),
                    ),
                  ],
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showaddip();
        },
        icon: Icon(Icons.add),
        label: Text("Add IP"),
      ),
    );
  }

  showAlertDialog(BuildContext context, String ip) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(fontSize: 18, color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.transparent))),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Colors.red.shade200;
            return Colors.red.shade500; // Use the component's default.
          },
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "   Delete   ",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      onPressed: () {
        setState(() {
          ipList.remove(ip);
          try {
            sharedPref.setipList(ipList);
          } catch (e) {
            sharedPref.setipList(ipList);
          }
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirm delete",
        style: TextStyle(fontSize: 22, fontFamily: fonts.poppins),
      ),
      content: Text(
        "Are you sure you want to delete ip: $ip ?",
        style: TextStyle(fontFamily: fonts.poppins, fontSize: 16),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> showaddip() async {
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
        return Center(child: addIp(context));
      },
    );
  }

  Widget addIp(BuildContext context) {
    return AlertDialog(
        title: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('Add URL '),
              ],
            ),
            Container(
              height: 50,
              width: 400,
              child: TextFormField(
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  setState(() {
                    newIp = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    if (newIp != null) {
                      setState(() {
                        ipList.add(newIp);
                        sharedPref.setipList(ipList);
                      });
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: "url is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Text("Save Ip")),
            ),
          ],
        ),
      ),
    ));
  }
}

// ListTile(
//   tileColor: baseip == "http://justerp.in:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://justerp.in:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://justerp.in:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://10.221.46.8:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://10.221.46.8:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://10.221.46.8:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://192.168.1.252:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://192.168.1.252:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://192.168.1.252:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// ),
// ListTile(
//   tileColor: baseip == "http://mlxbngvwqwip01.molex.com:8080/wipts/"
//       ? Colors.red[200]
//       : Colors.white,
//   title: Text("http://mlxbngvwqwip01.molex.com:8080/wipts/"),
//   onTap: () {
//     setState(() {
//       preferences.setString(
//           'baseIp', "http://mlxbngvwqwip01.molex.com:8080/wipts/");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScan()),
//       );
//     });
//   },
// )
