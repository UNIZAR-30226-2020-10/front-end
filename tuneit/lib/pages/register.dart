import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tuneit/classes/User.dart';

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
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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

                    Container(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    Image.asset('assets/LogoAppName.png'),
                    Container(
                      height: 30,
                      color: Colors.transparent,
                    ),
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
                    Container(
                      height: 30,
                      color: Colors.transparent,
                    ),
                    TextFormField(
                      controller: _controller1,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'RobotoMono'
                      ),
                      decoration: field('Nombre de usuario', Icons.alternate_email),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Este campo no puede estar vacio';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _controller2,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'RobotoMono'
                      ),
                      decoration: field('Correo electrónico', Icons.mail_outline),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Este campo no puede estar vacio';
                        }
                      },
                      /*onSaved: (val) =>
                      setState(() => _user.firstName = val),*/
                    ),
                    TextFormField(
                      controller: _controller3,
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'RobotoMono'
                      ),
                      decoration: field('Contraseña', Icons.lock_outline),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Este campo no puede estar vacio';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _controller4,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'RobotoMono'
                      ),
                      decoration: field('País de nacimiento', Icons.place),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Este campo no puede estar vacio';
                        }
                      },
                    ),
                    RaisedButton(
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            height: 10,
                          ),
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
                                child: Container(
                                  width: 15,
                                  color: Colors.transparent,
                                ),
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
                          Container(
                            color: Colors.transparent,
                            height: 10,
                          ),
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
                    Container(
                      height: 30,
                      color: Colors.transparent,
                    ),
                    RaisedButton(
                        onPressed: () {
                          setState(() {
                            registerUser(
                                _controller1.text, _controller2.text, _controller3.text,  _controller4.text,  _date.toString()
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
                        },
                        color: Colors.transparent,
                        child: SizedBox(
                          height: 50,
                          width: 200.0,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(25.0),
                                    topRight: const Radius.circular(25.0),
                                    bottomLeft: const Radius.circular(25.0),
                                    bottomRight: const Radius.circular(25.0),
                                  ),
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.white, width: 4)
                              ),
                              child: Center(
                                child: Text(
                                    'REGISTRARSE',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontFamily: 'RobotoMono'
                                    )
                                ),
                              )
                          ),
                        )
                    )
                  ],
                ),
              )
          )
      ),
    );
  }
}

InputDecoration field(String text, IconData ic) {
  return InputDecoration(
    hintText: text,
    prefixIcon: Padding(
      padding: EdgeInsets.all(0.0),
      child: Icon(
        ic,
        color: Colors.grey,
      ), // icon is 48px widget.
    ),
    hintStyle: TextStyle(
        fontSize: 15,
        color: Colors.white60,
        fontFamily: 'RobotoMono'
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF5350a7)),
    ),
  );
}