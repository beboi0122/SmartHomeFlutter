import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference configCollection =
      FirebaseFirestore.instance.collection('configs');

  final CollectionReference stateCollection =
      FirebaseFirestore.instance.collection('states');

  final CollectionReference userInterruptCollection =
      FirebaseFirestore.instance.collection('user_interrupt');

  Future getConfig() async {
    //return await configCollection.doc(uid).get();
    var snapshot = await configCollection.doc(uid).get();

    return snapshot.data();
  }

  Future getState() async {
    //return await configCollection.doc(uid).get();
    var snapshot = await stateCollection.doc(uid).get();

    return snapshot.data();
  }
}
