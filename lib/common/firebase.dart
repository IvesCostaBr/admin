import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();

  factory FirebaseService() => _instance;

  FirebaseService._();

  bool _initialized = false;

  Future<void> initialize() async {
    if (!_initialized) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBpoHfeLmh8TgKuZ8k2uT13sst49iO3yeY",
          authDomain: "phantom-dev-tool.firebaseapp.com",
          projectId: "phantom-dev-tool",
          storageBucket: "phantom-dev-tool.appspot.com",
          messagingSenderId: "990619387227",
          appId: "1:990619387227:web:cefa33986171292c09067e",
        ),
      );
      _initialized = true;
    }
  }

  FirebaseApp get app {
    return Firebase.app();
  }
}
