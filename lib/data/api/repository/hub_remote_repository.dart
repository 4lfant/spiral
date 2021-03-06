import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairo/app/locator.dart';
import 'package:dairo/data/api/firebase_collections.dart';
import 'package:dairo/data/api/firebase_documents.dart';
import 'package:dairo/data/api/firebase_storage_folder.dart';
import 'package:dairo/data/api/firestore_keys.dart';
import 'package:dairo/data/api/model/request/hub_request.dart';
import 'package:dairo/data/api/model/response/hub_response.dart';
import 'package:dairo/domain/model/hub/discussion.dart';
import 'package:dairo/domain/model/hub/hub.dart';
import 'package:dairo/domain/repository/user/user_repository.dart';
import 'package:injectable/injectable.dart';

import 'firebase_storage_repository.dart';

@lazySingleton
class HubRemoteRepository {
  final FirebaseStorageRepository _firebaseStorageRepository =
      locator<FirebaseStorageRepository>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRepository _userRepository = locator<UserRepository>();

  Future<String> uploadHubPicture(File hubPicture) => _firebaseStorageRepository
      .uploadFile(file: hubPicture, folder: FirebaseStorageFolders.hubPictures);

  Future<HubResponse> createHub(HubRequest hubRequest) async {
    var requestJson = hubRequest.toJson();
    requestJson['followersCount'] = 0;
    requestJson['orderIndex'] = -1;

    final snapshot = await _firestore
        .collection(FirebaseCollections.userHubs)
        .add(requestJson)
        .then((reference) => reference.get());

    final response = HubResponse.fromJson(
      snapshot.data(),
      id: snapshot.id,
      isFollow: false,
    );

    await _createHubDiscussion(response);

    return response;
  }

