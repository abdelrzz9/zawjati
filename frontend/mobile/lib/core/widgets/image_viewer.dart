import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../theme/app_theme_colors.dart';

class ZawjatiImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;
  final List<String>? galleryUrls;
  final int initialIndex;

  const ZawjatiImageViewer({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.galleryUrls,
    this.initialIndex = 0,
  });

  @override
  State<ZawjatiImageViewer> createState() => _ZawjatiImageViewerState();
}

class _ZawjatiImageViewerState extends State<ZawjatiImageViewer> {
  late int _currentIndex;
  late PageController _pageController;

  List<String> get _urls =>
      widget.galleryUrls ?? [widget.imageUrl];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _share() async {
    await Share.share(_urls[_currentIndex]);
  }

  void _download() async {
    final url = _urls[_currentIndex];
    try {
      final dir = await getTemporaryDirectory();
      final filename = p.basename(Uri.parse(url).path);
      final savePath = '${dir.path}/$filename';

      final dio = Dio();
      await dio.download(url, savePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Image downloaded'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppThemeColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to download image'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppThemeColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _urls.length > 1
            ? Text(
                '${_currentIndex + 1} / ${_urls.length}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _share,
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: _download,
          ),
        ],
      ),
      body: _urls.length > 1
          ? PhotoViewGallery.builder(
              pageController: _pageController,
              itemCount: _urls.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(_urls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  heroAttributes: widget.heroTag != null
                      ? PhotoViewHeroAttributes(tag: '${widget.heroTag}_$index')
                      : null,
                );
              },
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : PhotoView(
              imageProvider: CachedNetworkImageProvider(_urls.first),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              heroAttributes: widget.heroTag != null
                  ? PhotoViewHeroAttributes(tag: widget.heroTag!)
                  : null,
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
    );
  }
}
