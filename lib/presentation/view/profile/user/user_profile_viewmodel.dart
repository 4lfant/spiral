import 'package:dairo/app/locator.dart';
import 'package:dairo/domain/model/hub/hub.dart';
import 'package:dairo/domain/model/user/user.dart';
import 'package:dairo/domain/repository/support/support_repository.dart';
import 'package:dairo/presentation/res/strings.dart';
import 'package:dairo/presentation/view/base/dialogs.dart';
import 'package:dairo/presentation/view/profile/base/base_profile_viewmodel.dart';

class UserProfileViewModel extends BaseProfileViewModel {
  final String userId;
  bool? isUserBlocked;
  final SupportRepository _supportRepository = locator<SupportRepository>();

  UserProfileViewModel(this.userId) {
    _getUserStatus();
  }

  void _getUserStatus() async {
    isUserBlocked =
        await _supportRepository.isUserBlockedByCurrentUser(userId: userId);
  }

  @override
  Stream<User?> userStream() => userRepository.getUser(userId);

  @override
  Stream<List<Hub>> hubListStream() => hubRepository.getHubs(userId);

  void onReport() {
    _supportRepository.reportUser(userId: userId, reason: "TODO");
    AppDialog.showInformDialog(
        title: Strings.reported, description: Strings.reportedProfileDesc);
  }

  void onBlock() async {
    await _supportRepository.blockUser(userId: userId);
    isUserBlocked = true;
    notifyListeners();
    AppDialog.showInformDialog(
        title: Strings.blocked, description: Strings.blockedProfileDesc);
  }
}
