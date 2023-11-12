import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/database.dart';

class AlarmSystemWidget extends StatefulWidget {
  late Map state;
  DatabaseService databaseService;
  AlarmSystemWidget({
    required this.state,
    required this.databaseService,
    super.key,
  });

  @override
  State<AlarmSystemWidget> createState() => _AlarmSystemWidgetState();
}

class _AlarmSystemWidgetState extends State<AlarmSystemWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        color: Color.fromARGB(255, 196, 219, 201),
        child: SizedBox(
          width: width - width / 10,
          height: 175,
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: widget.state["state"]["alarm_system"]["alarm"]
                        ? Colors.red
                        : Colors.green,
                    child: SizedBox(
                      width: width - width / 10,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Alarm System",
                            style: TextStyle(
                              fontSize: 12 * width * 0.005,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: SizedBox(
                    width: width - width / 10,
                    height: 125,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          widget.state["state"]["alarm_system"]["alarm"]
                              ? Text(
                                  "Warning!! Alarm is triggered",
                                  style: TextStyle(
                                    fontSize: 12 * width * 0.005,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                )
                              : Text(
                                  "No warnings",
                                  style: TextStyle(
                                    fontSize: 12 * width * 0.005,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              ChoiceChip(
                                selectedColor: Colors.green,
                                backgroundColor: Colors.red,
                                labelStyle: TextStyle(
                                  fontSize: 10 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                                label: SizedBox(
                                  height: 30,
                                  width: (width - width / 3) / 3,
                                  child: const Center(
                                    child: Text(
                                      "Off",
                                    ),
                                  ),
                                ),
                                selected: widget.state["state"]["alarm_system"]
                                        ["state"] ==
                                    "OFF",
                                onSelected: (value) {
                                  var interrupt = "{\"alarm_system\": \"OFF\"}";

                                  widget.databaseService.userInterruptCollection
                                      .doc(widget.databaseService.uid)
                                      .update({"interrupt": interrupt});
                                },
                              ),
                              const Spacer(),
                              ChoiceChip(
                                elevation: 5,
                                selectedColor: Colors.green,
                                backgroundColor: Colors.red,
                                labelStyle: TextStyle(
                                  fontSize: 10 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                                label: SizedBox(
                                  height: 30,
                                  width: (width - width / 3) / 3,
                                  child: const Center(
                                    child: Text(
                                      "Shell",
                                    ),
                                  ),
                                ),
                                selected: widget.state["state"]["alarm_system"]
                                        ["state"] ==
                                    "SHELL",
                                onSelected: (value) {
                                  var interrupt =
                                      "{\"alarm_system\": \"SHELL\"}";

                                  widget.databaseService.userInterruptCollection
                                      .doc(widget.databaseService.uid)
                                      .update({"interrupt": interrupt});
                                },
                              ),
                              const Spacer(),
                              ChoiceChip(
                                elevation: 5,
                                selectedColor: Colors.green,
                                backgroundColor: Colors.red,
                                labelStyle: TextStyle(
                                  fontSize: 10 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                                label: SizedBox(
                                  height: 30,
                                  width: (width - width / 3) / 3,
                                  child: const Center(
                                    child: Text(
                                      "Full",
                                    ),
                                  ),
                                ),
                                selected: widget.state["state"]["alarm_system"]
                                        ["state"] ==
                                    "FULL",
                                onSelected: (value) {
                                  var interrupt =
                                      "{\"alarm_system\": \"FULL\"}";

                                  widget.databaseService.userInterruptCollection
                                      .doc(widget.databaseService.uid)
                                      .update({"interrupt": interrupt});
                                },
                              ),
                              const Spacer(),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
