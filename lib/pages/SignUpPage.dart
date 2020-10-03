import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _toggleVisibility = true;
  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: " Your email or username",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0)),
    );
  }

  Widget _buildPassWordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          hintText: " Your Password",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _toggleVisibility = !_toggleVisibility;
              });
            },
            icon: _toggleVisibility
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
          )),
      obscureText: _toggleVisibility,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Center(
          child: Text("Sign Up",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Forgotten Password ?",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                _buildEmailTextField(),
                _buildPassWordTextField(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Don't have an account ?",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            GestureDetector(
                onTap: () {},
                child: Text("Sign In ",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold))),
          ],
        )
      ],
    ));
  }
}
