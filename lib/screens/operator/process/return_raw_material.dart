import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molex_desktop/main.dart';
import 'package:molex_desktop/model_api/machinedetails_model.dart';
import 'package:molex_desktop/model_api/materialTrackingCableDetails_model.dart';
import 'package:molex_desktop/model_api/postReturnMaterial.dart';
import 'package:molex_desktop/model_api/postReturnMaterial.dart';
import 'package:molex_desktop/model_api/postReturnMaterial.dart';
import 'package:molex_desktop/model_api/postrawmatList_model.dart';
import 'package:molex_desktop/screens/operator/process/material_table_wip.dart';
import 'package:molex_desktop/screens/widgets/loading_button.dart';
import 'package:molex_desktop/service/api_service.dart';




Future<void> showReturnMaterial(BuildContext context,
    MatTrkPostDetail matTrkPostDetail, MachineDetails machineDetails) async {
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
          child: ReturnRawmaterial(
        matTrkPostDetail: matTrkPostDetail,
        machineDetails: machineDetails,
      ));
    },
  );
}

class ReturnRawmaterial extends StatefulWidget {
  MatTrkPostDetail matTrkPostDetail;
  MachineDetails machineDetails;
  ReturnRawmaterial({Key? key, required this.matTrkPostDetail, required this.machineDetails})
      : super(key: key);

  @override
  _ReturnRawmaterialState createState() => _ReturnRawmaterialState();
}

class _ReturnRawmaterialState extends State<ReturnRawmaterial> {
  late ApiService apiService;
  bool loading = false;
  @override
  void initState() {
    apiService = new ApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.all(10),
        title: Stack(
          children: [
            Container(
              height: 300,
              width: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialtableWIP(
                    matTrkPostDetail: widget.matTrkPostDetail,
                  ),
                  returnMaterialButtons(),
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red[400],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ))
          ],
        ));
  }

  Widget returnMaterialButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: apiService
              .getMaterialTrackingCableDetail(widget.matTrkPostDetail),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                 List<MaterialDetail> matList = snapshot.data as List<MaterialDetail>;
               var postReturnMaterial = PostReturnMaterial(
                  machineIdentification: "${widget.machineDetails.machineNumber}",
                  partNumberList: matList.map((e) {
                    return Part(
                      partNumbers: int.parse("${e.cablePartNo}"),
                      usedQuantity: int.parse("${e.availableQty}"),
                      traceabilityNumber: getTraceabilityNumber("${e.cablePartNo}"),
                    );
                  }).toList());
                  
              log("message ${postReturnMaterialToJson(postReturnMaterial)} ");


              if (matList.length > 0) {
                 
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LoadingButton(
                          loading: loading,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.green),
                          ),
                          loadingChild: Container(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Return Material",style: TextStyle(fontFamily: fonts.openSans,fontSize: 18),),
                          ),
                          onPressed: () {
                            apiService
                                .postreturnRawMaterial(postReturnMaterial);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
    );
  }

  String getTraceabilityNumber(String partNumber) {
    for (PostRawMaterial material
        in widget.matTrkPostDetail?.selectedRawMaterial??[]) {
      if (material.cablePartNumber.toString() == partNumber) {
        return material.traceabilityNumber??'';
      }
    }
    return "";
  }

 
}
