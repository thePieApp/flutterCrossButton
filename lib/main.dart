import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'new_route/route1.dart';
import 'new_route/route2.dart';
import 'new_route/route3.dart';
import 'new_route/route4.dart';
import 'overlay.dart';
import 'dart:core';

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

  // demo code
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // our code
  final overlayButtonsWidget = OverlayButtons(GlobalKey()); // the cross button widget
  Offset _tapPosition; // the position of finger press
  int buttonSize = 50; // the size of button, TODO variable shape according to phone screen size
  int buttonSpacing = 20; // how far the button should be apart from each other TODO scale according to button size

  int _tapID = 0; // a counter to check whether the showButton function still need to execute
  int selectedButton = 0; // the button selected

  void _updateTapID(){
    _tapID = _tapID>1000? 0 : _tapID + 1; // update tapID, if it is too big, set to 0
  }

  void _showButtons(){
    setState(() {
      overlayButtonsWidget.setExist(true, _tapPosition, buttonSize, buttonSpacing);
    });
  }

  void _disableButtons(){
    overlayButtonsWidget.setExist(false, Offset.zero, buttonSize, buttonSpacing);
  }

  void showCrossButton(TapDownDetails details) {
    _updateTapID();
    int currentTapID = _tapID;
    _tapPosition = details.globalPosition;
    Future.delayed(const Duration(milliseconds: 250), () { // 250 is just temporary value
      if (_tapID == currentTapID) {
      _showButtons();
      }
    });
  }

  void disableShowButtonforFastMoves(DragUpdateDetails details) {
    _updateTapID();
  }

  void cancelShowCrossButton(TapUpDetails details){
    _updateTapID();
    _disableButtons();
  }

  // nagivate to example route
  void _navigate(){
    if (selectedButton == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route1()));
    } else if (selectedButton == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route2()));
    } else if (selectedButton == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route3()));
    } else if (selectedButton == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route4()));
    }
  }

  void navigateOnSelectedButtonValue(){
    _updateTapID();
    _navigate();
    _disableButtons();
  }

  void updateSelectedButton(LongPressMoveUpdateDetails details){
    Offset offset = details.globalPosition;
    double cx = _tapPosition.dx;
    double cy = _tapPosition.dy;
    double areaOfTouch = buttonSize/2;
    int buttonDistanceFromFingerPress = buttonSize + buttonSpacing;
    // for the button to be selected, the distance of the finger tip from the button center needs to be less than a value
    if ( (cx -2 - offset.dx).abs() < areaOfTouch && (cy - buttonDistanceFromFingerPress - offset.dy).abs() < areaOfTouch ) {
      selectedButton = 1;
      overlayButtonsWidget.selectButton(1);
    } else if ( (cx + 2 - buttonDistanceFromFingerPress - offset.dx).abs() < areaOfTouch && (cy - offset.dy).abs() < areaOfTouch ){
      selectedButton = 2;
      overlayButtonsWidget.selectButton(2);
    } else if  ( (cx -2 - offset.dx).abs() < areaOfTouch && (cy + buttonDistanceFromFingerPress - offset.dy).abs() < areaOfTouch ) {
      selectedButton = 3;
      overlayButtonsWidget.selectButton(3);
    } else if  ( (cx + 2 + buttonDistanceFromFingerPress - offset.dx).abs() < areaOfTouch && (cy - offset.dy).abs() < areaOfTouch ) {
      selectedButton = 4;
      overlayButtonsWidget.selectButton(4);
    } else {
      selectedButton = 0;
      overlayButtonsWidget.selectButton(0);
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      // our code
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: showCrossButton,
        onTapUp: cancelShowCrossButton,
        onLongPressMoveUpdate: updateSelectedButton,
        onLongPressUp: navigateOnSelectedButtonValue,
        onPanUpdate: disableShowButtonforFastMoves,
        child: Stack(
          children: [
            // demo code, not our code
            Container(
              color: Colors.black12,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
            ),
            // our code
            overlayButtonsWidget,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
