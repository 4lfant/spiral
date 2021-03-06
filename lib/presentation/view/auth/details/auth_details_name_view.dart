import 'package:dairo/app/locator.dart';
import 'package:dairo/app/router.router.dart';
import 'package:dairo/presentation/res/colors.dart';
import 'package:dairo/presentation/view/auth/details/auth_details_viewmodel.dart';
import 'package:dairo/presentation/view/auth/widgets/buttons.dart';
import 'package:dairo/presentation/view/base/standard_base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class AuthDetailsNameView extends StandardBaseView<AuthDetailsViewModel> {
  AuthDetailsNameView()
      : super(
          locator<AuthDetailsViewModel>(),
          routeName: Routes.authDetailsNameView,
          disposeViewModel: false,
        );

  @override
  Widget getContent(BuildContext context) => AuthDetailsNameViewContent();
}

class AuthDetailsNameViewContent extends ViewModelWidget<AuthDetailsViewModel> {
  @override
  Widget build(BuildContext context, AuthDetailsViewModel viewModel) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Enter your display name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 16),
                  TextFormField(
                    onChanged: (s) => viewModel.notifyListeners(),
                    controller: viewModel.nameController,
                    autofocus: false,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.white,
                      fontWeight: FontWeight.w200,
                    ),
                    keyboardType: TextInputType.name,
                    cursorColor: AppColors.white,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      fillColor: AppColors.white,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.white, width: 0.5)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.gray, width: 0.5)),
                    ),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                  SizedBox(height: 8),
                  NextButton(
                    onPressed: viewModel.onNameNextClicked,
                    enabled: viewModel.nameController.text.isNotEmpty,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
