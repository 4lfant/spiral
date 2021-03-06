import 'package:dairo/data/api/model/response/hub_response.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'hub')
class HubItemData {
  @primaryKey
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? pictureUrl;
  final int createdAt;
  final int followersCount;
  bool isFollow;
  final bool isPrivate;
  final bool isDiscussionEnabled;
  final int orderIndex;

  HubItemData({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.createdAt,
    required this.followersCount,
    required this.isFollow,
    required this.isPrivate,
    required this.isDiscussionEnabled,
    required this.orderIndex,
  });

  factory HubItemData.fromResponse(HubResponse response) => HubItemData(
        id: response.id,
        userId: response.userId,
        name: response.name,
        description: response.description,
        pictureUrl: response.pictureUrl,
        createdAt: response.createdAt,
        followersCount: response.followersCount,
        isFollow: response.isFollow,
        isPrivate: response.isPrivate,
        isDiscussionEnabled: response.isDiscussionEnabled,
        orderIndex: response.orderIndex,
      );

  @override
  String toString() {
    return 'HubItemData{id: $id, userId: $userId, name: $name, description: $description, pictureUrl: $pictureUrl, createdAt: $createdAt, followersCount: $followersCount, isFollow: $isFollow, isPrivate: $isPrivate, isDiscussionEnabled: $isDiscussionEnabled, orderIndex: $orderIndex}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HubItemData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          name == other.name &&
          description == other.description &&
          pictureUrl == other.pictureUrl &&
          createdAt == other.createdAt &&
          followersCount == other.followersCount &&
          isFollow == other.isFollow &&
          isPrivate == other.isPrivate &&
          isDiscussionEnabled == other.isDiscussionEnabled &&
          orderIndex == other.orderIndex;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      pictureUrl.hashCode ^
      createdAt.hashCode ^
      followersCount.hashCode ^
      isFollow.hashCode ^
      isPrivate.hashCode ^
      isDiscussionEnabled.hashCode ^
      orderIndex.hashCode;
}
