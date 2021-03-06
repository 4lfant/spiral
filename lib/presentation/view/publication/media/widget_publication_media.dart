import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dairo/domain/model/publication/media.dart';
import 'package:dairo/presentation/res/colors.dart';
import 'package:dairo/presentation/view/base/full_screen_publication_media_widget.dart';
import 'package:flutter/material.dart';

class WidgetPublicationMediaPreview extends StatelessWidget {
  final List<RemoteMediaFile> mediaFiles;
  final int currentIndex;

  WidgetPublicationMediaPreview(this.mediaFiles, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    final file = mediaFiles[currentIndex];
    return FullScreenPublicationMediaWidget(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: file.previewPath,
            fit: BoxFit.cover,
          ),
          file.type == MediaType.video
              ? Align(
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0x80000000),
                    child: Icon(
                      Icons.play_arrow,
                      color: AppColors.black,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      remoteMediaFiles: mediaFiles,
      currentIndex: currentIndex,
    );
  }
}

class WidgetPublicationMediaCarouselPreview extends StatefulWidget {
  final List<RemoteMediaFile> mediaFiles;

  WidgetPublicationMediaCarouselPreview(this.mediaFiles);

  @override
  State<StatefulWidget> createState() =>
      WidgetPublicationMediaCarouselPreviewState();
}

class WidgetPublicationMediaCarouselPreviewState
    extends State<WidgetPublicationMediaCarouselPreview> {
  final CarouselController carouselController = CarouselController();
  int currentMediaCarouselIndex = 0;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider(
            items: widget.mediaFiles.map((file) {
              int position = widget.mediaFiles.indexOf(file);
              return WidgetPublicationMediaPreview(widget.mediaFiles, position);
            }).toList(),
            carouselController: carouselController,
            options: CarouselOptions(
              aspectRatio: 1,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              disableCenter: true,
              onPageChanged: onCarouselPageChanged,
            ),
          ),
          if (widget.mediaFiles.length > 1)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Color(0x80000000),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Text(
                  "${currentMediaCarouselIndex + 1}/${widget.mediaFiles.length}",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (currentMediaCarouselIndex != 0)
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0x40000000),
                        child: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: AppColors.white,
                          ),
                          onPressed: () => carouselController.previousPage(),
                        ),
                      )
                    : SizedBox.shrink(),
                (currentMediaCarouselIndex != widget.mediaFiles.length - 1)
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0x40000000),
                        child: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color: AppColors.white,
                          ),
                          onPressed: () => carouselController.nextPage(),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      );

  void onCarouselPageChanged(int index, CarouselPageChangedReason reason) =>
      setState(() => currentMediaCarouselIndex = index);
}
