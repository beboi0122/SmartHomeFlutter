import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_home_flutter/functions/room_temperature_control.dart';
import '../functions/lighting_card_widget.dart';
import '../functions/ventillation_card_widget.dart';
import '../functions/blinding_card_widget.dart';
import '../functions/eletric_door_card_widget.dart';
import '../services/auth.dart';
import '../services/database.dart';

class RoomPage extends StatefulWidget {
  final AuthSercice _auth;
  final String name;
  late DatabaseService databaseService;
  late final Stream<QuerySnapshot> _statusStream;
  late Map room_state;
  RoomPage(this.name, this._auth, {super.key}) {
    databaseService = DatabaseService(uid: _auth.currentUser?.uid);
    _statusStream = databaseService.stateCollection.snapshots();
  }

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Widget> widgets = <Widget>[];

  loadListWidgets() {
    widgets = [];
    if (widget.room_state["state"]["rooms"][widget.name]
            .containsKey("temperature") &&
        widget.room_state["state"]["rooms"][widget.name]
            .containsKey("humidity")) {
      if (widget.room_state["state"]["rooms"][widget.name]
          .containsKey("target_temperature")) {
        widgets.add(
          RoomTemperatureControl(
              roomName: widget.name,
              roomState: widget.room_state,
              databaseService: widget.databaseService),
        );
      }
      if (widget.room_state["state"]["rooms"][widget.name]
          .containsKey("target_humidity")) {
        widgets.add(
          VentillationCardWidget(
              roomName: widget.name,
              roomState: widget.room_state,
              databaseService: widget.databaseService),
        );
      }
    }
    var functions =
        widget.room_state["state"]["rooms"][widget.name]["functions"];
    List function_keys = functions.keys.toList();
    function_keys.forEach((key) {
      if (functions[key]["type"] == "lighting") {
        widgets.add(LightingCardWidget(
          roomName: widget.name,
          lightingName: key,
          roomState: widget.room_state,
          databaseService: widget.databaseService,
        ));
      }
      if (functions[key]["type"] == "blinding") {
        widgets.add(BindingCardWidget(
          roomName: widget.name,
          bindingName: key,
          roomState: widget.room_state,
          databaseService: widget.databaseService,
        ));
      }
      if (functions[key]["type"] == "electric_door") {
        widgets.add(EletricDoorCardWidget(
            roomName: widget.name,
            doorName: key,
            roomState: widget.room_state,
            databaseService: widget.databaseService));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: const Color.fromARGB(255, 148, 180, 150),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 148, 180, 150),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: width,
                  height: height / 3 - 100,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              iconSize: 8 * height * 0.005,
                              onPressed: () {
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.refresh,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              iconSize: 8 * height * 0.005,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.home,
                              ),
                            )
                          ],
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 20 * width * 0.005,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.sensor_door_outlined,
                          size: height * 0.1,
                        )
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    width: width,
                    height: height - height / 3,
                    child: Container(
                      color: const Color.fromARGB(255, 86, 107, 88),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: widget._statusStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              widget.room_state = jsonDecode(snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                return (document.data()!
                                    as Map<String, dynamic>)["state"];
                              }).first);
                              loadListWidgets();
                              return ListView(
                                children: widgets,
                              );
                            },
                          ),
                        ),
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
