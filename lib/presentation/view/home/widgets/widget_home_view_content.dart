import 'package:dairo/presentation/res/strings.dart';
import 'package:dairo/presentation/res/text_styles.dart';
import 'package:dairo/presentation/view/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'widget_toolbar_home.dart';

class WidgetHomeViewContent extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, viewModel) => Column(children: [
        AppBarHome(),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              Strings.home,
              style: TextStyles.black22,
            ),
          ),
        ),
      ]);
}
