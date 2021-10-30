import 'package:dairo/app/locator.dart';
import 'package:dairo/app/router.router.dart';
import 'package:dairo/domain/repository/analytics/analytics_repository.dart';
import 'package:dairo/presentation/res/strings.dart';
import 'package:dairo/presentation/view/base/dialogs.dart';
import 'package:dairo/presentation/view/tools/shared_pref_keys.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainViewModel extends IndexTrackingViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsRepository _analyticsRepository =
      locator<AnalyticsRepository>();
  int previousTab = -1;

  MainViewModel() {
    _checkIfShouldInviteFriends();
  }

  void _checkIfShouldInviteFriends() async {
    final preferences = await SharedPreferences.getInstance();
    final launchCount =
        preferences.getInt(SharedPreferencesKeys.launchCount) ?? 1;
    if (launchCount == 2) {
      _showInviteFriendsPrompt();
    }
    preferences.setInt(SharedPreferencesKeys.launchCount, launchCount + 1);
  }

  void _showInviteFriendsPrompt() {
    AppDialog.inviteFriends(
      confirm: () => Share.share(Strings.inviteFriendsDesc),
    );
  }

  onFabPressed() async {
    _navigationService.navigateTo(Routes.newPubHubSelectionView);
  }

  @override
  void setIndex(int value) {
    if (previousTab == -1 || previousTab != value) {
      previousTab = value;
      _sendCurrentTabToAnalytics(value);
    }
    super.setIndex(value);
  }

  void _sendCurrentTabToAnalytics(int value) {
    final currentTabName = value == 0 ? '/home-view' : '/explore-view';
    _analyticsRepository.setCurrentScreen(
      screenName: currentTabName,
    );
  }
}
