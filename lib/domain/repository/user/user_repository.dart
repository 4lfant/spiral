import 'package:dairo/domain/model/user/social_auth_request.dart';
import 'package:dairo/domain/model/user/user.dart';

abstract class UserRepository {
  Future<void> loginWithSocial(SocialAuthRequest request);

  Future<void> registerWithPhone(String phoneNumber);

  Future<void> verifySmsCode(String code);

  Stream<User?> getCurrentUser();

  Stream<User?> getUser(String userId);

  Stream<List<User>> getUsers(List<String> userIds);

  bool isCurrentUserExist();

  Future<void> logoutUser();

  String checkAndGetCurrentUserId();

  Future<void> updateUser({
    String? name,
    String? username,
    String? description,
    String? photoURL,
  });

  Future<void> sendSupportRequest({
    required String subject,
    required String description,
  });

  bool isCurrentUser(String userId);
}
