enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  emailNotVerified,
  cguNotAccepted,
  unknown,
}

class AuthException {
  static handleException(e) {
    print(e);
    var status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "too-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "email-not-verified":
        status = AuthResultStatus.emailNotVerified;
        break;
      case "cgu-not-accepted":
        status = AuthResultStatus.cguNotAccepted;
        break;
      default:
        status = AuthResultStatus.unknown;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    print(exceptionCode);
    print(AuthResultStatus.cguNotAccepted);
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Le format de l'adresse mail semble incorrect.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Identifiant ou mot de passe incorrect.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "Identifiant ou mot de passe incorrect.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "L'utilisateur de cet email a été désactivé.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Activité suspecte. Réessayez plus tard.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Cette méthode d'authentification n'est pas autorisée.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "Cet email est déjà utilisé. Veuillez vous connecter ou réinitialiser votre mot de passe.";
        break;
      case AuthResultStatus.emailNotVerified:
        errorMessage = "Merci de valider votre email avant de vous connecter.";
        break;
      case AuthResultStatus.cguNotAccepted:
        errorMessage = "Merci d'accepter les conditions d'utilisations.";
        break;
      default:
        errorMessage = "Certaines informations sont incomplètes.";
    }

    return errorMessage;
  }
}
