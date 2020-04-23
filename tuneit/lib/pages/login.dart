import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/pages/playlists.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/textFields.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Future<User> _futureUser;
  //final _user = User();
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
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 16.0),
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
                    textField(_controller1, false, 'Correo electrónico',
                        Icons.mail_outline),
                    textField(_controller2, true, 'Contraseña',
                        Icons.lock_outline),
                    SizedBox(height: 100),
                    solidButton(context, tryLogin, [], 'ENTRAR'),
                  ],
                ),
              )
          )
      ),
    );
  }

  void tryLogin () {
    setState(() {
      fetchUser(_controller1.text, _controller2.text).then((value) {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlayLists(true)),
          );
        }
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ERROR'),
                content: Text('El email y/o la contraseña introducidos son incorrectos'),
                actions: <Widget>[
                  simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
                ],
              );
            }
          );
        }
      });
    });
  }

}
