import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'stores/index.dart';
import 'pages/login.dart';
import 'pages/store.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'IAPHUB Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Observer(
          builder: (_) =>
              appStore.isLogged ? const StorePage() : const LoginPage()),
      Observer(builder: (_) {
        if (appStore.alert != null) {
          return AlertDialog(
            title: const Text("Alert"),
            content: Text(appStore.alert ?? ""),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  appStore.closeAlert();
                },
              ),
            ],
          );
        } else {
          return Container();
        }
      })
    ]));
  }
}
