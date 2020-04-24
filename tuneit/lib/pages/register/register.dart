import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/pages/paginaInicial.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/textFields.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  String pais = 'País de nacimiento';

  DateTime _date = DateTime.now();

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      _date = order;
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
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
                        Icons.person),
                    textField(_controller2, false, 'Correo electrónico',
                        Icons.mail_outline),
                    textField(_controller3, true, 'Contraseña',
                        Icons.lock_outline),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: SizedBox(width: 12,),
                            ),
                            Flexible(
                              child: Icon(
                                Icons.place,
                                color: Colors.grey,
                                size: 25,
                              ),
                            ),
                            Flexible(
                              child: SizedBox(width: 15),
                            ),
                            Flexible(
                              flex: 8,
                              child:  countryDrop(),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      color: ColorSets.colorWhite,
                      width: 400,
                      height: 1,
                    ),
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
                                  color: ColorSets.colorGrey,
                                  size: 25,
                                ),
                              ),
                              Flexible(
                                child: SizedBox(width: 15),
                              ),
                              Flexible(
                                flex: 8,
                                child: Text(
                                  _date != null?_date.toString().substring(0,10) : DateTime.now().toString().substring(0,10),
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
                      color: ColorSets.colorWhite,
                      width: 400,
                      height: 1,
                    ),
                    SizedBox(height: 30),
                    solidButton(context, tryRegister, [], 'REGISTRARSE'),
                  ],
                ),
              )
          )
      ),
    );
  }

  void tryRegister () {
    if (_controller1.text.toString().length < 1) {
      mostrarError('Tu nombre de usuario no puede estar vacío');
    }
    else if (_controller2.text.toString().length < 1) {
      mostrarError('Tu correo electrónico no puede estar vacío');
    }
    else if (_controller3.text.toString().length < 1) {
      mostrarError('Tu constraseña no puede estar vacía');
    }
    else if (pais == 'País de nacimiento') {
      mostrarError('Es necesario que indiques tu país de nacimiento');
    }
    else {
      setState(() {
        registerUser(
            _controller1.text, _controller2.text, _controller3.text, parsingDate(_date.toString()), pais
        ).then((value) {
          if (value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          }
          else {
            mostrarError('Ya existe un usuario registrado con tus datos');
          }
        });
      });
    }
  }

  void mostrarError(String description) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(description),
            actions: <Widget>[
              simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
            ],
          );
        }
    );
  }

  Widget countryDrop () {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: Text(pais),
        icon: Icon(null),
        style: TextStyle(
          color: ColorSets.colorText,
          fontSize: 15,
        ),
        onChanged: (String value) {
          setState(() {
            pais = value;
          });
        },
        items: [
          DropdownMenuItem(
            value: 'España',
            child: Text('España'),
          ),
          DropdownMenuItem(
            value: 'Italia',
            child: Text('Italia'),
          ),
          DropdownMenuItem(
            value: 'Portugal',
            child: Text('Portugal'),
          )
        ],
      ),
    );
  }

  String parsingDate (String date) {
    List<String> splited = date.substring(0,10).split('-');
    String year = splited[0];
    String month = splited[1];
    String day = splited[2];

    return month + '/' + day + '/' + year;
  }
}