import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairo/app/locator.dart';
import 'package:dairo/data/api/firebase_collections.dart';
import 'package:dairo/data/api/firebase_storage_folder.dart';
import 'package:dairo/data/api/model/request/hub_request.dart';
import 'package:dairo/data/api/model/response/hub_response.dart';
import 'package:injectable/injectable.dart';

import 'firebase_storage_repository.dart';

@lazySingleton
class HubRemoteRepository {
  final FirebaseStorageRepository _firebaseStorageRepository =
      locator<FirebaseStorageRepository>();

  Future<HubResponse> createHub(HubRequest hubRequest, File hubPicture) async {
    List<String> uploadedUrls = await _firebaseStorageRepository
        .uploadFilesToUserFolder(
            [hubPicture], FirebaseStorageFolders.hubPictures);
    hubRequest.pictureUrl = uploadedUrls[0];

    var documentReference = await FirebaseFirestore.instance
        .collection(FirebaseCollections.userHubs)
        .add(hubRequest.toJson());
    var documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      return HubResponse.fromJson(
          documentSnapshot.id, documentSnapshot.data()!);
    } else {
      return throw FirebaseException(plugin: "Firebase Storage");
    }
  }
}