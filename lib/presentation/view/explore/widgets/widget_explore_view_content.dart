import 'package:dairo/presentation/res/colors.dart';
import 'package:dairo/presentation/res/strings.dart';
import 'package:dairo/presentation/view/explore/explore_viewmodel.dart';
import 'package:dairo/presentation/view/explore/widgets/widget_explore_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class WidgetExploreViewContent extends ViewModelWidget<ExploreViewModel> {
  @override
  Widget build(BuildContext context, viewModel) => CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.darkAccentColor,
            leading: Icon(Icons.search),
            iconTheme: IconThemeData(color: AppColors.white),
            title: TextField(
              readOnly: true,
              onTap: viewModel.onSearchPressed,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              decoration: new InputDecoration.collapsed(
                hintText: Strings.search,
                hintStyle: TextStyle(color: AppColors.gray),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.fromLTRB(8, 32, 0, 16),
                child: Text(
                  "Popular hubs",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ExplorePopularHubCarousel(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 36, 0, 12),
                child: Text(
                  "Popular publications",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ExplorePopularPublicationsGrid(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 32, 0, 16),
                child: Text(
                  "Recent publications",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ExploreRecentPublicationsGrid(),
            ]),
          ),
        ],
      );
}
