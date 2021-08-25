import 'package:dairo/app/locator.dart';
import 'package:dairo/app/router.router.dart';
import 'package:dairo/domain/repository/user/user_repository.dart';
import 'package:dairo/presentation/res/strings.dart';
import 'package:dairo/presentation/view/base/dialogs.dart';
import 'package:dairo/presentation/view/settings/settings_viewdata.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  SettingsViewModel() {
    initUser();
  }

  final UserRepository _userRepository = locator<UserRepository>();
  final NavigationService _navigationService = locator<NavigationService>();

  final SettingsViewData viewData = SettingsViewData();

  Future<void> initUser() async {
    viewData.user = await _userRepository.getCurrentUser().first;
    notifyListeners();
  }

  void onLogoutClicked() => AppDialog.showConfirmationDialog(
        title: Strings.areYouSureYouWantToLogout,
        onConfirm: (isConfirm) async {
          if (isConfirm) {
            await _userRepository.logoutUser();
            _navigateToAuthScreen();
          }
        },
      );

  void onItemClicked(int index) {
    switch (index) {
      case 0:
        return _navigateToAccountDetailsScreen();
      case 1:
        return _navigateToSupportScreen();
    }
  }

  void _navigateToAccountDetailsScreen() =>
      _navigationService.navigateTo(Routes.accountDetailsView);

  void _navigateToSupportScreen() =>
      _navigationService.navigateTo(Routes.supportView);

  void _navigateToAuthScreen() =>
      _navigationService.navigateTo(Routes.authView);
}
