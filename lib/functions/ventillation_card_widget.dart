import 'package:flutter/material.dart';

import '../services/database.dart';

class VentillationCardWidget extends StatefulWidget {
  final String roomName;
  late Map roomState;
  DatabaseService databaseService;
  VentillationCardWidget(
      {required this.roomName,
      required this.roomState,
      required this.databaseService,
      super.key});

  @override
  State<VentillationCardWidget> createState() => _VentillationCardWidgetState();
}

class _VentillationCardWidgetState extends State<VentillationCardWidget> {
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
                            "Ventillation",
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
                                "Humidity:",
                                style: TextStyle(
                                  fontSize: 12 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                widget.roomState["state"]["rooms"]
                                        [widget.roomName]["humidity"]
                                    .toString(),
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
                                "Target humidity:",
                                style: TextStyle(
                                  fontSize: 12 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              DropdownButton<String>(
                                menuMaxHeight: 300,
                                isDense: true,
                                value: widget.roomState["state"]["rooms"]
                                        [widget.roomName]["target_humidity"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 12 * width * 0.005,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                items: List<String>.generate(
                                        60, (i) => (i + 20).toString())
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  var interrupt =
                                      "{ \"room\": \"${widget.roomName}\", \"target_humidity\": \"${int.parse(value!)}\"}";
                                  widget.databaseService.userInterruptCollection
                                      .doc(widget.databaseService.uid)
                                      .update({"interrupt": interrupt});
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
