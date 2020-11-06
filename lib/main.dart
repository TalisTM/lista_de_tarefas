import 'package:flutter/material.dart';
import 'home.dart';

void main(){
  runApp(MaterialApp(
    title: "Lista de Tarefas",
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      shadowColor: Colors.blueGrey[900],
      scaffoldBackgroundColor: Colors.white,
      accentColor: Colors.blueGrey[900],
      appBarTheme: AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.red
        )
      )
    ),
    darkTheme: ThemeData(
      shadowColor: Colors.grey[400],
      accentColor: Colors.grey[400],
      accentColorBrightness: Brightness.light,
      appBarTheme: AppBarTheme(
        color: Colors.grey[400],
        iconTheme: IconThemeData(
          color: Colors.red[100]
        )
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      unselectedWidgetColor: Colors.grey[400]
    ),
  ));
}

