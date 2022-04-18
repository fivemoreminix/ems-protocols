import 'package:firebase_auth/firebase_auth.dart';

const usernameEmailSuffix = 'ghost@emsprotocolsapp.com';

class Utils {
  static bool isAuthUserAnOwner() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return !user.email!.endsWith(usernameEmailSuffix);
  }
}
