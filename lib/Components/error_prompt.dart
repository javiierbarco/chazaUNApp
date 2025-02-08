import 'package:chazaunapp/view/colors.dart';
import 'package:flutter/material.dart';

void errorPrompt(BuildContext context, String title, String body,
    {double titleSize = 30, double bodySize = 20}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            color: colorPrincipal,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          body,
          style: TextStyle(fontSize: bodySize),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrincipal,
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text("Cerrar",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
