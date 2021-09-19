import 'package:dairo/domain/model/hub/hub.dart';
import 'package:dairo/domain/model/user/user.dart';
import 'package:dairo/presentation/view/profile/base/base_profile_viewmodel.dart';

class UserProfileViewModel extends BaseProfileViewModel {
  final String userId;

  UserProfileViewModel(this.userId);

  @override
  Stream<User?> userStream() => userRepository.getUser(userId);

  @override
  Stream<List<Hub>> hubListStream() => hubRepository.getHubs(userId);
}