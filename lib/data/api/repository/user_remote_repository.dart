import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairo/app/locator.dart';
import 'package:dairo/data/api/firebase_collections.dart';
import 'package:dairo/data/api/helper.dart';
import 'package:dairo/data/api/model/request/support_request.dart';
import 'package:dairo/data/api/model/request/user_request.dart';
import 'package:dairo/data/api/model/response/user_response.dart';
import 'package:dairo/domain/model/user/social_auth_exception.dart';
import 'package:dairo/domain/model/user/social_auth_request.dart';
import 'package:dairo/presentation/res/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@lazySingleton
class UserRemoteRepository {
  String? codeVerificationId;
  final ApiHelper apiHelper = locator<ApiHelper>();

  Future<UserResponse?> fetchUser(String userId) => FirebaseFirestore.instance
      .collection(FirebaseCollections.users)
      .doc(userId)
      .get()
      .then(
        (snapshot) => snapshot.exists
            ? UserResponse.fromJson(snapshot.data(), id: snapshot.id)
            : null,
      );

  Future<List<UserResponse>> fetchUsers(List<String> userIds) => Future.wait(
        userIds.map(
          (userId) => FirebaseFirestore.instance
              .collection(FirebaseCollections.users)
              .where(FieldPath.documentId, isEqualTo: userId)
              .get()
              .then(
                (snapshots) => UserResponse.fromJson(
                    snapshots.docs.first.data(),
                    id: snapshots.docs.first.id),
              ),
        ),
      );

  Future<UserResponse> saveUser(UserRequest request) async {
    final reference = FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .doc(request.id);
    var snapshot = await reference.get();
    if (snapshot.exists) {
      await reference.update(request.toJson());
    } else {
      await reference.set(request.toJson());
    }
    snapshot = await reference.get();
    return UserResponse.fromJson(snapshot.data(), id: snapshot.id);
  }

  Future<UserRequest> loginWithSocial(SocialAuthRequest request) async {
    User firebaseUser;
    switch (request.type) {
      case SocialAuthType.Google:
        firebaseUser = await _loginWithGoogle();
        break;
      case SocialAuthType.Facebook:
        firebaseUser = await _loginWithFacebook();
        break;
      case SocialAuthType.Apple:
        firebaseUser = await _loginWithApple();
        break;
      default:
        throw ArgumentError.value(request);
    }
    return UserRequest.fromFirebase(firebaseUser);
  }

  Future<User> _loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null)
      throw Exception(Strings.errorUnableToFindGoogleUser);

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return _signInWithCredentials(credential);
  }

  Future<User> _loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success)
      throw SocialAuthException(
          message: Strings.errorUnableToGetCredentialsFromFacebook);

    final String? token = result.accessToken?.token;
    if (token == null)
      throw SocialAuthException(message: Strings.errorFacebookAuthError);

    return _signInWithCredentials(FacebookAuthProvider.credential(token));
  }

  Future<User> _loginWithApple() async {
    final rawNonce = apiHelper.generateNonce();
    final nonce = apiHelper.sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return _signInWithCredentials(oauthCredential);
  }

  Future<User> _signInWithCredentials(AuthCredential credentials) =>
      FirebaseAuth.instance
          .signInWithCredential(credentials)
          .then((credential) => credential.user!);

  Future<void> registerWithPhone(String number) =>
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: _signInWithCredentials,
        verificationFailed: (e) =>
            throw SocialAuthException(message: e.message!),
        codeSent: (id, token) => codeVerificationId = id,
        codeAutoRetrievalTimeout: (id) => codeVerificationId = id,
      );

  Future<UserRequest> verifySmsCode(String code) async {
    if (codeVerificationId == null) {
      throw SocialAuthException(
          message: Strings.errorVerificationCodeIsInvalid);
    }
    User firebaseUser = await _signInWithCredentials(
      PhoneAuthProvider.credential(
        verificationId: codeVerificationId!,
        smsCode: code,
      ),
    );

    return UserRequest.fromFirebase(firebaseUser);
  }

  Future<void> sendSupportRequest(SupportRequest request, String userId) =>
      FirebaseFirestore.instance
          .collection(FirebaseCollections.usersSupportRequests)
          .doc(userId)
          .set(request.toJson());

  Stream<UserResponse> fetchUserStream(
    String userId,
  ) =>
      FirebaseFirestore.instance
          .doc('${FirebaseCollections.users}/$userId')
          .snapshots()
          .map(
            (snap) => UserResponse.fromJson(snap.data(), id: snap.id),
          );
}
