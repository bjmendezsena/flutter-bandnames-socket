import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('ServerStatus: ${socketService.serverStatus}'),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () => sendMessage(socketService, context),
      ),
    );
  }

  sendMessage(SocketService socketService, BuildContext context) {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      //Me dice si es android, windows, linux o iphone
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mensaje:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('enviar'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () =>
                    enviarMensaje(context, textController.text, socketService),
              )
            ],
          );
        },
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New band name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () =>
                    enviarMensaje(context, textController.text, socketService),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  void enviarMensaje(
      BuildContext context, String mensaje, SocketService socketService) {
    print('Mensaje: ' + mensaje);
    if (mensaje.length > 1) {
      socketService.socket.emit('emitir-mensaje', mensaje);
    }

    Navigator.pop(context);
  }
}
