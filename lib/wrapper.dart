import 'package:flutter/material.dart';
import 'package:smart_home_flutter/authenticate/sign_in.dart';
import 'package:smart_home_flutter/home/home_page.dart';
import 'package:smart_home_flutter/services/auth.dart';

class Wrapper extends StatelessWidget {
  Wrapper({super.key});
  final AuthSercice _auth = AuthSercice();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthSercice().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage(_auth);
        } else {
          return SignIn(_auth);
        }
      },
    );
  }
}
