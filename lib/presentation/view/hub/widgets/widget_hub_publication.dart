import 'package:dairo/domain/model/hub/hub.dart';
import 'package:dairo/domain/model/publication/publication.dart';
import 'package:dairo/domain/model/user/user.dart';
import 'package:dairo/presentation/res/colors.dart';
import 'package:dairo/presentation/res/text_styles.dart';
import 'package:dairo/presentation/view/base/widget_like.dart';
import 'package:dairo/presentation/view/hub/widgets/widget_hub_publication_media.dart';
import 'package:dairo/presentation/view/profile/base/widgets/widget_profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetHubPublication extends StatelessWidget {
  final User? user;
  final Hub? hub;
  final Publication publication;
  final Function(String publicationId, bool isLiked) onPublicationLikeClicked;
  final Function(String publicationId) onUsersLikedScreenClicked;
  final Function(Publication publication) onPublicationDetailsClicked;

  const WidgetHubPublication({
    Key? key,
    required this.user,
    required this.hub,
    required this.publication,
    required this.onPublicationLikeClicked,
    required this.onUsersLikedScreenClicked,
    required this.onPublicationDetailsClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onPublicationDetailsClicked(publication),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    WidgetProfilePhoto(
                      photoUrl: user?.photoURL,
                      width: 22,
                      height: 22,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Text(
                      user?.name ?? '',
                      style: TextStyles.black12,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                Row(
                  children: [
                    WidgetProfilePhoto(
                      photoUrl: hub?.pictureUrl,
                      width: 22,
                      height: 22,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                    ),
                    Text(
                      hub?.name ?? '',
                      style: TextStyles.black12,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            _WidgetHubPublicationText(
              publication.text,
              key: UniqueKey(),
            ),
            _WidgetHubPublicationMedia(
              publication.mediaUrls,
              key: UniqueKey(),
            ),
            _WidgetHubPublicationFooter(
              publicationId: publication.id,
              isLiked: publication.isLiked,
              likesCount: publication.likesCount,
              commentsCount: publication.commentsCount,
              onPublicationLikeClicked: onPublicationLikeClicked,
              onUsersLikedScreenClicked: () =>
                  onUsersLikedScreenClicked(publication.id),
              key: UniqueKey(),
            ),
          ],
        ),
      );
}

class _WidgetHubPublicationText extends StatelessWidget {
  final String? text;

  const _WidgetHubPublicationText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => text != null && text!.isNotEmpty
      ? Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(text!),
        )
      : SizedBox.shrink();
}

class _WidgetHubPublicationMedia extends StatelessWidget {
  final List<String> mediaUrls;

  const _WidgetHubPublicationMedia(this.mediaUrls, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => mediaUrls.isNotEmpty
      ? SizedBox(
          height: 160,
          child: WidgetHubPublicationMedia(mediaUrls),
        )
      : SizedBox.shrink();
}

class _WidgetHubPublicationFooter extends StatelessWidget {
  final String publicationId;
  final bool isLiked;
  final int likesCount;
  final int commentsCount;
  final Function(String, bool) onPublicationLikeClicked;
  final Function onUsersLikedScreenClicked;

  const _WidgetHubPublicationFooter({
    required this.publicationId,
    required this.isLiked,
    required this.likesCount,
    required this.commentsCount,
    required this.onPublicationLikeClicked,
    required this.onUsersLikedScreenClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: Row(
          children: [
            WidgetLike(
              isLiked,
              likesCount,
              onPublicationLikeClicked: (isLiked) => onPublicationLikeClicked(
                publicationId,
                isLiked,
              ),
              onUsersLikedScreenClicked: onUsersLikedScreenClicked,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
            ),
            Icon(
              Icons.messenger_outline,
              color: AppColors.black,
            ),
          ],
        ),
      );
}