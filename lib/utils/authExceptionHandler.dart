import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  userDisabled,
  userNotFound,
  tooManyRequests,
  userTokenExpired,
  networkRequestFailed,
  invalidCredentials,
  operationNotAllowed,
  missingAndroidPackageName,
  missingContinueUri,
  missingIOSBundleId,
  invalidContinueUri,
  unauthorizedContinueUri,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
      case "invalid-credential":
      case "INVALID_LOGIN_CREDENTIALS":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "user-disabled":
        status = AuthStatus.userDisabled;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      case "too-many-requests":
        status = AuthStatus.tooManyRequests;
        break;
      case "user-token-expired":
        status = AuthStatus.userTokenExpired;
        break;
      case "network-request-failed":
        status = AuthStatus.networkRequestFailed;
        break;
      case "operation-not-allowed":
        status = AuthStatus.operationNotAllowed;
        break;
      case "auth/missing-android-pkg-name":
        status = AuthStatus.missingAndroidPackageName;
        break;
      case "auth/missing-continue-uri":
        status = AuthStatus.missingContinueUri;
        break;
      case "auth/missing-ios-bundle-id":
        status = AuthStatus.missingIOSBundleId;
        break;
      case "auth/invalid-continue-uri":
        status = AuthStatus.invalidContinueUri;
        break;
      case "auth/unauthorized-continue-uri":
        status = AuthStatus.unauthorizedContinueUri;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      case AuthStatus.userDisabled:
        errorMessage = "This user has been disabled.";
        break;
      case AuthStatus.userNotFound:
        errorMessage = "No user found with this email.";
        break;
      case AuthStatus.tooManyRequests:
        errorMessage = "Too many requests. Please try again later.";
        break;
      case AuthStatus.userTokenExpired:
        errorMessage = "Session has expired. Please log in again.";
        break;
      case AuthStatus.networkRequestFailed:
        errorMessage = "Network error. Please check your connection.";
        break;
      case AuthStatus.operationNotAllowed:
        errorMessage =
            "This operation is not allowed. Please enable email/password sign-in in the Firebase Console.";
        break;
      case AuthStatus.missingAndroidPackageName:
        errorMessage = "An Android package name must be provided.";
        break;
      case AuthStatus.missingContinueUri:
        errorMessage = "A continue URL must be provided.";
        break;
      case AuthStatus.missingIOSBundleId:
        errorMessage = "An iOS Bundle ID must be provided.";
        break;
      case AuthStatus.invalidContinueUri:
        errorMessage = "The continue URL provided is invalid.";
        break;
      case AuthStatus.unauthorizedContinueUri:
        errorMessage = "The domain of the continue URL is not whitelisted.";
        break;
      default:
        errorMessage = "An error occurred. Please try again later.";
    }
    return errorMessage;
  }
}
