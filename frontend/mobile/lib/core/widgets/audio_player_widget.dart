import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiAudioPlayer extends StatefulWidget {
  final String url;
  final String? filename;
  final bool autoPlay;

  const ZawjatiAudioPlayer({
    super.key,
    required this.url,
    this.filename,
    this.autoPlay = false,
  });

  @override
  State<ZawjatiAudioPlayer> createState() => _ZawjatiAudioPlayerState();
}

class _ZawjatiAudioPlayerState extends State<ZawjatiAudioPlayer> {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _player.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });

    _player.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _duration = dur);
    });

    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _position = Duration.zero);
    });

    await _player.setSourceUrl(widget.url);
    _player.setVolume(1.0);

    if (widget.autoPlay) {
      await _player.resume();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      if (_position >= _duration && _duration > Duration.zero) {
        await _player.seek(Duration.zero);
      }
      await _player.resume();
    }
  }

  void _seekTo(double value) {
    final pos = Duration(milliseconds: value.toInt());
    _player.seek(pos);
  }

  void _cycleSpeed() {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    final idx = speeds.indexOf(_speed);
    final next = speeds[(idx + 1) % speeds.length];
    setState(() => _speed = next);
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$min:$sec';
    }
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds).toDouble()
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.filename != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppThemeMetrics.spacingSm),
              child: Row(
                children: [
                  const Icon(Icons.audio_file_rounded,
                      size: 16, color: AppThemeColors.hintText),
                  const SizedBox(width: AppThemeMetrics.spacingSm),
                  Expanded(
                    child: Text(
                      widget.filename!,
                      style: AppThemeTextStyles.textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              InkWell(
                onTap: _togglePlay,
                borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppThemeColors.primaryAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppThemeMetrics.spacingSm),
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppThemeColors.primaryAccent,
                        inactiveTrackColor: AppThemeColors.neutral600,
                        thumbColor: AppThemeColors.primaryAccent,
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayColor:
                            AppThemeColors.primaryAccent.withValues(alpha: 0.12),
                      ),
                      child: Slider(
                        value: progress.clamp(0.0, 1.0),
                        onChanged: _seekTo,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppThemeColors.hintText,
                              fontFamily: 'monospace',
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppThemeColors.hintText,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppThemeMetrics.spacingSm),
              InkWell(
                onTap: _cycleSpeed,
                borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
                    border: Border.all(
                      color: AppThemeColors.border,
                      width: AppThemeMetrics.borderHairline,
                    ),
                  ),
                  child: Text(
                    '${_speed}x',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppThemeColors.primaryAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
