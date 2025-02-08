import 'package:flutter/cupertino.dart';

TextEditingController phoneController = TextEditingController();
String? phoneValidator_;
bool isValid = false;
bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

phoneValidator() {
  if (phoneController.text.isEmpty) {
    phoneValidator_ = "Por favor ingrese su numero";
    isValid = false;
  } else if (phoneController.text.length != 10 ||
      !isNumeric(phoneController.text)) {
    phoneValidator_ = "Ingrese un numero valido";
    isValid = false;
  } else {
    phoneValidator_ = null;
    isValid = true;
  }
}
