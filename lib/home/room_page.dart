import 'dart:convert';
import 'package:flutter/material.dart';
import '../functions/lighting_card_widget.dart';
import '../functions/ventillation_card_widget.dart';
import '../functions/blinding_card_widget.dart';
import '../services/auth.dart';
import '../services/database.dart';

class RoomPage extends StatefulWidget {
  final AuthSercice _auth;
  final String name;
  late DatabaseService databaseService;
  Map? room_state;
  RoomPage(this.name, this._auth, {super.key}) {
    databaseService = DatabaseService(uid: _auth.currentUser?.uid);
  }

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Widget> wisgets = <Widget>[];

  Future<Map> lodadData() async {
    var json = await widget.databaseService.getState();
    return jsonDecode(json["state"]);
  }

  loadListWidgets() {
    wisgets = [];
    var functions = widget.room_state!["functions"];
    List function_keys = functions.keys.toList();
    function_keys.forEach((key) {
      if (functions[key]["type"] == "lighting") {
        wisgets.add(LightingCardWidget(key));
      }
      if (functions[key]["type"] == "blinding") {
        wisgets.add(BindingCardWidget(key));
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
                          child: FutureBuilder<Map>(
                            future: lodadData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                widget.room_state = snapshot.data!["state"]
                                    ["rooms"][widget.name];
                                print(widget.room_state);
                                loadListWidgets();
                                return ListView(
                                  children: wisgets,
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
