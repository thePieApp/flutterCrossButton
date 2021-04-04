import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OverlayButtons extends StatefulWidget {

  final GlobalKey<_OverlayButtonsState> _key;
  OverlayButtons(this._key): super(key: _key);

  void setExist(bool exist, Offset position, int buttonSize, int buttonSpacing, bool likedYou){
    _key.currentState.setExist(exist, position, buttonSize, buttonSpacing, likedYou);
  }

  void selectButton(LongPressMoveUpdateDetails details){
    Offset offset = details.globalPosition;
    double cx = _key.currentState.widgetPosition.dx;
    double cy = _key.currentState.widgetPosition.dy;
    double areaOfTouch = _key.currentState.widgetSize/2;
    int buttonDistanceFromFingerPress = _key.currentState.widgetSize + _key.currentState.spacing;
    // for the button to be selected, the distance of the finger tip from the button center needs to be less than a value
    if ( (cx -2 - offset.dx).abs() < areaOfTouch && (cy - buttonDistanceFromFingerPress - offset.dy).abs() < areaOfTouch && !_key.currentState.likedUser) {
      _key.currentState.selectButton(1);
    } else if ( (cx + 2 - buttonDistanceFromFingerPress - offset.dx).abs() < areaOfTouch && (cy - offset.dy).abs() < areaOfTouch ){
      _key.currentState.selectButton(2);
    } else if  ( (cx -2 - offset.dx).abs() < areaOfTouch && (cy + buttonDistanceFromFingerPress - offset.dy).abs() < areaOfTouch  && !_key.currentState.likedUser) {
      _key.currentState.selectButton(3);
    } else if  ( (cx + 2 + buttonDistanceFromFingerPress - offset.dx).abs() < areaOfTouch && (cy - offset.dy).abs() < areaOfTouch ) {
      _key.currentState.selectButton(4);
    } else {
      _key.currentState.selectButton(0);
    }
  }

  int getSelectedButton() => _key.currentState.buttonSelected;
  bool isExist() => !_key.currentState.widgetOffstage;

  @override
  _OverlayButtonsState createState() => _OverlayButtonsState();
}

class _OverlayButtonsState extends State<OverlayButtons> {

  bool widgetOffstage = true;
  Offset widgetPosition;
  int buttonSelected = 0;

  int widgetSize = 50;
  int spacing = 20;
  bool likedUser = false;

  // method to make the cross buttons exists to user
  setExist(bool exist, Offset position, int buttonSize, int buttonSpacing, bool likedYou){
    setState(() {
      widgetOffstage = !exist;
      widgetPosition = position;
      widgetSize = buttonSize;
      spacing = buttonSpacing;
      likedUser = likedYou;
    });
  }

  // method to select a particular button in the cross buttons
  selectButton(int selected){
    setState(() {
      buttonSelected = selected;
    });
  }

  // define the reusable buttonItem function
  Widget buttonItem(int buttonNumber, int offsetX, int offsetY, int buttonSize, String disableIcon, String enableIcon){
    return Transform.translate(
      offset: Offset(offsetX.toDouble(), offsetY.toDouble()),
      child: Container(
        child: SvgPicture.asset(
          buttonSelected != buttonNumber ? disableIcon : enableIcon,
          width: buttonSize.toDouble(),
          height: buttonSize.toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    int buttonOffset = widgetSize+spacing;
    return Positioned(
    left: widgetPosition == null? 0 : widgetPosition.dx-widgetSize/2.0,
    top: widgetPosition == null? 0 : widgetPosition.dy-widgetSize/2.0,
    child: Offstage(
      offstage: widgetOffstage,
      child: Container(
        child: Stack(
          children: [
            likedUser? Container() : buttonItem(1, -2, -buttonOffset, widgetSize, 'assets/Group 48.svg', 'assets/Group 48 fill.svg'),
            buttonItem(2, 2 -buttonOffset, 0, widgetSize, 'assets/Group 49.svg', 'assets/Group 49 fill.svg'),
            likedUser? Container() : buttonItem(3, -2, buttonOffset, widgetSize, 'assets/Group 50.svg', 'assets/Group 50 fill.svg'),
            buttonItem(4, buttonOffset+2, 0, widgetSize, 'assets/Group 51.svg', 'assets/Group 51 fill.svg'),
            Container(
              width: widgetSize.toDouble(),
              height: widgetSize.toDouble(),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.5,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(widgetSize.toDouble()))
              ),
            )
          ],
        ),
      ),
    ),
      );
  }
}


