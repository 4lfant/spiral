import 'dart:async';
import 'dart:io';

import 'package:dairo/app/locator.dart';
import 'package:dairo/data/api/firebase_storage_folder.dart';
import 'package:dairo/data/api/model/request/support_request.dart';
import 'package:dairo/data/api/model/request/user_request.dart';
import 'package:dairo/data/api/model/response/user_response.dart';
import 'package:dairo/data/api/repository/firebase_storage_repository.dart';
import 'package:dairo/data/api/repository/user_remote_repository.dart';
import 'package:dairo/data/db/entity/user_item_data.dart';
import 'package:dairo/data/db/repository/user_local_repository.dart';
import 'package:dairo/domain/model/user/social_auth_request.dart';
import 'package:dairo/domain/model/user/user.dart';
import 'package:dairo/domain/repository/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteRepository _remote = locator<UserRemoteRepository>();
  final UserLocalRepository _local = locator<UserLocalRepository>();
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseStorageRepository _firebaseStorageRepository =
      locator<FirebaseStorageRepository>();

  @override
  Future<void> loginWithSocial(SocialAuthRequest socialAuthRequest) async {
    UserRequest request = await _remote.loginWithSocial(socialAuthRequest);
    UserResponse response = await _remote.saveUser(request);
    await _local.addUser(UserItemData.fromResponse(response));
  }

  @override
  Future<void> registerWithPhone(String phoneNumber) =>
      _remote.registerWithPhone(phoneNumber);

  @override
  Future<void> verifySmsCode(String code) async {
    UserRequest request = await _remote.verifySmsCode(code);
    UserResponse response = await _remote.saveUser(request);
    await _local.addUser(UserItemData.fromResponse(response));
  }

  @override
  Stream<User?> getCurrentUser() => getUser(checkAndGetCurrentUserId());

  @override
  Stream<User?> getUser(String userId) {
    final stream = _local.getUser(userId).map((itemData) {
      if (itemData == null) return null;
      return User.fromItemData(itemData);
    });

    _remote.fetchUser(userId).then(
        (response) => _local.addUser(UserItemData.fromResponse(response)));

    return stream;
  }

  @override
  Stream<List<User>> getUsers(List<String> userIds) {
    final stream = _local.getUsers(userIds).map((usersItemData) =>
        usersItemData.map((itemData) => User.fromItemData(itemData)).toList());

    _remote.fetchUsers(userIds).then(
          (usersRemote) => _local.addUsers(
            usersRemote
                .map((userRemote) => UserItemData.fromResponse(userRemote))
                .toList(),
          ),
        );
    return stream;
  }

  @override
  bool isCurrentUserExist() => _auth.currentUser?.uid != null;

  @override
  Future<void> logoutUser() async {
    final currentUserId = checkAndGetCurrentUserId();
    await _auth.signOut();
    await _local.deleteUserById(currentUserId);
  }

  @override
  String checkAndGetCurrentUserId() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw UnauthorizedException();
    return currentUserId;
  }

  @override
  Future<void> updateUser({
    String? name,
    String? username,
    String? description,
    String? photoURL,
  }) async {
    String? remoteUrl;
    final currentUserId = checkAndGetCurrentUserId();
    final UserItemData? itemData = await _local.getUser(currentUserId).first;
    if (itemData != null) {
      User user = User.fromItemData(itemData);
      if (photoURL != null) {
        File file = File(photoURL);
        remoteUrl = await _firebaseStorageRepository.uploadFile(
          file: file,
          userId: currentUserId,
          folder: FirebaseStorageFolders.profile,
        );
      }
      UserResponse response = await _remote.saveUser(
        UserRequest(
          id: user.id,
          photoURL: remoteUrl ?? user.photoURL,
          phoneNumber: user.phoneNumber,
          email: user.email,
          name: name ?? user.name,
          username: username ?? user.username,
          description: description ?? user.description,
        ),
      );
      await _local.updateUser(UserItemData.fromResponse(response));
    }
  }

  @override
  Future<void> sendSupportRequest({
    required String subject,
    required String description,
  }) async {
    final currentUserId = checkAndGetCurrentUserId();
    await _remote.sendSupportRequest(
      SupportRequest(
        subject: subject,
        description: description,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
      currentUserId,
    );
  }
}
