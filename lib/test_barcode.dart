import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:keyboard_event/keyboard_event.dart';

class MyApp1 extends StatefulWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  String _platformVersion = 'Unknown';
  final List<String> _err = [];
  final List<String> _event = [];
  late KeyboardEvent keyboardEvent;
  int eventNum = 0;
  bool listenIsOn = false;
  List<String> keyPressed = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    keyboardEvent = KeyboardEvent();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    List<String> err = [];
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await KeyboardEvent.platformVersion;
    } on PlatformException {
      err.add('Failed to get platform version.');
    }
    try {
      await KeyboardEvent.init();
    } on PlatformException {
      err.add('Failed to get virtual-key map.');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (platformVersion != null) _platformVersion = platformVersion;
      if (err.isNotEmpty) _err.addAll(err);
    });
  }

  String a = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Test app'),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('platform: $_platformVersion'),
                      Row(
                        children: [
                          Switch(
                            value: listenIsOn,
                            onChanged: (bool newValue) {
                              setState(() {
                                listenIsOn = newValue;
                                if (listenIsOn == true) {
                                  keyboardEvent.startListening((keyEvent) {
                                    setState(() {
                                      eventNum++;
                                      if (keyEvent.vkName == 'ENTER') {
                                        _event.last += '\n';
                                      } else if (keyEvent.vkName == 'BACK') {
                                        _event.removeLast();
                                      }
                                      if (keyEvent.vkName == 'F5') {
                                        _event.clear();
                                      } else {
                                        _event.add(keyEvent.toString());
                                      }
                                      if (_event.length > 20) {
                                        _event.removeAt(0);
                                      }
                                      debugPrint(keyEvent.toString());
                                    });
                                  });
                                } else {
                                  keyboardEvent.cancelListening();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ConstrainedBox(
                          //   constraints: const BoxConstraints.tightFor(width: 200),
                          //   child: Text(
                          //     "key length：$eventNum ${keyboardEvent.state.toString()}\n${_event.join('\n')}",
                          //     overflow: TextOverflow.ellipsis,
                          //     maxLines: 20,
                          //   ),
                          // ),sass

                          Text(
                            "${convert(keyboardEvent.state.toString())}",
                            style: TextStyle(color: Colors.red),
                          ),

                          // Text("message : $a")
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text("message : $keyPressed")),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {});
            convert(keyboardEvent.state.toString());
            initPlatformState();
          },
        ),
      ),
    );
  }
  // String convert(String key){
  //   if(key.length==3){
  //     setState(() {
  //       a=a+key[1];
  //     });

  //   }
  //   return key;

  // }
  List convert(String input) {
    List<String> output = [];
    String o;
    try {
      input = input.replaceAll("[", "");
      input = input.replaceAll("]", "");
      output = input.split(",");

      print("plz $input");
      print("plz1 $output");
      setState(() {
        if (output.length >= 1) {
          for (String item in output) {
            if (item != "") {
              keyPressed.add(item);
            }
          }
        }

        print("plzall $keyPressed");
      });

      return output;
    } catch (err) {
      print('The input is not a string representation of a list');
      return [];
    }
  }
}
