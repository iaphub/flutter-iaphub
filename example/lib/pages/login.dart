import 'package:flutter/material.dart';
import '../stores/index.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();

  buildLink(String text, Function onClick) {
    return (
      InkWell(
        onTap: () => onClick(),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the login page',
            ),
            SizedBox(height: 30.0),
            buildLink("Login with user id '42'", () => appStore.login("42")),
            SizedBox(height: 30.0),
            buildLink("Login anonymously", () => appStore.login(null)),
          ],
        ),
      )
    );
  }
}