import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'room_page.dart';

class FilledCardExample extends StatelessWidget {
  final AuthSercice _auth;
  final String name;
  final IconData myIcon = Icons.sensor_door_outlined;
  const FilledCardExample(this.name, this._auth, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return RoomPage(name, _auth);
            }),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          color: Color.fromARGB(255, 196, 219, 201),
          child: SizedBox(
            width: width / 2 - (width / 2) / 10,
            height: 100,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: (20 * (13/name.length)) > 25 ? 25 : (20 * (13/name.length)),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    myIcon,
                    size: 50,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
