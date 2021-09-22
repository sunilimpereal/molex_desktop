import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/kitting_plan/getKittingData_model.dart';
import 'package:molex_desktop/model_api/kitting_plan/save_kitting_model.dart';
import 'package:molex_desktop/model_api/login_model.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/screens/widgets/drawer.dart';
import 'package:molex_desktop/screens/widgets/time.dart';
import 'package:molex_desktop/service/api_service.dart';

class KittingDash extends StatefulWidget {
  Employee employee;
  KittingDash({required this.employee});
  @override
  _KittingDashState createState() => _KittingDashState();
}

class _KittingDashState extends State<KittingDash> {
  String? fgNumber;
  String? orderId;
  String? qty;
  late ApiService apiService;
  List<KittingPost> kittingList = [];
  bool loading = false;
  bool loadingSave = false;

  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        title: const Text(
          'Kitting',
          style: TextStyle(color: Colors.red),
        ),
        elevation: 0,
        actions: [
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
                            widget.employee.empId ?? '',
                            style: TextStyle(fontSize: 13, color: Colors.black),
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
      drawer: Drawer(
        child: DrawerWidget(
            employee: widget.employee,
            machineDetails: MachineDetails(),
            type: "process"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              search(),
              save(),
            ],
          ),
          dataTable()
        ],
      ),
    );
  }

  Widget search() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 180,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.shade100,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    onChanged: (value) {
                      //TODO
                      setState(() {
                        fgNumber = value;
                      });
                    },
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        labelText: "Fg Number",
                        contentPadding: EdgeInsets.all(5),
                        isDense: false,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 180,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.shade100,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      //TODO
                      setState(() {
                        orderId = value;
                      });
                    },
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: "Order ID",
                        isDense: false,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 100,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.shade100,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      qty = value;
                      //TODO
                    },
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        labelText: "Qty",
                        contentPadding: EdgeInsets.all(0),
                        isDense: false,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: BorderSide(color: Colors.transparent))),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.blue.shade200;
                    return Colors.blue.shade500; // Use the component's default.
                  },
                ),
              ),
              onPressed: () {
                setState(() {
                  loading = true;
                });
                FocusScope.of(context).unfocus();
                FocusNode focusNode = FocusNode();
                focusNode.unfocus();
                PostKittingData postKittingData = new PostKittingData(
                    orderNo: orderId,
                    fgNumber: int?.parse(fgNumber!),
                    quantity: int?.parse(qty!));
                apiService.getkittingDetail(postKittingData).then((value) {
                  //84671404
                  //369100004
                  if (value != null) {
                    setState(() {
                      List<KittingEJobDtoList> kitlis = value;
                      for (KittingEJobDtoList kit in kitlis) {
                        kittingList.add(KittingPost(
                            kittingEJobDtoList: kit,
                            selectedBundles: getList(kit.bundleMaster!)));
                        log("${kit.bundleMaster!.length}");
                      }
                      loading = false;
                    });
                  } else {
                    setState(() {
                      loading = false;
                    });
                    //TODO toast
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? Container(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 6),
                          Text(
                            "Search",
                            style: TextStyle(fontSize: 15),
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

  getList(List<BundleMaster> bundleList) {
    List<BundleMaster> temp = [];
    int totalQty = 0;
    for (BundleMaster b in bundleList) {
      if (totalQty < int.parse(qty ?? '0')) {
        temp.add(b);
        totalQty = totalQty +b.bundleQuantity;
      } else {
        break;
      }
    }
    return temp;
  }

  Widget dataTable() {
    TextStyle headingStyle = TextStyle(
        fontSize: 18, fontWeight: FontWeight.w500, fontFamily: fonts.poppins);
    TextStyle dataStyle = TextStyle(
      fontSize: 18,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 35,
              columns: [
                DataColumn(
                  label: Text(
                    'FG',
                    style: GoogleFonts.poppins(
                      textStyle: headingStyle,
                    ),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Cablepart No.',
                  style: GoogleFonts.poppins(
                    textStyle: headingStyle,
                  ),
                )),
                DataColumn(
                  label: Text(
                    ' AWG',
                    style: GoogleFonts.poppins(
                      textStyle: headingStyle,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Cut Length',
                    style: GoogleFonts.poppins(
                      textStyle: headingStyle,
                    ),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Bundles',
                  style: GoogleFonts.poppins(
                    textStyle: headingStyle,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'Total Qty',
                  style: GoogleFonts.poppins(
                    textStyle: headingStyle,
                  ),
                )),
                DataColumn(
                  label: Text(
                    'Color',
                    style: GoogleFonts.poppins(
                      textStyle: headingStyle,
                    ),
                  ),
                ),
                DataColumn(
                    label: Text(
                  'Order Qty',
                  style: GoogleFonts.poppins(
                    textStyle: headingStyle,
                  ),
                )),
                DataColumn(
                    label: Text(
                  'Pending Qty',
                  style: GoogleFonts.poppins(
                    textStyle: headingStyle,
                  ),
                ))
              ],
              rows: kittingList.map(
                (e) {
                  var length2 = e.kittingEJobDtoList.bundleMaster!.length;

                  return DataRow(cells: <DataCell>[
                    DataCell(Text(
                      "${e.kittingEJobDtoList.fgNumber}",
                      style: dataStyle,
                    )),
                    DataCell(Text(
                      "${e.kittingEJobDtoList.cableNumber}",
                      style: dataStyle,
                    )),
                    DataCell(Text(
                      "${e.kittingEJobDtoList.wireGuage}",
                      style: dataStyle,
                    )),
                    DataCell(Text(
                      "${e.kittingEJobDtoList.cutLength}",
                      style: dataStyle,
                    )),

                    DataCell(Container(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "$length2",
                            style: dataStyle,
                          ),
                          IconButton(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onPressed: () {
                                showBundleDetail(
                                    context: context,
                                    fgNo: "${e.kittingEJobDtoList.fgNumber}",
                                    cablePartNo:
                                        "${e.kittingEJobDtoList.cableNumber}",
                                    awg: "${e.kittingEJobDtoList.wireGuage}",
                                    bundles: e.kittingEJobDtoList.bundleMaster!,
                                    selectedBundles: e.selectedBundles);
                              },
                              icon: Icon(
                                Icons.launch,
                                size: 16,
                                color: Colors.red.shade500,
                              ))
                        ],
                      ),
                    )),
                    DataCell(Text(
                      "${getBundleQty(e.selectedBundles)}",
                      style: dataStyle,
                    )),
                    DataCell(Text(
                      e.kittingEJobDtoList.cableColor ?? "",
                      style: dataStyle,
                    )),
                    DataCell(Text(
                      "$qty",
                      style: dataStyle,
                    )),
                    // DataCell(Text("${e.selectedBundles.length}")),
                    // DataCell(Text(
                    //     "${e.kittingEJobDtoList.bundleMaster!.length - e.selectedBundles.length}")),

                    DataCell(Text(
                        "${getPendingQty(e.kittingEJobDtoList.bundleMaster, e.selectedBundles).abs()}",
                        style: TextStyle(
                            fontSize: 18,
                            color: getPendingQty(
                                        e.kittingEJobDtoList.bundleMaster,
                                        e.selectedBundles) <=
                                    0
                                ? Colors.green
                                : Colors.red))),
                  ]);
                },
              ).toList(),
            ),
          )),
    );
  }

  int getBundleQty(List<BundleMaster> bundles) {
    int sum =
        bundles.map((e) => e.bundleQuantity).toList().fold(0, (p, c) => p + c);
    return sum;
  }

  int getPendingQty(
    List<BundleMaster>? bundlesmaster,
    List<BundleMaster> selectedBundle1,
  ) {
    int sum1 = selectedBundle1
        .map((e) => e.bundleQuantity)
        .toList()
        .fold(0, (p, c) => p + c);

    int sum2 = int.parse(qty ?? '0');

    //  = selectedBundle1
    //     .map((e) => e.bundleQuantity)
    //     .toList()
    //     .fold(0, (p, c) => p + c);
    return sum2 - sum1;
  }

  Future<void> showBundleDetail(
      {required BuildContext context,
      required List<BundleMaster> bundles,
      required String fgNo,
      required String cablePartNo,
      required String awg,
      required List<BundleMaster> selectedBundles}) async {
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
            child: ShowBundleList(
          fgNo: fgNo,
          awg: awg,
          cablePartNo: cablePartNo,
          bundleList: bundles,
          selectedBundleList: selectedBundles,
          reload: () {
            setState(() {});
          },
        ));
      },
    );
  }

  Widget save() {
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: BorderSide(color: Colors.transparent))),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.green.shade200;
              return Colors.green.shade500; // Use the component's default.
            },
          ),
        ),
        onPressed: () {
          setState(() {
            loadingSave = true;
          });
          List<SaveKitting> saveKitting = kittingList.map((e) {
            // for (KittingPost e in kittingList) {
            // SaveKitting saveKitting =
            return new SaveKitting(
              fgPartNumber: e.kittingEJobDtoList.fgNumber,
              orderId: orderId,
              cablePartNumber: e.kittingEJobDtoList.cableNumber.toString(),
              cableType: "",
              length: e.kittingEJobDtoList.cutLength,
              wireCuttingColor: e.kittingEJobDtoList.cableColor,
              average: 0,
              customerName: "",
              routeMaster: "",
              scheduledQty: 0,
              binId: "",
              binLocation: "",
              bundleQty: 0,
              bundleId:
                  e.selectedBundles.map((e) => e.bundleIdentification).toList(),
            );
          }).toList();
          apiService.postKittingData(saveKitting).then((value) {
            if (value) {
              setState(() {
                loadingSave = false;
              });
            } else {
              log("saved $saveKitting");
              setState(() {
                loadingSave = false;
              });
            }
          });
          // }).toList();

          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: loadingSave
              ? Container(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  children: [
                    Icon(Icons.save),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'save',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
        ));
  }
}

