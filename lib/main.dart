import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'new_route/route1.dart';
import 'new_route/route2.dart';
import 'new_route/route3.dart';
import 'new_route/route4.dart';
import 'overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  bool liked_you = false;

  // our code
  final overlayButtonsWidget = OverlayButtons(GlobalKey()); // the cross button widget
  Offset _tapPosition; // the position of finger press
  int buttonSize = 50; // the size of button, TODO variable shape according to phone screen size
  int buttonSpacing = 20; // how far the button should be apart from each other TODO scale according to button size

  void _showButtons(){
    setState(() {
      overlayButtonsWidget.setExist(true, _tapPosition, buttonSize, buttonSpacing, liked_you);
    });
  }

  void _disableButtons(){
    if (overlayButtonsWidget.isExist()){
      overlayButtonsWidget.setExist(false, Offset.zero, buttonSize, buttonSpacing, liked_you);
    }
  }

  showCrossButton(LongPressStartDetails details){
    _tapPosition = details.globalPosition;
    _showButtons();
  }

  void updateSelectedButton(LongPressMoveUpdateDetails details){
    if (overlayButtonsWidget.isExist()){
      overlayButtonsWidget.selectButton(details);
    }
  }

  // nagivate to example route
  void _navigate(){
    if (overlayButtonsWidget.getSelectedButton() == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route1()));
    } else if (overlayButtonsWidget.getSelectedButton() == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route2()));
    } else if (overlayButtonsWidget.getSelectedButton() == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route3()));
    } else if (overlayButtonsWidget.getSelectedButton() == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Route4()));
    }
  }

  void navigateOnSelectedButtonValue(DragEndDetails){
    _navigate();
    _disableButtons();
  }

    @override
  Widget build(BuildContext context) {

    return Scaffold(
      // our code
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: showCrossButton,
        onLongPressMoveUpdate: updateSelectedButton,
        onLongPressEnd: navigateOnSelectedButtonValue,
        child: Stack(
          children: [
            // demo code, not our code
            Container(
              color: Colors.black12,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Container(
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Container(
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Container(
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'You have pushed the button this many times:',
                      ),
                      Text(
                        '$liked_you',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // our code
            overlayButtonsWidget,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            liked_you=!liked_you;
          });
          Fluttertoast.showToast(
              msg: liked_you ? "The Person Likes You Now" : "The Person Does Not Like You Now",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        },
        tooltip: 'Change liked you',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
