import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_home_flutter/home/alarm_system_widget.dart';
import 'package:smart_home_flutter/home/temperature_control_widget.dart';
import 'package:smart_home_flutter/services/auth.dart';
import 'package:smart_home_flutter/services/database.dart';
import 'room_card_widget.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final AuthSercice _auth;
  late DatabaseService databaseService;
  late final Stream<QuerySnapshot> _statusStream;
  late Map state;
  Map? smart_home_config;
  HomePage(this._auth, {super.key}) {
    databaseService = DatabaseService(uid: _auth.currentUser?.uid);
    databaseService = DatabaseService(uid: _auth.currentUser?.uid);
    _statusStream = databaseService.stateCollection.snapshots();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> widgets = <Widget>[];

  Future<Map> lodadData() async {
    var json = await widget.databaseService.getConfig();
    return jsonDecode(json["config"]);
  }

  loadListWidgets(double width) {
    widgets = [];

    if (widget.state["state"].containsKey("alarm_system")) {
      widgets.add(AlarmSystemWidget(
        state: widget.state,
        databaseService: widget.databaseService,
      ));
    }

    widgets.add(TemperatureControl(
      state: widget.state,
      databaseService: widget.databaseService,
    ));

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Rooms",
            style: TextStyle(
              fontSize: 20 * width * 0.005,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ));

    List roomKeys = widget.smart_home_config!["rooms"].keys.toList();

    for (var i = 0; i < (roomKeys.length / 2).ceil(); i++) {
      widgets.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledCardExample(roomKeys[i * 2], widget._auth),
                if ((i * 2) + 1 < roomKeys.length)
                  FilledCardExample(roomKeys[i * 2 + 1], widget._auth),
              ],
            )
          ],
        ),
      );
    }
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
                                widget._auth.signOut();
                              },
                              icon: const Icon(
                                Icons.exit_to_app,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "SmartHome",
                          style: TextStyle(
                            fontSize: 20 * width * 0.005,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.home,
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
                      color: Color.fromARGB(255, 86, 107, 88),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: FutureBuilder<Map>(
                            future: lodadData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                widget.smart_home_config =
                                    snapshot.data!["smart_home_config"];
                                return StreamBuilder<QuerySnapshot>(
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
                                    widget.state = jsonDecode(snapshot
                                        .data!.docs
                                        .map((DocumentSnapshot document) {
                                      return (document.data()!
                                          as Map<String, dynamic>)["state"];
                                    }).first);
                                    print("widget.state");
                                    loadListWidgets(width);

                                    return ListView(
                                      children: widgets,
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
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
