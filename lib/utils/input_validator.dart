import 'package:string_validator/string_validator.dart';

dynamic validatePersonName(String name) {
  String str = name.trim();
  dynamic validationResult = [true, ""];
  if (str.isEmpty) {
    validationResult[0] = false;
    validationResult[1] = "Empty names not allowed";
  } else if (!isAlpha(str.replaceAll(RegExp(r' '), ""))) {
    validationResult[0] = false;
    validationResult[1] = "Invalid name format";
  }

  return validationResult;
}

dynamic validatePRN(String name) {
  String str = name.trim();
  dynamic validationResult = [true, ""];
  if (str.isEmpty) {
    validationResult[0] = false;
    validationResult[1] = "Empty PRN not allowed";
  } else if (!isNumeric(str)) {
    validationResult[0] = false;
    validationResult[1] = "Invalid PRN format";
  }

  return validationResult;
}

dynamic validatePhoneNumber(String name) {
  String str = name.trim();
  dynamic validationResult = [true, ""];
  if (!isNumeric(str)) {
    validationResult[0] = false;
    validationResult[1] = "Invalid phone number format";
  } else if (str.length != 10) {
    validationResult[0] = false;
    validationResult[1] = "Invalid phone number length";
  }

  return validationResult;
}

dynamic validateEventNameDescriptionVenue(String name) {
  String str = name.trim();
  dynamic validationResult = [true, ""];
  if (str.isEmpty) {
    validationResult[0] = false;
    validationResult[1] = "Empty details not allowed";
  } else if (!isAscii(str)) {
    validationResult[0] = false;
    validationResult[1] = "Invalid details format";
  }

  return validationResult;
}

dynamic validateEmail(String email) {
  String str = email.trim();
  dynamic validationResult = [true, ""];
  if (str.replaceAll(RegExp(r"@sitpune.edu.in"), "").isEmpty) {
    validationResult[0] = false;
    validationResult[1] = "Invalid email format";
  } else if (!contains(str, "@sitpune.edu.in")) {
    validationResult[0] = false;
    validationResult[1] = "Only SITPUNE emails allowed";
  }
  return validationResult;
}

dynamic validatePassword(String pswd) {
  String str = pswd.trim();
  dynamic validationResult = [true, ""];
  if (str.length < 6) {
    validationResult[0] = false;
    validationResult[1] = "Password is too short";
  } else if (!isAscii(str)) {
    validationResult[0] = false;
    validationResult[1] = "Invalid password format";
  }

  return validationResult;
}

dynamic validateBranch(String pswd) {
  String str = pswd.trim();
  dynamic validationResult = [true, ""];
  if (str.isEmpty) {
    validationResult[0] = false;
    validationResult[1] = "You need to pick your branch";
  }

  return validationResult;
}

dynamic getValidation(dynamic validators) {
  for (var i in validators) {
    if (i[0] == false) {
      return i;
    }
  }
  return [true];
}
