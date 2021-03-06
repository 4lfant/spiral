import 'package:dairo/app/router.router.dart';
import 'package:dairo/presentation/view/base/standard_base_view.dart';
import 'package:dairo/presentation/view/new_hub/widgets/widget_new_hub_content.dart';
import 'package:flutter/material.dart';

import 'new_hub_viewmodel.dart';

class NewHubView extends StandardBaseView<NewHubViewModel> {
  NewHubView() : super(NewHubViewModel(),
    routeName: Routes.newHubView,
  );

  @override
  Widget getContent(BuildContext context) => WidgetNewHubViewContent();
}
