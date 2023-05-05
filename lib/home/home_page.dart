import 'package:flutter/material.dart';
import 'package:smart_home_flutter/services/auth.dart';
import 'package:smart_home_flutter/services/database.dart';
import 'room_card_widget.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final AuthSercice _auth;
  late DatabaseService databaseService;
  Map? smart_home_config;
  HomePage(this._auth, {super.key}) {
    databaseService = DatabaseService(uid: _auth.currentUser?.uid);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> wisgets = <Widget>[];

  Future<Map> lodadData() async {
    var json = await widget.databaseService.getConfig();
    return jsonDecode(json["config"]);
  }

  loadListWidgets() {
    wisgets = [];
    List roomKeys = widget.smart_home_config!["rooms"].keys.toList();

    for (var i = 0; i < (roomKeys.length / 2).ceil(); i++) {
      wisgets.add(
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
                            ElevatedButton(
                              onPressed: () async {
                                print(widget.smart_home_config);
                              },
                              child: Text("Test"),
                            ),
                            IconButton(
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
