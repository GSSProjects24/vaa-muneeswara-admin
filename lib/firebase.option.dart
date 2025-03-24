import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: "AIzaSyBK6JS6V3_QxP5YlFGtn5Qrw_enKefffUs",
        authDomain: "vaa-muneeswara.appspot.com",
        projectId: "vaa-muneeswara",
        storageBucket: "vaa-muneeswara.appspot.com",
        messagingSenderId: "893288310175",
        appId: "1:893288310175:android:76bb4ea7304661d22549aa",
        measurementId: "G-C287VVB89N",
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return FirebaseOptions(
        apiKey: "AIzaSyBK6JS6V3_QxP5YlFGtn5Qrw_enKefffUs",
        projectId: "vaa-muneeswara",
        storageBucket: "vaa-muneeswara.appspot.com",
        messagingSenderId: "893288310175",
        appId: "1:893288310175:android:76bb4ea7304661d22549aa",
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return FirebaseOptions(
        apiKey: "AIzaSyBK6JS6V3_QxP5YlFGtn5Qrw_enKefffUs",
        projectId: "vaa-muneeswara",
        storageBucket: "vaa-muneeswara.appspot.com",
        messagingSenderId: "893288310175",
        appId: "1:893288310175:android:76bb4ea7304661d22549aa",
        iosBundleId: "your.ios.bundle.id",
      );
    }
    throw UnsupportedError('This platform is not supported');
  }
}
