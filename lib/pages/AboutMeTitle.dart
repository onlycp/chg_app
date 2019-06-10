import "package:flutter/material.dart";

class AboutMeTitle extends AboutListTile {
  AboutMeTitle(final title, final content)
      : super(
            icon: FlutterLogo(
              colors: Colors.deepPurple,
              textColor: Colors.grey[900],
            ),
            applicationName: title,
//            applicationVersion: "1.0.1",
//            applicationLegalese: "Apache License 2.0",
            aboutBoxChildren: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Text(
                  content,
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ]);
}
