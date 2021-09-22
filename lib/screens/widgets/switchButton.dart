import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef OnToggle = void Function(int? index);

class SwitchButton extends StatefulWidget {
  // function return 0 or 1 based on index of option
  final OnToggle? onToggle;

  ///list of sting with options max 2
  List<String?>? options;
  SwitchButton({
    this.onToggle,
    this.options,
  });

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  int? index = 0;
  @override
  void initState() {
    index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 38,
        width: 178,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment:
                  index == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                Material(
                  elevation: 2,
                  shadowColor: Colors.red.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)),
                  child: Container(
                    width: 85,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onPanUpdate: (details) {
                      if (details.delta.dx > 0)
                        setState(() {
                          index = 1;
                          widget.onToggle!(index);
                        });
                    },
                    onTap: () {
                      setState(() {
                        index = 0;
                        widget.onToggle!(index);
                      });
                    },
                    child: Container(
                      width: 85,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text('${widget.options![0]}',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontWeight: index == 0
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: index == 0
                                      ? Colors.red.shade500
                                      : Colors.red.shade400,
                                  fontSize: 14),
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onPanUpdate: (details) {
                      if (details.delta.dx > 0)
                        print("Dragging in +X direction");
                      else
                        setState(() {
                          index = 0;
                          widget.onToggle!(index);
                        });
                    },
                    onTap: () {
                      setState(() {
                        index = 1;
                        widget.onToggle!(index);
                      });
                    },
                    child: Container(
                      width: 85,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          '${widget.options![1]}',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontWeight: index == 1
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: index == 1
                                    ? Colors.red.shade500
                                    : Colors.red.shade400,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
//emu-m/c-004n(cb14)
