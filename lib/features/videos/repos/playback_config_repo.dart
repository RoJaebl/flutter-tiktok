import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  static const String _autoplay = "autoplay";
  static const String _muted = "muted";
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  PlaybackConfigRepository();

  Future<void> setMuted(bool value) async {
    await _prefs.then((prefs) async => await prefs.setBool(_muted, value));
  }

  Future<void> setAutoplay(bool value) async {
    await _prefs.then((prefs) async => await prefs.setBool(_autoplay, value));
  }

  Future<bool> isMuted() async {
    return await _prefs.then((prefs) => prefs.getBool(_muted) ?? false);
  }

  Future<bool> isAutoplay() async {
    return await _prefs.then((prefs) => prefs.getBool(_autoplay) ?? false);
  }
}

final playbackRepo = Provider(
  (ref) => PlaybackConfigRepository(),
);
