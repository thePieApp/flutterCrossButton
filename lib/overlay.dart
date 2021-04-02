import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OverlayButtons extends StatefulWidget {

  final GlobalKey<_OverlayButtonsState> _key;
  OverlayButtons(this._key): super(key: _key);

  setExist(bool exist, Offset position, int buttonSize, int buttonSpacing){
    _key.currentState.setExist(exist, position, buttonSize, buttonSpacing);
  }

  selectButton(int selected){
    _key.currentState.selectButton(selected);
  }

  @override
  _OverlayButtonsState createState() => _OverlayButtonsState();
}

class _OverlayButtonsState extends State<OverlayButtons> {

  bool widgetOffstage = true;
  var widgetPosition;
  int buttonSelected = 0;

  int widgetSize = 50;
  int spacing = 20;

  // method to make the cross buttons exists to user
  setExist(bool exist, Offset position, int buttonSize, int buttonSpacing){
    setState(() {
      widgetOffstage = !exist;
      widgetPosition = position;
      widgetSize = buttonSize;
      spacing = buttonSpacing;
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
              buttonItem(1, -2, -buttonOffset, widgetSize, 'assets/Group 48.svg', 'assets/Group 48 fill.svg'),
              buttonItem(2, 2 -buttonOffset, 0, widgetSize, 'assets/Group 49.svg', 'assets/Group 49 fill.svg'),
              buttonItem(3, -2, buttonOffset, widgetSize, 'assets/Group 50.svg', 'assets/Group 50 fill.svg'),
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


