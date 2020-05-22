import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';

class Ayuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AYUDA'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿Qué es TuneIT?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'TuneIT es un reproductor de música y podcasts en streaming que te permite compartir canciones/podcasts/listas de reproducción con otros usuarios amigos. También permite la creación de listas de reproducción de canciones, suscribirse a artistas para enterarse de sus últimas canciones y guardar tus podcasts favoritos.',
                    style: TextStyle(fontSize: 13)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('No consigo iniciar sesión, ¿qué hago?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Si no puedes iniciar sesión, puede deberse a que no exista el usuario o que la contraseña sea incorrecta. En el primer caso, registrate con tu correo electrónico para poder iniciar sesión y en el segundo, revisa tu contraseña y vuelve a introducirla.',
                    style: TextStyle(fontSize: 13)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿No te ha llegado el mensaje de confirmación de la cuenta?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Si el registro de la cuenta fue exitoso, se te habrá enviado un correo de confirmación. Revisa tu carpeta de spam/correo no deseado o las carpetas con filtros que tengas.',
                  style: TextStyle(fontSize: 13)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Me voy a vivir a otro país, ¿puedo cambiar el país asignado a mi cuenta?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Sí, desde la configuración del usuario (accesible desde tu perfil) puedes cambiar tu país de residencia por alguno de los disponibles.',
                    style: TextStyle(fontSize: 13)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿Dónde se encuentran las canciones/podcasts/listas que han compartido conmigo?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Desde la pestaña ‘Notificaciones’ puedes mirar todas las canciones/podcasts/listas que tus amigos han compartido contigo. Si se trata de una lista, puedes acceder a ella, escuchar las canciones presentes en ella y añadirla a tus listas.',
                    style: TextStyle(fontSize: 15)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿En dónde puedo usar TuneIT?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'TuneIT se encuentra presente en versión web, accesible para todos los dispositivos con conexión a Internet, y en versión Android para mayor comodidad para usuarios móviles.',
                    style: TextStyle(fontSize: 15)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿Es necesario tener conexión a Internet continuamente?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sí, al reproducirse todas las canciones y podcasts en streaming, es necesario tener Internet para la comunicación con el servidor y obtener las canciones.',
                    style: TextStyle(fontSize: 15)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿Cómo busco a otros usuarios?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Puedes buscar a otros usuarios y agregarlos como amigos desde la pestaña ‘Amigos’ y buscar por el nombre público que tienen. Cuando te acepten como amigo, aparecerá en tu lista de amigos y podrás compartir canciones, podcasts y tus listas de reproducción con él.',
                    style: TextStyle(fontSize: 15)),
              ),
              SizedBox(height: 10,),
              separador(),

              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('¿Puedo eliminar mi cuenta?', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sí, desde la configuración del usuario (accesible desde tu perfil) puedes eliminar tu cuenta introduciendo tu contraseña actual.',
                    style: TextStyle(fontSize: 15)),
              ),
              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }

  Widget separador() {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
          bottomLeft: const Radius.circular(25.0),
          bottomRight: const Radius.circular(25.0),
        ),
        gradient: LinearGradient(
          colors: <Color>[
            ColorSets.colorPink,
            ColorSets.colorButtonPurple,
            ColorSets.colorButtonBlue,
          ],
        ),
      ),
    );
  }

}
