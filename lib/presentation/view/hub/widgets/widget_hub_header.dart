import 'package:cached_network_image/cached_network_image.dart';
import 'package:dairo/presentation/res/colors.dart';
import 'package:dairo/presentation/res/strings.dart';
import 'package:dairo/presentation/res/text_styles.dart';
import 'package:dairo/presentation/view/hub/hub_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class WidgetHubHeader extends ViewModelWidget<HubViewModel> {
  @override
  Widget build(BuildContext context, HubViewModel viewModel) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: viewModel.viewData.hub!.pictureUrl,
            height: 212,
            width: double.maxFinite,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              viewModel.viewData.hub!.description,
              style: TextStyles.black14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: viewModel.onFollowersClicked,
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    children: [
                      Text(viewModel.viewData.hub!.followersCount.toString()),
                      Text(Strings.followers),
                    ],
                  ),
                ),
                !viewModel.isCurrentUser()
                    ? Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: InkWell(
                          onTap: viewModel.onFollowClicked,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 30,
                            ),
                            child: Text(
                              viewModel.viewData.hub!.isFollow
                                  ? Strings.unfollow
                                  : Strings.follow,
                              style: TextStyles.white12,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      );
}
