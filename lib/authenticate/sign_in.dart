import 'package:flutter/material.dart';
import 'package:smart_home_flutter/services/auth.dart';
import 'package:validators/validators.dart';

class SignIn extends StatefulWidget {
  final AuthSercice _auth;
  SignIn(this._auth, {super.key});

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passTextController = TextEditingController();

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: const Color.fromARGB(255, 148, 180, 150),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 148, 180, 150),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                SizedBox(
                  height: height / 4,
                  width: width,
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 20 * height * 0.005,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: height - height / 3,
                  width: width,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              50,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                labelText: 'Enter your email',
                                labelStyle: TextStyle(
                                  fontSize: 6 * height * 0.005,
                                ),
                              ),
                              controller: widget.emailTextController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!isEmail(value)) {
                                  return "Please enter a valid email";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              50,
                            ),
                            child: TextFormField(
                              autocorrect: false,
                              decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: 'Enter your password',
                                  labelStyle: TextStyle(
                                    fontSize: 6 * height * 0.005,
                                  )),
                              controller: widget.passTextController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var e = await widget._auth
                                    .signInWithEmailAndPassword(
                                  email: widget.emailTextController.text,
                                  password: widget.passTextController.text,
                                );
                                if (e != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.split("] ")[1],
                                        textAlign: TextAlign.center,
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                Color.fromARGB(255, 72, 95, 73),
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 10 * height * 0.005,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
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
