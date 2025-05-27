import 'package:cropcure_admin/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyAdmin());
}

class MyAdmin extends StatelessWidget {
  const MyAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: MyLogin(), debugShowCheckedModeBanner: false);
  }
}
