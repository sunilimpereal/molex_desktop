import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:molex_desktop/model_api/crimping/getCrimpingSchedule.dart';
import 'package:molex_desktop/model_api/fgDetail_model.dart';
import 'package:molex_desktop/service/api_service.dart';


class P2ScheduleDetailWIP extends StatefulWidget {
  CrimpingSchedule schedule;

  P2ScheduleDetailWIP({required this.schedule});
  @override
  _P2ScheduleDetailWIPState createState() => _P2ScheduleDetailWIPState();
}

class _P2ScheduleDetailWIPState extends State<P2ScheduleDetailWIP> {
  late ApiService apiService;
  @override
  void initState() {
    apiService = ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        clipBehavior: Clip.antiAlias, // Add This
        shadowColor: Colors.white70,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 95,
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                scheduleDetail(),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 0,
                ),
                Container(child: fGTable()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget feild({String ? heading, String ? value, double ? width}) {
    width = MediaQuery.of(context).size.width * width!;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        // color: Colors.red.shade100,
        width: width,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  heading!,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.normal,
                  )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                children: [
                  Text(
                    value ?? '',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget scheduleDetail() {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red.shade50,
              ),
              width: 22,
              height: 22,
              child: Center(child: Image.asset('assets/image/order.png')),
            ),
            feild(
                heading: "Order Id",
                value: '${widget.schedule.purchaseOrder}',
                width: 0.1),
            feild(
                heading: "FG Part",
                value: '${widget.schedule.finishedGoods}',
                width: 0.1),
            feild(
                heading: "Schedule ID",
                value: '${widget.schedule.scheduleId}',
                width: 0.1),
            feild(
                heading: "Cable Part No.",
                value: '${widget.schedule.cablePartNo}',
                width: 0.12),
            feild(
                heading: "Process",
                value: '${widget.schedule.process}',
                width: 0.12),
                  feild(
                heading: "Cable #",
                value: '${widget.schedule.cableNumber}',
                width: 0.06),
            feild(
                heading: "Cut Length",
                value: '${widget.schedule.length}',
                width: 0.08),
            feild(heading: "Color", value: '${widget.schedule.wireColour}', width: 0.08),
            feild(
                heading: "Scheduled Qty",
                value: '${widget.schedule.plannedQuantity}',
                width: 0.1),
         feild(heading: "Date", value:  widget.schedule.scheduleDate==null?"": DateFormat("dd-MM-yyyy").format(widget.schedule.scheduleDate??DateTime.now()), width: 0.1)
          ],
        ));
  }

  Widget fGTable() {
    Widget boxes(
      String ? str1,
      String ? str2,
    ) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          // color: Colors.grey.shade200,
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              str1!,
              style: TextStyle(fontSize: 10),
            ),
            Text(str2!,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: Colors.black)),
          ]),
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder(
            future:
                apiService.getFgDetails(widget.schedule.finishedGoods.toString()),
            builder: (context, snapshot) {
              print('fg number ${widget.schedule.finishedGoods}');
              FgDetails fgDetail = snapshot.data as FgDetails;
              if (snapshot.hasData) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    // color: Colors.grey.shade200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          feild(
                              heading: "FG Description",
                              value: fgDetail.fgDescription,
                              width: 0.33),
                          feild(
                              heading: "FG Scheduled Date",
                              value: fgDetail.fgScheduleDate,
                              width: 0.12),
                          feild(
                              heading: "Customer",
                              value: fgDetail.customer,
                              width: 0.15),
                          feild(heading: "Drg Rev", value:fgDetail.drgRev, width: 0.05),
                          feild(
                              heading: "Cable Serial No",
                              value: fgDetail.cableSerialNo.toString() ,
                              width: 0.09),
                          feild(
                              heading: 'Tolerance ',
                              value: '${fgDetail.tolrance}',
                              width: 0.1),
                        ]));
              } else {
                return Container();
              }
            }));
  }
}
