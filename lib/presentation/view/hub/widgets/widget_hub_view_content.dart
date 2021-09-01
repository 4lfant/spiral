import 'package:dairo/presentation/res/colors.dart';
import 'package:dairo/presentation/view/base/loading_widget.dart';
import 'package:dairo/presentation/view/hub/widgets/widget_hub_header.dart';
import 'package:dairo/presentation/view/hub/widgets/widget_hub_publications.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../hub_viewmodel.dart';
import 'appbar_hub.dart';

class WidgetHubViewContent extends ViewModelWidget<HubViewModel> {
  @override
  Widget build(BuildContext context, HubViewModel viewModel) => Scaffold(
        appBar: AppBarHub(),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: viewModel.viewData.hub != null
                ? Column(
                    children: [
                      WidgetHubHeader(),
                      WidgetHubPublications(),
                    ],
                  )
                : ProgressBar(
                    alignment: ProgressBarAlignment.Center,
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: viewModel.userId != null
              ? viewModel.onCreatePublicationClicked
              : viewModel.onOnboardingNextClicked,
          child:
              Icon(viewModel.userId != null ? Icons.add : Icons.arrow_forward),
          backgroundColor: AppColors.primaryColor,
          // elevation: 0,
        ),
      );
}