  Future _createHubDiscussion(HubResponse hubResponse) =>
      FirebaseFirestore.instance
          .collection(FirebaseCollections.hubDiscussions)
          .doc(hubResponse.id)
          .set({
        'createdAt': FieldValue.serverTimestamp(),
        'imageUrl': hubResponse.pictureUrl,
        'name': hubResponse.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<List<HubResponse>> fetchHubs(String userId) => _firestore
      .collection(FirebaseCollections.userHubs)
      .where(FirestoreKeys.userId, isEqualTo: userId)
      .get()
      .then(
        (snapshots) => Future.wait(
          snapshots.docs.map(
            (doc) async => HubResponse.fromJson(
              doc.data(),
              id: doc.id,
              isFollow: await isCurrentUserFollows(doc.id),
            ),
          ),
        ),
      );

  Future<HubResponse> fetchHub(String hubId) =>
      _firestore.doc('${FirebaseCollections.userHubs}/$hubId').get().then(
            (doc) async => HubResponse.fromJson(
              doc.data(),
              id: doc.id,
              isFollow: await isCurrentUserFollows(doc.id),
            ),
          );

  Stream<Future<HubResponse>> fetchHubStream(String hubId) =>
      _firestore.doc('${FirebaseCollections.userHubs}/$hubId').snapshots().map(
            (snap) async => HubResponse.fromJson(
              snap.data(),
              id: snap.id,
              isFollow: await isCurrentUserFollows(snap.id),
            ),
          );

  Future<HubResponse> fetchOnboardingHub() => _firestore
      .doc('${FirebaseCollections.userHubs}/${FirebaseDocuments.onboardingHub}')
      .get()
      .then(
        (snap) => HubResponse.fromJson(
          snap.data(),
          id: snap.id,
          isFollow: false,
        ),
      );

  Future<bool> isCurrentUserFollows(String hubId) async {
    if (!_userRepository.isCurrentUserExist()) return false;
    return _firestore
        .doc(
            '${FirebaseCollections.usersFollowHubs}/${_userRepository.getCurrentUserId()}/${FirestoreKeys.hubs}/$hubId')
        .get()
        .then((snapshot) => snapshot.exists);
  }

  Future<void> onFollow({
    required String hubId,
    required String userId,
  }) =>
      Future.wait([
        _firestore
            .collection(
                '${FirebaseCollections.hubsFollowers}/$hubId/${FirestoreKeys.users}')
            .doc(userId)
            .set({}),
        _firestore
            .collection(
                '${FirebaseCollections.usersFollowHubs}/$userId/${FirestoreKeys.hubs}')
            .doc(hubId)
            .set({}),
      ]);

  Future<void> onUnfollow({
    required String hubId,
    required String userId,
  }) =>
      Future.wait([
        _firestore
            .collection(
                '${FirebaseCollections.hubsFollowers}/$hubId/${FirestoreKeys.users}')
            .doc(userId)
            .delete(),
        _firestore
            .collection(
                '${FirebaseCollections.usersFollowHubs}/$userId/${FirestoreKeys.hubs}')
            .doc(hubId)
            .delete(),
      ]);

  Future<List<String>> fetchHubFollowersIds(String hubId) => _firestore
      .collection(
          '${FirebaseCollections.hubsFollowers}/$hubId/${FirebaseCollections.users}')
      .get()
      .then((result) => result.docs.map((doc) => doc.id).toList());

  Future<List<String>> getUserFollowingHubIds(String userId) => _firestore
      .collection(
          '${FirebaseCollections.usersFollowHubs}/$userId/${FirestoreKeys.hubs}')
      .get()
      .then(
        (query) => query.docs.map((snap) => snap.id).toList(),
      );

  Future<List<HubResponse>> fetchHubsByIds(List<String> hubIds) => Future.wait(
        hubIds.map(
          (hubId) => FirebaseFirestore.instance
              .collection(FirebaseCollections.userHubs)
              .where(FieldPath.documentId, isEqualTo: hubId)
              .get()
              .then(
                (snapshots) async => HubResponse.fromJson(
                  snapshots.docs.first.data(),
                  id: snapshots.docs.first.id,
                  isFollow: await isCurrentUserFollows(snapshots.docs.first.id),
                ),
              ),
        ),
      );

  Future<HubResponse> setHubPrivate(Hub hub, bool private) async {
    print("ID: " + hub.id);
    final doc = _firestore.collection(FirebaseCollections.userHubs).doc(hub.id);
    return doc.update({FirestoreKeys.isPrivate: private}).then((_) => doc
        .get()
        .then((snapshot) => HubResponse.fromJson(snapshot.data(),
            id: hub.id, isFollow: hub.isFollow)));
  }

  Future<HubResponse> deleteHub(Hub hub) async {
    final doc = _firestore.collection(FirebaseCollections.userHubs).doc(hub.id);
    HubResponse response = HubResponse.fromJson((await doc.get()).data(),
        id: hub.id, isFollow: hub.isFollow);
    await doc.delete();
    return response;
  }

  Future<HubDiscussion> getHubDiscussion(String hubId) => _firestore
      .collection(FirebaseCollections.hubDiscussions)
      .doc(hubId)
      .get()
      .then((value) => HubDiscussion.fromJson(value.data()!, value.id));

  Future<void> reorderHubs(List<Hub> hubs) =>
      Future.wait(hubs.map((hub) => _firestore
          .collection(FirebaseCollections.userHubs)
          .doc(hub.id)
          .update({'orderIndex': hub.orderIndex})));

  Future<HubResponse> updateHub(String hubId, String name, String description,
      String? newPictureUrl) async {
    var data = {'name': name, 'description': description};
    if (newPictureUrl != null) {
      data['pictureUrl'] = await uploadHubPicture(File(newPictureUrl));
    }

    await _firestore
        .collection(FirebaseCollections.userHubs)
        .doc(hubId)
        .update(data);

    return _firestore
        .collection(FirebaseCollections.userHubs)
        .doc(hubId)
        .get()
        .then((value) =>
            HubResponse.fromJson(value.data()!, id: value.id, isFollow: false));
  }
}
