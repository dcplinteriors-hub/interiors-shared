import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// A compact audio player — play/pause, a draggable seek bar, and a
/// `position / duration` readout — for reviewing voice-note attachments. Resolves
/// [urlFuture] (a short-lived signed URL) once, then streams playback.
///
/// Holds only colour-agnostic UI (icons + mm:ss); the single piece of copy, the
/// load-error message, is passed in via [errorLabel] so the widget stays free of
/// app-specific localisation and can live in the shared package.
class AudioPlayerBar extends StatefulWidget {
  const AudioPlayerBar({
    super.key,
    required this.urlFuture,
    required this.errorLabel,
  });

  /// Resolves to the signed URL of the clip (resolved + cached by the caller).
  final Future<String> urlFuture;

  /// Shown when the URL can't be resolved or the source fails to load.
  final String errorLabel;

  @override
  State<AudioPlayerBar> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends State<AudioPlayerBar> {
  final AudioPlayer _player = AudioPlayer();
  final List<StreamSubscription<dynamic>> _subs = [];

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _playing = false;
  bool _ready = false;
  bool _error = false;
  double? _dragMs; // non-null while the user is scrubbing the seek bar

  @override
  void initState() {
    super.initState();
    _subs
      ..add(
        _player.onDurationChanged.listen((d) {
          if (mounted) setState(() => _duration = d);
        }),
      )
      ..add(
        _player.onPositionChanged.listen((p) {
          if (mounted && _dragMs == null) setState(() => _position = p);
        }),
      )
      ..add(
        _player.onPlayerStateChanged.listen((s) {
          if (mounted) setState(() => _playing = s == PlayerState.playing);
        }),
      )
      ..add(
        _player.onPlayerComplete.listen((_) {
          if (mounted) {
            setState(() {
              _playing = false;
              _position = Duration.zero;
            });
          }
        }),
      );
    _load();
  }

  Future<void> _load() async {
    try {
      final url = await widget.urlFuture;
      await _player.setSourceUrl(url);
      final d = await _player.getDuration();
      if (!mounted) return;
      setState(() {
        _ready = true;
        if (d != null) _duration = d;
      });
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.pause();
    } else {
      // Replay from the start if we're sitting at the end.
      if (_duration > Duration.zero && _position >= _duration) {
        await _player.seek(Duration.zero);
      }
      await _player.resume();
    }
  }

  static String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (_error) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 18, color: scheme.error),
          const SizedBox(width: 6),
          Text(widget.errorLabel, style: TextStyle(color: scheme.error)),
        ],
      );
    }

    final maxMs = _duration.inMilliseconds.toDouble();
    final hasDur = maxMs > 0;
    final posMs = (_dragMs ?? _position.inMilliseconds.toDouble()).clamp(
      0.0,
      hasDur ? maxMs : 1.0,
    );
    final shownPos = _dragMs != null
        ? Duration(milliseconds: _dragMs!.round())
        : _position;

    return Container(
      padding: const EdgeInsets.fromLTRB(4, 2, 12, 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _ready ? _toggle : null,
            iconSize: 34,
            color: scheme.primary,
            icon: Icon(
              _playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
            ),
          ),
          SizedBox(
            width: 168,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              ),
              child: Slider(
                min: 0,
                max: hasDur ? maxMs : 1,
                value: posMs,
                onChanged: _ready && hasDur
                    ? (v) => setState(() => _dragMs = v)
                    : null,
                onChangeEnd: (v) async {
                  await _player.seek(Duration(milliseconds: v.round()));
                  if (mounted) {
                    setState(() {
                      _position = Duration(milliseconds: v.round());
                      _dragMs = null;
                    });
                  }
                },
              ),
            ),
          ),
          Text(
            // WebM clips recorded in-browser sometimes report no duration until
            // played through — show just the elapsed time until we know the total.
            hasDur ? '${_fmt(shownPos)} / ${_fmt(_duration)}' : _fmt(shownPos),
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
