import 'package:firebase_auth/firebase_auth.dart';

const usernameEmailSuffix = 'ghost@emsprotocolsapp.com';

class Utils {
  /// isAuthUserAnOwner returns true if the email field does not end with
  /// 'ghost@emsprotocolsapp.com'.
  static bool isAuthUserAnOwner() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    // Asserting email is not null because an account can only be opened with email and password.
    return !user.email!.endsWith(usernameEmailSuffix);
  }
}
