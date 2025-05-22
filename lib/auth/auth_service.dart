import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<User?> signIn(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    await _storage.write(key: 'email', value: email);
    return userCred.user;
  }

  Future<User?> signUp(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _storage.write(key: 'email', value: email);
    return userCred.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _storage.deleteAll();
  }
}
