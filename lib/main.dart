import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';

import 'package:flutter_intro/sensorPage.dart';

class Cookies extends ChangeNotifier {
  List<String> _cookies; // private member

  Cookies() { // Constructor
    _cookies = [
      'Der gute Tag beginnt mit aufstehen\nder schlechte auch',
      'Auch ein blindes Huhn findet ein Korn',
      '42'
    ];
  }

  List<String> get cookies => List.unmodifiable(_cookies);

  String get cookieOfTheDay => _cookies[Random().nextInt(_cookies.length)];

  addCookie(String wisdom) {
    _cookies.add(wisdom);
    notifyListeners();
  }
}

void main() {
  final cookieData = Cookies();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp(cookieData));
}

class MyApp extends StatelessWidget {
  final cookies;
  MyApp(this.cookies);

  @override
  Widget build(BuildContext context) {
    return Provider<Cookies>(
      create: (_) => cookies,
      child: MaterialApp(
        title: 'Flutter Into',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CookiePage(),
      )
    );
  }
}

class CookiePage extends StatefulWidget {
  @override
  _CookiePageState createState() => _CookiePageState();
}

class _CookiePageState extends State<CookiePage> {

  forceRedraw() {setState((){});} // Do nothing, only used for redrawing the page

  @override
  void initState() {
    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(
        onPhoneShake: () {forceRedraw();}
    );
  }

  @override
  Widget build(BuildContext context) {
    var cookies = Provider.of<Cookies>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookie of the Day'),
        actions: actions(context),
      ),
      body: GestureDetector(
        onTap: forceRedraw,
        child: Container(
          // without color, it won't fill the screen
          color: Theme.of(context).canvasColor,
          child: Center(
            child: Text('${cookies.cookieOfTheDay}', textScaleFactor: 1.5)
          )
        ),
      ),
    );
  }

  List<Widget> actions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.edit_rounded),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CookieMaintenancePage()));
          }
      ),
      IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SensorPage()));
          }
      )
    ];
  }
}

class CookieMaintenancePage extends StatefulWidget {
  @override
  _CookieMaintenanceState createState() => _CookieMaintenanceState();
}

class _CookieMaintenanceState extends State<CookieMaintenancePage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Cookies'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: cookieList(context)),
            cookieForm(context)
          ],
        ),
      ),
    );
  }

  Widget cookieList(BuildContext context) {
    var _cookies = Provider.of<Cookies>(context);
    return ListView.builder(
      itemCount: _cookies.cookies.length,
      itemBuilder: (context, index) {
        return Card(child: ListTile(
          title: Text(_cookies.cookies[index]),
        ));
      }
    );
  }

  Widget cookieForm(BuildContext context) {
    var _cookies = Provider.of<Cookies>(context);
    return Column(
      children: <Widget>[
        TextField(controller: myController),
        ElevatedButton(
          child: Text('Anfügen'),
          onPressed: () {
            if (myController.text.isNotEmpty) {
              setState(() {
                _cookies.addCookie(myController.text);
                myController.text = '';
              });
            }
          }
        )
      ]
    );
  }
}
