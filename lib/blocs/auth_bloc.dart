import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_roomie/services/auth_service.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;

  loginGoogle() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final result = await authService.signInWithCredential(credential);

      print('${result.user.displayName}');
      print(result.user.uid);

      final user = await users.doc(result.user.uid).get();

      if (user == null || !user.exists) {
        users.doc(result.user.uid)
            .set({
              'full_name': result.user.displayName, // John Doe
              'email': result.user.email
            })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    } catch (e) {
      print(e);
    }
  }

  logout() {
    authService.logout();
  }
}