// ignore: must_be_immutable
class ShowBundleList extends StatefulWidget {
  List<BundleMaster> bundleList;
  List<BundleMaster> selectedBundleList;
  String fgNo;
  String cablePartNo;
  String awg;
  Function reload;

  ShowBundleList(
      {required this.reload,
      required this.bundleList,
      required this.selectedBundleList,
      required this.awg,
      required this.cablePartNo,
      required this.fgNo});
  @override
  _ShowBundleListState createState() => _ShowBundleListState();
}

class _ShowBundleListState extends State<ShowBundleList> {
  List<BundleMaster> selBundles = [];

  @override
  void initState() {
    for (BundleMaster b in widget.bundleList) {
      selBundles.add(b);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("selected ${widget.selectedBundleList.length}");
    log("bundle: ${widget.bundleList.length}");

    return AlertDialog(
      title: Container(
        width: 900,
        height: 500,
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  field(title: "Fg No.", data: "${widget.fgNo}", width: 140),
                  field(
                      title: "Cable Part No.",
                      data: "${widget.cablePartNo}",
                      width: 140),
                  field(title: "AWG", data: "${widget.awg}", width: 100),
                  field(
                      title: "Total Qty",
                      data: "${widget.bundleList.length}",
                      width: 100),
                  field(
                      title: "Dispatch Bundles",
                      data: "${widget.selectedBundleList.length}",
                      width: 120),
                  // field(
                  //     title: "Pending Bundles",
                  //     data:
                  //         "${widget.bundleList.length - widget.selectedBundleList.length}",
                  //     width: 120)

                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
            Container(
              width: 800,
              height: 400,
              child: SingleChildScrollView(
                child: DataTable(
                  showCheckboxColumn: true,
                  columnSpacing: 40,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Bundle Id',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      'Bin Id',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataColumn(
                      label: Text(
                        'location ',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Color',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Qty',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: widget.bundleList
                      .map((e) => DataRow(
                              selected: widget.selectedBundleList.contains(e),
                              onSelectChanged: (value) {
                                setState(() {
                                  if (value ?? false) {
                                    widget.selectedBundleList.add(e);
                                  } else {
                                    widget.selectedBundleList.remove(e);
                                  }
                                });
                              },
                              cells: <DataCell>[
                                DataCell(Text(
                                  "${e.bundleIdentification}",
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  "${e.binId}",
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  "${e.locationId}",
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  e.color ?? "",
                                  style: TextStyle(fontSize: 12),
                                )),
                                DataCell(Text(
                                  "${e.bundleQuantity}",
                                  style: TextStyle(fontSize: 12),
                                )),
                              ]))
                      .toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: BorderSide(color: Colors.transparent))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green.shade200;
                        return Colors
                            .green.shade500; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    widget.reload();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget field({String? title, String? data, double? width}) {
    return Container(
      width: width,
      height: 50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title!,
                style:
                    GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 13)),
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(data!,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 15),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class KittingPost {
  KittingEJobDtoList kittingEJobDtoList;
  List<BundleMaster> selectedBundles;
  KittingPost(
      {required this.kittingEJobDtoList, required this.selectedBundles});
}
