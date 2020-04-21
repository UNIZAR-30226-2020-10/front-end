import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/textFields.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();

  DateTime _date = DateTime.now();

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      _date = order;
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
          child: Container(
              width: 350,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Image.asset('assets/LogoAppName.png'),
                    SizedBox(height: 30),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                          bottomLeft: const Radius.circular(25.0),
                          bottomRight: const Radius.circular(25.0),
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF823b8e),
                            Color(0xFF5350a7),
                            Color(0xFF1c4c8b),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    textField(_controller1, false, 'Nombre de usuario',
                        Icons.alternate_email),
                    textField(_controller2, false, 'Correo electrónico',
                        Icons.mail_outline),
                    textField(_controller3, true, 'Contraseña',
                        Icons.lock_outline),
                    textField(_controller4, false, 'País de nacimiento',
                        Icons.place),
                    RaisedButton(
                      color: Colors.transparent,
                      elevation: 0.0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Icon(
                                  Icons.cake,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                              Flexible(
                                child: SizedBox(width: 15),
                              ),
                              Flexible(
                                flex: 8,
                                child: Text(
                                  _date.toString().substring(0,10),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white60,
                                      fontFamily: 'RobotoMono'
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      onPressed: () {
                        callDatePicker();
                      },
                    ),
                    Container(
                      color: Colors.white,
                      width: 400,
                      height: 1,
                    ),
                    SizedBox(height: 30),
                    solidButton(context, tryRegister,
                        [_controller1.text, _controller2.text, _controller3.text,  _controller4.text,  _date.toString()],
                        'REGISTRARSE'),
                  ],
                ),
              )
          )
      ),
    );
  }

  void tryRegister (String nick, String email, String password, String pais, String fecha) {
    setState(() {
      registerUser(
          nick, email, password, pais, fecha
      ).then((value) {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
        else {

        }
      });
    });
  }
}