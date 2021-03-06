import 'package:dairo/presentation/res/colors.dart';
import 'package:dairo/presentation/res/strings.dart';
import 'package:flutter/material.dart';

class NextButton extends TextButton {
  NextButton({required VoidCallback? onPressed, required bool enabled})
      : super(
          child: Text(
            Strings.next,
            style: TextStyle(color: AppColors.darkAccentColor),
          ),
          onPressed: onPressed,
          style: ButtonStyle(
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 36)),
            backgroundColor: MaterialStateProperty.all(
                enabled ? AppColors.white : AppColors.gray),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
}
