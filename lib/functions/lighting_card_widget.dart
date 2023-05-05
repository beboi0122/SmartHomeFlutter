import 'package:flutter/material.dart';

class LightingCardWidget extends StatefulWidget {
  final String name;
  bool lightState = false;
  Text t = const Text(
    "OFF",
    style: TextStyle(
        fontSize: 12 * 400 * 0.005,
        fontWeight: FontWeight.bold,
        color: Colors.red),
  );

  LightingCardWidget(this.name, {super.key});

  @override
  State<LightingCardWidget> createState() => _LightingCardWidgetState();
}

class _LightingCardWidgetState extends State<LightingCardWidget> {
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
          height: 200,
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
                            widget.name,
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
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "Lighting status:",
                                style: TextStyle(
                                  fontSize: 12 * width * 0.005,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              widget.t,
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
                                value: widget.lightState,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      widget.lightState = !widget.lightState;
                                      if (widget.lightState) {
                                        widget.t = const Text(
                                          "ON",
                                          style: TextStyle(
                                              fontSize: 12 * 400 * 0.005,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        );
                                      } else {
                                        widget.t = const Text(
                                          "OFF",
                                          style: TextStyle(
                                              fontSize: 12 * 400 * 0.005,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        );
                                      }
                                    },
                                  );
                                  print(widget.lightState);
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
