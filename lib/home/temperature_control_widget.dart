import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/database.dart';

class TemperatureControl extends StatefulWidget {
  late Map state;
  DatabaseService databaseService;
  TemperatureControl({
    required this.state,
    required this.databaseService,
    super.key,
  });

  @override
  State<TemperatureControl> createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
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
          height: 125,
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
                            "Temperature Control",
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
                    height: 75,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
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
                                  child: Center(child: Text("Off")),
                                ),
                                selected: widget.state["state"]
                                        ["temperature_control"]["state"] ==
                                    "OFF",
                                onSelected: (value) {
                                  var interrupt =
                                      "{\"global_temperature_controll\": \"OFF\"}";

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
                                  child: Center(child: Text("Cooling")),
                                ),
                                selected: widget.state["state"]
                                        ["temperature_control"]["state"] ==
                                    "COOLING",
                                onSelected: (value) {
                                  var interrupt =
                                      "{\"global_temperature_controll\": \"COOLING\"}";

                                  widget.databaseService.userInterruptCollection
                                      .doc(widget.databaseService.uid)
                                      .update({"interrupt": interrupt});

                                  print("COOLING");
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
                                      "Heating",
                                    ),
                                  ),
                                ),
                                selected: widget.state["state"]
                                        ["temperature_control"]["state"] ==
                                    "HEATING",
                                onSelected: (value) {
                                  var interrupt =
                                      "{\"global_temperature_controll\": \"HEATING\"}";

                                  widget.databaseService.userInterruptCollection
                                      .doc(widget.databaseService.uid)
                                      .update({"interrupt": interrupt});

                                  print("HEATING");
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
