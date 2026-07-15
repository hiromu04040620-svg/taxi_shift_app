import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/banner_ad_loader.dart';
import '../../core/theme/design_tokens.dart';

class BannerAdWidget extends StatefulWidget {
  static final BannerAdLoader _defaultLoader = GoogleBannerAdLoader();

  final String adUnitId;
  final BannerAdLoader loader;

  BannerAdWidget({super.key, required this.adUnitId, BannerAdLoader? loader})
    : loader = loader ?? _defaultLoader;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  LoadedBannerAd? _loadedAd;
  int? _requestedWidth;
  int _requestGeneration = 0;
  bool _loadFailed = false;

  @override
  void didUpdateWidget(BannerAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId == widget.adUnitId &&
        identical(oldWidget.loader, widget.loader)) {
      return;
    }

    _requestGeneration += 1;
    _requestedWidth = null;
    _loadFailed = false;
    final previousAd = _loadedAd;
    _loadedAd = null;
    if (previousAd != null) unawaited(previousAd.dispose());
  }

  @override
  void dispose() {
    _requestGeneration += 1;
    final loadedAd = _loadedAd;
    if (loadedAd != null) unawaited(loadedAd.dispose());
    super.dispose();
  }

  void _scheduleLoad(int width) {
    if (width <= 0 || width == _requestedWidth) return;
    _requestedWidth = width;
    _loadFailed = false;
    final generation = ++_requestGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && generation == _requestGeneration) {
        unawaited(_load(width, generation));
      }
    });
  }

  Future<void> _load(int width, int generation) async {
    final previousAd = _loadedAd;
    if (previousAd != null) {
      if (mounted && generation == _requestGeneration) {
        setState(() => _loadedAd = null);
      }
      await previousAd.dispose();
    }

    final loadedAd = await widget.loader.load(
      adUnitId: widget.adUnitId,
      width: width,
    );
    if (!mounted || generation != _requestGeneration) {
      await loadedAd?.dispose();
      return;
    }

    setState(() {
      _loadedAd = loadedAd;
      _loadFailed = loadedAd == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        _scheduleLoad(availableWidth.floor());

        if (_loadFailed) return const SizedBox.shrink();

        final loadedAd = _loadedAd;
        final height = loadedAd?.height.toDouble() ?? AppSpacing.bannerHeight;
        return SafeArea(
          top: false,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: SizedBox(
              height: height,
              child: loadedAd == null
                  ? const SizedBox.expand()
                  : Center(
                      child: SizedBox(
                        width: loadedAd.width.toDouble(),
                        height: height,
                        child: loadedAd.view,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
