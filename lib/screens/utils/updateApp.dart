// https://diamondpowersolutions.com/19-6-1%20TAB.apk
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UpdateApp extends StatefulWidget {
  const UpdateApp({Key? key}) : super(key: key);

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  bool downloading = false;
  String ? progressString = "";
  double ? progessdouble = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      var dir = await getExternalStorageDirectory();
      await dio.download(
        "https://diamondpowersolutions.com/19-6-1%20TAB.apk",
        "${dir!.path}/newapk.apk}",
        onReceiveProgress: (count, total) {
          log("rec: $count , Total : $total");
          setState(() {
            downloading = true;
            progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
            progessdouble = (count / total);
          });
        },
      );
      // OpenFile.open("${dir.path}/newapk.apk}");

      log('');
      log('');
    } catch (e) {}

    setState(() {
      downloading = false;
      progressString = "completed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Update App",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text("A new Update is Available"),
            ),
          ),
          Center(
            child: downloading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                value: progessdouble,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text("Downloading Update  $progressString")
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red.shade100;
                            return Colors
                                .red.shade500; // Use the component's default.
                          },
                        ),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.red;
                            return Colors
                                .green.shade500; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        downloadFile();
                      },
                      child: Text("Download"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
