import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/textFields.dart';

class Profile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState ();
}


class _ProfilePageState extends State<Profile> {

  final TextEditingController _controller1 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
      ),
      drawer: LateralMenu(),
      body: Center(
        child: Container(
          width: 350,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0),
              bottomLeft: const Radius.circular(15.0),
              bottomRight: const Radius.circular(15.0),
            ),
            border: Border.all(color: ColorSets.colorCritical, width: 2),
            color: ColorSets.colorDarkCritical,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                width: 300,
                child: textField(_controller1, true, 'Contraseña', Icons.lock_outline),
              ),
              SizedBox(height: 10,),
              criticalButton(context, tryDelete, [], 'Eliminar cuenta'),
            ],
          ),
        )
      )
    );
  }

  void tryDelete () {
    setState(() {
      deleteUser(Globals.email, _controller1.text).then((value) async {
        if (value) {

          Globals.isLoggedIn = false;
          Globals.email = '';
          Globals.name = '';
          Globals.password = '';
          Globals.date = '';
          Globals.country = '';
          Globals.imagen = '';

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainView()),
          );

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('CUENTA ELIMINADA'),
                  content: Text('Su cuenta ha sido eliminada con éxito'),
                  actions: <Widget>[
                    simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
                  ],
                );
              }
          );
        }
        else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ERROR'),
                  content: Text('Error al eliminar la cuenta'),
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
