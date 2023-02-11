import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'stores/index.dart';
import 'pages/login.dart';
import 'pages/store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IAPHUB Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Observer(
            builder: (_) => appStore.isLogged ? StorePage() : LoginPage()
          ),
          Observer(
            builder: (_) {
              if (appStore.alert != null) {
                return AlertDialog(
                  title: Text("Alert"),
                  content: Text(appStore.alert ?? ""),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        appStore.closeAlert();
                      },
                    ),
                  ],
                );
              }
              else {
                return Container();
              }
            }
          )
        ]
      )
    );
  }
}