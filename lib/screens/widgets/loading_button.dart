import 'dart:developer';

import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  ButtonStyle style;
  bool loading;
  Widget child;
  Widget loadingChild;
  Function onPressed;

  LoadingButton(
      {Key? key,
      required this.style,
      required this.child,
      required this.loading,
      required this.loadingChild,
      required this.onPressed})
      : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? ElevatedButton(
            style: widget.style, onPressed: () {}, child: widget.loadingChild)
        : ElevatedButton(
            style: widget.style,
            onPressed: () {
              setState(() {
                widget.loading = true;
              });
           bool a = widget.onPressed();
           log("a : $a");
           if(a){
                  setState(() {
                widget.loading = false;
              });
           }
             
            },
            child: widget.child);
  }
}
