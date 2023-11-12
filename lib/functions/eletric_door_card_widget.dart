import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/database.dart';

class EletricDoorCardWidget extends StatefulWidget {
  final String roomName;
  final String doorName;
  late bool switchState;
  late Map roomState;
  DatabaseService databaseService;

  EletricDoorCardWidget(
      {required this.roomName,
        required this.doorName,
        required this.roomState,
        required this.databaseService,
        super.key}) {
    switchState = roomState["state"]["rooms"][roomName]["functions"]
    [doorName]["state"];
  }

  @override
  State<EletricDoorCardWidget> createState() => _EletricDoorCardWidgetState();
}

class _EletricDoorCardWidgetState extends State<EletricDoorCardWidget> {
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
          height: 150,
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: const Color.fromARGB(255, 159, 174, 162),
                    child: SizedBox(
                      width: width - width / 10,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.doorName,
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
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "Door status:",
                                style: TextStyle(
                                  fontSize: 12 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                widget.roomState["state"]["rooms"]
                                [widget.roomName]["functions"]
                                [widget.doorName]["state"]
                                    ? "Open"
                                    : "Closed",
                                style: TextStyle(
                                  fontSize: 12 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "Switch:",
                                style: TextStyle(
                                  fontSize: 12 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: widget.switchState,
                                onChanged: (value) {
                                  setState(
                                        () {
                                      widget.switchState = !widget.switchState;
                                      var interrupt =
                                          "{ \"room\": \"${widget.roomName}\", \"function\": \"${widget.doorName}\", \"state\": ${widget.switchState}}";

                                      widget.databaseService
                                          .userInterruptCollection
                                          .doc(widget.databaseService.uid)
                                          .update({"interrupt": interrupt});
                                    },
                                  );
                                },
                              )
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
