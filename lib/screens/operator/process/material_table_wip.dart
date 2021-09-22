import 'package:flutter/material.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/service/api_service.dart';


class MaterialtableWIP extends StatefulWidget {
  MatTrkPostDetail matTrkPostDetail;
  MaterialtableWIP({Key? key, required this.matTrkPostDetail})
      : super(key: key);

  @override
  _MaterialtableWIPState createState() => _MaterialtableWIPState();
}

class _MaterialtableWIPState extends State<MaterialtableWIP> {
  @override
  Widget build(BuildContext context) {
    return materialtable();
  }

  Widget materialtable() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: table1(),
    );
  }

  Widget table1() {
    return Material(
      elevation: 2,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.transparent)),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            tableHeading(),
            tableData(),
          ],
        ),
      ),
    );
  }

  Widget tableHeading() {
    Widget cell(String title, double width) {
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          width: MediaQuery.of(context).size.width * width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            // color: Colors.red[50],
          ),
          padding: EdgeInsets.all(2),
          child: Center(
              child: Text(
            "$title",
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: Colors.transparent)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
              color: Colors.red[500],
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cell("Part No.", 0.08),
              cell("UOM", 0.05),
              cell("Required", 0.06),
              cell("Loaded", 0.06),
              cell("Available", 0.06)
            ],
          ),
        ),
      ),
    );
  }

  Widget tableData() {
    Widget row(
        {required String partNo,
        required String uom,
        required String require,
        required String loaded,
        required String available}) {
      Widget cell(String title, double width) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: MediaQuery.of(context).size.width * width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: Colors.white),
            padding: EdgeInsets.all(5),
            child: Center(
                child: Text(
              "$title",
              style: TextStyle(fontSize: 14,fontFamily: fonts.openSans),
            )),
          ),
        );
      }

      return Container(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cell(partNo, 0.08),
            cell(uom, 0.05),
            cell(require, 0.06),
            cell(loaded, 0.06),
            cell(available, 0.06),
          ],
        ),
      );
    }

    ApiService apiService =  ApiService();
    return FutureBuilder(
        future:
            apiService.getMaterialTrackingCableDetail(widget.matTrkPostDetail),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MaterialDetail>? matList =
                snapshot.data as List<MaterialDetail>?;

            if (matList!.length > 0) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 100,
                child: ListView.builder(
                    itemCount: matList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return row(
                        partNo: "${matList[index].cablePartNo}",
                        uom: "${matList[index].uom.toString()}",
                        require: "${matList[index].requiredQty.toString()}",
                        loaded: "${matList[index].loadedQty.toString()}",
                        available: "${matList[index].availableQty.toString()}",
                      );
                    }),
              );
            } else {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 100,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "no stock found",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ));
            }
          } else {
            return Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 100,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "no stock found",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ));
          }
        });
  }
}
