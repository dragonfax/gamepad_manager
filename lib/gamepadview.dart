
import 'package:flutter/material.dart';
import 'package:flutter_gamepad/flutter_gamepad.dart';
import 'dart:async';

class GamepadViewWidget extends StatefulWidget {
  final int id;

  GamepadViewWidget({this.id});

  createState()  => GamepadViewState();
}

class GamepadViewState extends State<GamepadViewWidget> {
  StreamSubscription<GamepadEvent> _gamepadEventSubscription;
  var events = <String>[];

  @override
  void initState() {
    super.initState();
    _gamepadEventSubscription = FlutterGamepad.eventStream.listen(onGamepadEvent);
  }

  void dispose() { _gamepadEventSubscription.cancel(); super.dispose(); }

  void onGamepadEvent(GamepadEvent e) {
    if (e is GamepadConnectedEvent) {
      // ...
    } else if (e is GamepadDisconnectedEvent) {
      // ...
    } else if (e is GamepadButtonEvent) {
      setState(() {
        events.add(e.toString());
      });
    } else if (e is GamepadThumbstickEvent) {
      setState(() {
        events.add(e.toString());
      });
    } else throw ArgumentError('Unknown event: $e');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ListView(
            children: [
              for ( var event in events )
                ListTile(
                  title: Text(event),
                )
            ]
          ),
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.close)
          )
        ]
    );
  }
}











