import 'package:dairo/presentation/res/colors.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

///[PickerDecoration] is used for decorating the UI

class PickerDecoration {
  Widget? cancelIcon;
  double blurStrength;
  int columnCount;
  ActionBarPosition actionBarPosition;
  TextStyle? albumTitleStyle;
  TextStyle? albumTextStyle;
  String completeText;
  TextStyle? completeTextStyle;
  ButtonStyle? completeButtonStyle;
  Widget? loadingWidget;

  PickerDecoration({
    this.actionBarPosition = ActionBarPosition.top,
    this.cancelIcon,
    this.columnCount = 3,
    this.blurStrength = 2,
    this.albumTitleStyle,
    this.completeText = 'Continue',
    this.completeTextStyle,
    this.completeButtonStyle,
    this.loadingWidget,
    this.albumTextStyle,
  });
}

class DefaultPickerDecoration extends PickerDecoration {
  DefaultPickerDecoration()
      : super(
          albumTitleStyle: TextStyle(
            color: Colors.white,
          ),
          albumTextStyle: TextStyle(
            color: Colors.white,
          ),
          completeTextStyle: TextStyle(
            color: Colors.white,
          ),
          completeButtonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.darkGray),
          ),
          cancelIcon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          completeText: 'Done',
        );
}
