# Flutter Einführung
Eine Einführung  in Flutter.

## Vorbedingungen
Sie müssen [Android Studio](https://developer.android.com/studio) und [Flutter](https://flutter.dev/docs/get-started/install) installiert haben.

## Dokumentation
Die Dokumentation für die Programmierspache 'Dart' finden Sie unter: https://dart.dev/guides, Diejenige für Flutter unter https://flutter.dev/docs.


# Der Einstieg
Erzeugen Sie im Android Studio ein neues Flutterprojekt. Wählen Sie 'Flutter Application'.
Öffnen Sie 'main.dart' im 'lib'-Ordner. Sie finden dort generierten Code welchen Sie löschen können.

Wir müssen Flutter importieren und brauchen ein Main-Program:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
```

Anschliessend brauchen wir ein Widget zum starten unserer Applikation:
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Into',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CookiePage(),
    );
  }
}
```
So weit so gut. Diesen Code brauchen Sie immer, für jede neue App.  
Wie Sie sehen installieren wir als 'Home Page' die ```CookieHomePage()```.

# Cookie of the Day
Sie kennen sicher die Glückskekse, welche Sie beim Chinesen zusammen mit der Rechnung erhalten. Wenn Sie diese zerbrechen finden sie darin einen weisen Spruch.  
Wir werden eine App schreiben, welche uns, jedesmal wenn wir das Handy schüttlen, einen neuen Spruch anzeigt.

## Widgets
In Flutter besteht alles was sie auf dem Bildschirm sehen aus Widgets. Widgets haben im allgemeinen ein Aussehen und eine Funktionalität.  
Flutter bietet für fast alles ein Widget. Wir können (und müssen) aber auch eigene Widgets programmieren. Dazu werden wir einige der bestehenden Widgets wie ```Text```, ```ListTile```, ```RaisedButton``` und so weiter verwenden.  
Es gibt auch Widgets ohne visuelle Representation. Sie dienen der Anordnung von anderen Widgets. Als Beispiel sollen hier ```Center```, ```Column``` und ```ListView``` genannt werden.  

Widgets werden in einer Hierarchie angeordnet. Dazu besitzt jedes Widget die Eigenschaft ```child:``` oder die Eigenschaft ```children:```.  
Auf diese Weise können wir uns ein hierarchisch gestalltetes Layout erstellen.

Wenn wir eigene Widgets programmieren, müssen wir diese von einer passenden Widget-Klasse ableiten und angeben, wie unser Widget zusammengebaut wird.  
Das passiert in der Funktion ```Widget build(BuildContext context) ``` welche wir in unserer Subklasse überschreiben müssen.

# CookiePage
Lassen Sie uns unser erstes Widget schreiben.  
Wir wollen im Zentrum unserer Seite einen Text anzeigen welcher den Spruch des Tages enthält.  
Damit unser App auch wie eine richtige App aussieht, werden wir für das Grundlayout ein ```Scaffold```-Widget verwenden:
```dart
class CookiePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookie of the Day')
      ),
      body: Center(
        child: Text('Should show a cookie'),
      )
    );
  }
}
```
Starten sie unter 'Tools/AVD Manager' einen Emulator und lassen sie das Programm laufen.

## Daten
Als nächstes brauchen wir Daten. Lassen sie uns eine Klasse schreiben welche unsere Weisheiten verwaltet.
```dart
import 'dart:math';
  
class Cookies {
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

  addCookie(String wisdom) { _cookies.add(wisdom); }
}
```
Anschliessend können wir unsere ```CookiePage``` verfollständigen:
```dart
class CookiePage extends StatelessWidget {
  final cookies = Cookies(); // <- new
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookie of the Day')
      ),
      body: Center(
        child: Text('${cookies.cookieOfTheDay}'), // <- new
      )
    );
  }
}

```
Wählen mehrmals sie 'Run/Flutter Hot **Restart**.  
Sie sollten dann verschiedene Weisheiten sehen.

# Erfassen von Cookies
Lassen sie uns eine weitere Page erstellen in welcher wir unsere Cookies verwalten können.  

Die obere Hälfte des Fensters soll eine Liste der vorhandenen Cookies anzeigen, darunter werden wir ein Formular für die Eingabe eines neuen Cookie anzeigen.

## Statefull Widget

Wir erstellen dazu ein neues Widget, diesmal eines von Typ ```StatefulWidget```.  

So, was ist ein Statefull Widget und warum brauchen wir das?  

In Flutter werden alle Widgets bei jedem Neuzeichnen neu erstellt. Falls diese lokale Daten enthalten, werden diese Daten jedes Mal neu initialisiert.  
Manchmal wollen wir aber, dass Daten (der Zustand, State) zwischen dem Neuzeichen erzhalten bleibt. Dazu brachen wir ein ```StatefullWidget```.  
Statefull-Widgets bestehen immer aus zwei Teielen, einem Widget und einem zugehörigen State (Zustand).

```dart
class CookieMaintenancePage extends StatefulWidget {
  @override
  _CookieMaintenanceState createState() => _CookieMaintenanceState();
}

class _CookieMaintenanceState extends State<CookieMaintenancePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement widget
  }
}
```
Der Grundaufbau ist immer derselbe. Das StatefullWidget überschreibet die Funkion ````createState()```` und gibt eine passende State-Implementierung zurück. In der State-Klasse überschreiben wir wie gehabt die Funktion ```build(...)```. Alle Variablen, welche das Neuzeichnen überleben sollen, werden in der State-Klasse definiert.

# CookieMaintenancePage
Im ```CookieMaintenancePage``` Widget benutzen wir wider einen ```Scaffold``` als Grundgerüst. In der Mitte haben wir eine Spalte, welche die Liste im oberen Teil, und das Formular im unteren Teil anzeigt.  
Die Cookies werden in der Zustandsvariablen _cookies definiert.

```dart
class _CookieMaintenanceState extends State<CookieMaintenancePage> {
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
            Expanded(child: cookieList()),
            cookieForm()
          ],
        ),
      ),
    );
  }

  Widget cookieList() { return Container(); } // todo
  Widget cookieForm() { return Container(); } // todo
}
```
## ListView in Flutter
Zuerst implementieren wir die Liste in der Funktion ```cookieList()``` :

```dart
Widget cookieList() {
    return ListView.builder(
      itemCount: _cookies.cookies.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(_cookies.cookies[index]),
          )
        );
      }
    );
  }
```
## Texteingabe in Flutter
Für eine Übersicht, wie sie eine Texteingabe erstellen in Flutter beachten Sie bitte https://flutter.dev/docs/cookbook/forms/retrieve-input.

Wir brauchen in der _CookieMaintenanceState-Klasse einen ```TextEditingController``` und müssen die ```dispose()``` Funktion überschreiben.
Anschliessend müssen wir die Funktion ```cookieForm()``` implementieren.

```dart
class _CookieMaintenanceState extends State<CookieMaintenancePage> {
  ...

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  ...

  Widget cookieForm() {
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

```
## Die setState() Funktion
Ok, der Code ist ja irgendwie lasebar, aber was soll dieses ```setState()```-Dingsbums?  

Immer wenn wir den Zustand unserer Applikation ändern, müssen die abhängigen Widgets neu gezeichnet werden.  
Das heisst konkret, dass die Liste der Cookies neu gezeichnet werden muss wenn wir eine neue Weisheit anfügen. Aber wie soll Flutter wissen, dass sich der Zustand geändert hat?  

Dazu dient die Funktion ```setState()```. Sie kriegt eine (Callback-) Funktion als Parameter. Diese führt sie zur gegebenen Zeit aus und veranlasst anschliessend das Neuzeichenen der Seite.  

In unserem Fall definieren wir eine Funktion 'on ther fly'.
Mit ```() {}``` erstellen wir eine sogenannte lambda-Funktion. Sie will keine Parameter und macht was immer wir innerhalb der geschweifte Klammern angeben.
Diese lambda-Funktion übergeben wir an setState() als Argument.

### Ausprobieren gilt!
Ändern sie anschliessend den Aufruf ```home: CookiePage(),``` in der MyApp-Klasse zu ```home: CookieMaintenancePage(),``` und probieren sie den Code aus.

# Wechseln zwischen Seiten
Als nächstes wollen wir die beiden Seiten verbinden. Das ist nicht weiter schwer. Wir installieren einfach einen ```IconButton``` in der AppBar von CookiePage welcher uns mit Hilfe eines [Navigator](https://flutter.dev/docs/cookbook/navigation/navigation-basics)s zur CookieMaintenancePage schickt. Zurück kommen wir dann ganz einfach mit dem 'back button'.
```dart
class CookiePage extends StatelessWidget {
  final cookies = Cookies();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookie of the Day'),
        actions: actions(context), // <- new
      ),
      body: Center(
        child: Text('${cookies.cookieOfTheDay}'),
      )
    );
  }

  // new
  List<Widget> actions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.edit_rounded),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CookieMaintenancePage()));
          }
      )
    ];
  }
}
```
## Zwei mal Cookie-Daten?
Lassen Sie uns betrachten, was wir bisher gemacht haben. Die CookiePage ist ein StatelessWidget mit einer Konstanten cookies welche bei jedem Neuzeichnen neu instanziert wird. Die CookieMaintenancePage haben wir als StatefulWidget implementiert, welche in ihrem State die Variable _cookies genau einmal instanziert und die uns solange erhalten bleibt, wie die CookieMaintenancePage existiert (angezeigt wird).  
```dart
class CookiePage extends StatelessWidget {
  final cookies = Cookies(); // new instance on every redraw
  ...
}
```
```dart
class _CookieMaintenanceState extends     State<CookieMaintenancePage> {
  Cookies _cookies = Cookies(); // One instance for the whole lifetime of the page
  ...
}
```
Wir haben also zwei verschiedene Instanzen der Cookie-Daten.  

Das ist nicht richtig so. Wir brauchen eine Instanz welche von beiden Seiten benutzt wird.

# Zustandsverwaltung in Flutter
Flutter bringt keine eigene Vorstellung mit, wie das Problem der globale Zustandsverwaltung zu lösen sei.
Im Artikel [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options) finden sie eine Übersicht was sie benutzen könnten.  

Da Flutter das [Provider-Pattern](https://pub.dev/packages/provider) empfiehlt, werde ich ihnen dieses zeigen.

Provider ist einfach.  
- Als Erstes müssen wir unsere Daten zu einem 'Observable' machen.  
- Als Zweites erzeugen wir eine Instanz der Daten und installieren diese irgendwo hoch in der Widegt-Hierarchie.  
- Anschliessend können wir in jedem beliebigen Widget dieser Hierarchie auf die Daten zugreifen, sie modifizieren und dadurch ein automatisches Neuzeichnen auslösen.

So, let's do that 😀

Damit wir das Provider-Package verwenden können, müssen wir in der Datei 'pubspec.yaml' angeben, dass wir es benötigen.
Öffnen sie diese Datei, suchen sie nach dem Eintrag 'dependencies:' und passen den Eintrag folgendermassen an:
```yaml
dependencies:
  provider: ^4.3.3 # <- new
  flutter:
    sdk: flutter

```

### Schritt 1
Unsere Cookies-Klasse muss von ```ChangeNotifier``` erben und jedesmal wenn ihr innerer Zustand ändert, die Funktion ```notifyListeners()``` aufrufen.

```dart
class Cookies extends ChangeNotifier { // <- new
  ...

  addCookie(String wisdom) {
    _cookies.add(wisdom);
    notifyListeners(); // <- new
  }
}
```
### Schritt 2

Wir erstellen in der ```main()```-Funktion ein Cookies-Objekt und übergeben dieses als Parameter an das ```MyApp```-Widget welche dieses in die Widgethierarchie einfügt. Das erledigen wir, indem wir unsere MaterialApp in ein Provider-Widget einpacken:
```dart
import 'package:provider/provider.dart';
...

class MyApp extends StatelessWidget {
  final cookies;
  MyApp(this.cookies);

  @override
  Widget build(BuildContext context) {
    return Provider<Cookies>( // <- new 
      create: (_) => cookies, // provide cookie data
      child: MaterialApp(
        ...
      )
    ); // <- new
  }
}
```

### Scritt 3
In der CookiePage löschen wir die Konstante cookies und besorgen uns die benötigten Daten an Anfang der build()-Funktion vom Provider. Der Rest bleibt wie gehabt.
```dart
class CookiePage extends StatelessWidget {
  // <- deleted
  @override
  Widget build(BuildContext context) {
    var cookies = Provider.of<Cookies>(context); // <- new
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookie of the Day'),
        actions: actions(context),
      ),
      body: Center(
      child: Text('${cookies.cookieOfTheDay}'),
      )
    );
  }

  ...
}
```
In _CookieMaintenanceState machen wir das Analoge.  
Der Aufwand ist alledings etwas grösser, da wir die Erstellung des Formulars und der ListView in zwei Funktionen ausgelagert haben. In diesen Funktionen brauchen wir jeweils Zugriff auf die Cookie-Daten. Den passenden Provider können wir aber nur finden, wenn wird den aktuellen context haben. Wir müssen diesen desshalb beim Aufruf der Funktionen übergeben und ihn dort auch entgegennehmen.  
Der Einfacheitshabler gebe ich ihnen unten den ganzen Code an.
```dart
class _CookieMaintenanceState extends State<CookieMaintenancePage> {
  // <- deleted
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
            Expanded(child: cookieList(context)), // <- changed
            cookieForm(context) // <- changed
          ],
        ),
      ),
    );
  }

  Widget cookieList(BuildContext context) { // <- changed
    var _cookies = Provider.of<Cookies>(context); // <- new
    return ListView.builder(
      itemCount: _cookies.cookies.length,
      itemBuilder: (context, index) {
        return Card(child: ListTile(
          title: Text(_cookies.cookies[index]),
        ));
      }
    );
  }

  Widget cookieForm(BuildContext context) { // <- changed
    var _cookies = Provider.of<Cookies>(context); // <- new
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

```
# Stand der Dinge
Nicht schlecht. Mit nur 142 Zeilen Code haben wir eine vollständige App geschrieben.  
Sie demonstriert wie wir zwischen verschiedenen Seiten wechseln, dass es Zustandslose (StatelesWidget) und Zustandsbehaftete (StatefullWidget) gibt und wie wir 'globalen' Zustand so installieren können, dass er nicht nur in allen Widgets verwendet werden kann, sondern auch noch das automatische Neuzeichnen auslöst falls sich sein Zustand ändert.  

Das einzige dass nun noch fehlt, ist die Möglichkeit, mittels schütteln auf der CookiePage einen neuen Glückskeks zu bestellen.

# Hardwarezugriff mit Flutter
Flutter ermöglicht es, Applikationen für das Web, den Desktop und für mobile Geräte zu erstellen. 
Auf den mobilen Geräten werden sowohl Android als auch das Betriebssytem von Apple unterstützt. Im Idealfall schreiben sie einmal Code und die App läuft überall.

## Sensoren
Sensoren finden wir im Allgemeinen nur in Mobilen Geräten. Sie sie werden von Treibern des entsprechenden Betriebssystems angesprochen und ausgewertet. Da Flutter eine plattformübergreifende Entwicklungsumgebung ist, muss sie mit den vorhandenen Betriebssystemen kommunizieren, welche wiederum mit der Sensorhardware kommuniziert.  

In Flutter gibt es die Möglichkeit, Code zu schreiben, welcher platformspezifischen Code aufruft. Wir können dann für jedes Betriebssysten Code schreiben, welcher die Sensoren ausliesst und die Kommunikation mit Flutter erledigt. Dazu müssen wir aber für jede unterstützte Platforn platformspezifischen Code schreiben.  
Aber genau das wollen wir nicht. Soll das doch bitte jemand anders für uns erledigen 😈.  

Wir brauchen also eine passende Bibliothek.  
auf https://pub.dev/ koönnen wir nach passenden Libraries suchen. Probiereen wir es einmal mit dem [sensors](https://pub.dev/packages/sensors)-Package.
Gemäss der Installationsanleitung ergänzen wir unsere pubspec.yaml Datei.
```yaml
dependencies:
  provider: ^4.3.3
  sensors: ^0.4.2+6 # <- new
  flutter:
    sdk: flutter
```
Das sensors-Package gibt uns Zugriff auf den Beschleunigungs- und den Gyroskopsensor.

Ein Beispiel wie wir mit Sensordaten umgehen, finden sie unter [SensorPage](#SensorPage).

# CookiePage mit schütteln
Wir wären sicher in der Lage, mit den vorhandenen Sensordaten einen Schütteldetector zu programmieren. Glücklicherweise existiert bereits eine solche Library und wir werden diese benutzen.  
Installieren sie [shake](https://pub.dev/packages/shake/example).
```yaml
dependencies:
  provider: ^4.3.3
  shake: ^0.1.0 # <- new
  flutter:
    sdk: flutter
```
Dummerweise muss der Schüttelsensor in einem StatefulWidget verwendet werden. Wir passen also unsere CookiePage entsprechend an und ergänzen sie mit einer ```initState()```-Funktion gemäss dem Beispiel aus shake.
In ```onPhoneShake:``` rufen wir ```forceRedraw()``` auf. Diese löst das Neuzeichnen aus.

```dart
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

...

}
```
Damit sie diese Funktionalität auch im Emulator benützen können, wickeln wir unseren Text noch in einen [GestureDetector](https://flutter.dev/docs/cookbook/gestures/handling-taps) ein.
Auch dieser benutzt ```forceRedraw()``` für das Auslösen des Neuzeichnens.
```dart
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
          // Container should fill the whole screen but without a color, it won't do that
          color: Theme.of(context).canvasColor,
          child: Center(
            child: Text('${cookies.cookieOfTheDay}', textScaleFactor: 1.5)
          )
        ),
      ),
    );
  }

```
Probieren sie das aus, sowohl Schütteln als auch BFerühren sollte eine neue Weisheit anzeigen.  


# SensorPage
Das SensorPage-Widget soll ihnen zwei Dinge zeigen. Einerseits wie man sich an einen Sensordatenstream anbindet und andererseits, wie sie mit einem CustomPaint-Widget und einer CustomPainter-Strategie die erhaltenen Werte anzeigen können.

## Sensoranbindung
wir benutzen das [sensors](https://pub.dev/packages/sensors)-Package welches wir bereits in [Sensoren](##Sensoren) eingebunden haben.

Sensoren sollten in den Lifecycle-Methoden installiert und wider frei gegeben werden. Zudem müssen wir nach Erhalt der Daten jeweils das Neuzeichnen der Page veranlassen.  
Beide Fälle verlangen, dass wir ein StateFulWidget verwenden.
```dart
class SensorPage extends StatefulWidget {
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  // todo: define local state variables

  void initState() {
    super.initState();
    // todo: connect to the senors package
  }

  void dispose() {
    super.dispose();
    // todo: close sensor connection
  }

  @override
  Widget build(BuildContext context) {
    // todo: show content with sensor data
  }
}
```
Das Beispiel aus [sensors](https://pub.dev/packages/sensors/example) ist etwas überfrachtet.  
Wir werden nur die Acceleratordaten benutzen. Jedesmal wenn wir neue Daten vom Sensor erhalten, kopieren wir diese in unseren lokalen Zustand und lösen ein Neuzeichnen aus.  

Studieren sie den Code mitsamt den Kommentaren um zu sehen was läuft.
```dart
import 'package:sensors/sensors.dart';
...

class _SensorPageState extends State<SensorPage> {
  int _delayCount = 0;
  double _ax = 0, _ay = 0, _az = 0;
  StreamSubscription<dynamic> _accelerometerSubscription;

  void initState() {
    super.initState();
    // Subscribe for accelerator events
    _accelerometerSubscription = accelerometerEvents.listen(
      // This function will be called every time new data arrive
      (event) {
        // We do not need evey event
        if (++_delayCount < 10) return; _delayCount = 0;

        // whenever we get new data,
        // copythe values to the local state
        // and force a redraw by calling setState()
        setState(() {
          _ax = event.x; _ay = event.y; _az = event.z;
        });
      }
    );
  }

  void dispose() {
    // Cancel our subscription
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

## Darstellung der Sensordaten
Unser Seite bauen wir uns wie immer mit Hilfe eines Scaffold-Wigets zusammen.  
Wir haben eine Spalte mit zwei Einträgen. Im oberen Teil werden wir uns eine Wasserwaage bauen, im unteren Teil reicht ein Text-Wiget für die Ausgabe der Daten.
```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor'),
      ),
      body: Center(
        child: Column(
          children: [
            sensorView(_ax, _ay, _az),
            Text('Accel: x: ${_d2s(_ax)}, y: ${_d2s(_ay)}, z: ${_d2s(_az)}', textScaleFactor: 1.5,),
          ],
        ),
    ));
  }

  Widget sensorView(double ax, double ay, double az) {
    ... // todo: show the sensor values graphicaly
  }

  String _d2s(double d) => d.toStringAsFixed(2);
```
## Eine Wasserwage implementieren
Damit wir in Flutter selber zeichnen können, brachen wir ein passendes Widget, nämlich ein ```CustomPaint```.
Dieses Widget muss wie üblch in der Widgethierarchie eingfügt werden.  
Damit es weis was es anzeigen soll, bracht es eine Zeichnungsstrategie, einen ```Painter```. In unserem Fall ist das ein ```SpiritLevelPainter```-Objekt.
Diese Klasse müssen wir selbst erstellen. Nur sie kann wissen, dass wir eine Wasserwaage bauen wollen und was wir dazu angezeigen müssen.  

Ergänzen sie die Funktion sensorView() folgendermassen:
```dart
Widget sensorView(double ax, double ay, double az) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            // A CustomPaint is a widget which needs a paint strategy (a Painter)
            child:CustomPaint(
              size: Size.infinite,
              painter: SpiritLevelPainter(ax, ay),
            )
        )
    );
  }
```
## Die Spirit Level Painter Strategie
Ein CustomPaint braucht ein Painter-Objekt um sich darzustellen. Folgerichtig muss unser SpiritLevelPainter von Painter erben.  
Painter gibt vor, dass wir die Funktionen 'paint(..)' und 'shouldRepaint(..)' überschreiben müssen.  

Daraus ergibt sich der folgende Code:
```dart
/// SpiritLevelPainter serves as a Painter strategy for a CustomPaint widget
///
/// We have to override paint(..) as well as shouldRepaint(..)
class SpiritLevelPainter extends CustomPainter {
  double ax, ay;
  SpiritLevelPainter(this.ax, this.ay);

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleRadius = 10.0;
    // Calculate the parameters from the actual size
    var radius = size.shortestSide/2-bubbleRadius;
    var center = Offset(size.width/2, size.height/2);

    // draw circumference of the spirit level
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius+bubbleRadius, paint);
    canvas.drawCircle(center, bubbleRadius+3.0, paint);

    // Get normalized sensor data
    var normalizedData = _normalizeData(scaleBy: 5.0);

    // Draw the bubble
    paint
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    var bubbleCenter = Offset(radius * normalizedData[0], radius * normalizedData[1]);
    bubbleCenter = bubbleCenter.translate(center.dx, center.dy);
    canvas.drawCircle(bubbleCenter, bubbleRadius, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(bubbleCenter, bubbleRadius, paint);
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

### _normalizeData(..)
Die Funktion '_normalizeData(..)' ist ein wenig ein Biest.  
Sie benutzt die Sensorwerte aus unseren Zustand und eliminiert erst den Einfluss der Gravitation.  

Anschliessend streckt sie die Wert um den Faktor 'scaleBy' damit wir eine bessere Auflösung kriegen.  
Bessere Auflösung meint hier, dass schon eine kleine Unebenheit eine grosse Bewegung der Blase hervorruft.  

Anschliessend stellt sie sicher, dass die errechneten Wert nie ausserhalb des Einheitskreises liegen.  

Das Resultat der Berechnung ist ein Array mit dem x-Wert an der Stelle null und dem y-Wert an der Stelle eins.  
Die x und y-Werte sind so normiert, dass sie plus/minus Eins nicht überschreiten.  
In der Zeichnungsfunktion brauchen wir die Werte zur Skalierung des Kreismittelpunktes der Blase.
```dart
class SpiritLevelPainter extends CustomPainter {
  ...

  /// The normalized data is in the range [-1..1]
  /// and inside the unit circle
  List<double> _normalizeData({double scaleBy = 1.0}) {
    double x,y;
    // Compensate for gravitation
    x = (ax/9.8);
    y = (-ay/9.8);

    // scale values
    x *= scaleBy;
    y *= scaleBy;

    // Normalize to [-1..1]
    if (x > 1) x = 1; if (x < -1) x = -1;
    if (y > 1) y = 1; if (y < -1) y = -1;

    // Ensure circle restrictions
    var len = sqrt(x*x + y*y);
    if (len > 1.0) {
      x /= len;
      y /= len;
    }
    return [x, y];
  }
}
```
