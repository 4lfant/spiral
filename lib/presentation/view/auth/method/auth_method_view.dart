import 'package:dairo/app/router.router.dart';
import 'package:dairo/presentation/view/auth/method/auth_method_view_content.dart';
import 'package:dairo/presentation/view/base/standard_base_view.dart';
import 'package:flutter/widgets.dart';

import 'auth_method_viewmodel.dart';

class AuthMethodView extends StandardBaseView<AuthViewModel> {
  AuthMethodView()
      : super(
          AuthViewModel(),
          routeName: Routes.authMethodView,
        );

  @override
  Widget getContent(BuildContext context) => AuthMethodViewContent();
}
