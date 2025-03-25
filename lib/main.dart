import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vaa_muneeswara_admin/UI/Dashboard/dashboard.dart';
import 'package:vaa_muneeswara_admin/firebase.option.dart';
import 'Style and Color/app_color.dart';
import 'UI/Authentication/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth.instance.setLanguageCode('en');
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  await GetStorage.init();

  final box = GetStorage();
  bool isLoggedIn = box.read('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vaa Muneeswara Admin',
      theme: AppTheme.orangeTheme,
      home: isLoggedIn ? Dashboard() : Login(),
    );
  }
}
