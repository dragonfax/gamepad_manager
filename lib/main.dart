import 'package:flutter/material.dart';
import 'package:flutter_gamepad/flutter_gamepad.dart';
import 'gamepadview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var gamepadsFuture;

  static const reloadTime = Duration(seconds: 5);

  _MyHomePageState() {
    reload();
  }

  reload() {
    setState(() {
      gamepadsFuture = FlutterGamepad.gamepads();
    });

    // refresh in at least 5 seconds
    var started = DateTime.now();
    gamepadsFuture.then(() {
      var timeSpent = DateTime.now().difference(started);
      var timeLeft = reloadTime - timeSpent;
      Future.delayed(timeLeft, () {
        reload();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<GamepadInfo>>(
          future: gamepadsFuture,
          builder: (BuildContext context, AsyncSnapshot<List<GamepadInfo>> snapshot) {
            if ( snapshot.hasData ) {
              return ListView(
                children: [
                 for ( var gamepad in snapshot.data )
                   ListTile(
                     title: Text(gamepad.vendorName),
                     subtitle: Text(gamepad.toString()),
                     onTap: () {
                       Navigator.push(context, MaterialPageRoute( builder: (context) {
                         return GamepadViewWidget(id: gamepad.id);
                       }));
                     },
                   ),
                ]
              );
            } else {
              return Text("waiting...");
            }
          }
        )
      ),
    );
  }
}
